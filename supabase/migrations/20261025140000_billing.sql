-- Paid plans (docs/billing-and-entitlements.md, Phase 0).
--
-- The billing schema is private: not in the Data API's exposed schemas, and
-- no API role holds a privilege on it (revoked explicitly at the end, whatever
-- this environment's defaults grant). Clients use public.billing_state();
-- Edge Functions connect as postgres through SUPABASE_DB_URL.
create schema billing;

create type billing.mode as enum ('unlocked', 'prelaunch', 'live');
create type billing.status as enum (
  'trialing', 'active', 'grace', 'canceled_pending',  -- entitled
  'billing_retry', 'expired'                          -- not entitled
);

create table billing.config (
  id        boolean primary key default true check (id),  -- single row
  mode      billing.mode not null default 'unlocked',
  cutoff_at timestamptz,  -- A: accounts and groups created before it are founders and legacy
  constraint live_requires_cutoff check (mode <> 'live' or cutoff_at is not null)
);
insert into billing.config default values;

create table billing.plans (
  id       uuid primary key default gen_random_uuid(),
  code     text not null,
  version  int  not null default 1,
  rank     int  not null,  -- higher = more capable; for display and recommendations
  features text[] not null default '{}',
  limits   jsonb  not null default '{}',
  current  boolean not null default true,
  unique (code, version)
);
create unique index plans_one_current on billing.plans (code) where current;

create table billing.prices (
  id                uuid primary key default gen_random_uuid(),
  plan_id           uuid not null references billing.plans,  -- the version new purchases get
  provider          text not null check (provider in ('stripe', 'app_store', 'play_store')),
  provider_price_id text not null,  -- Stripe lookup key | store product id
  interval          text not null check (interval in ('month', 'year')),
  amounts           jsonb,          -- display only, minor units: {"CHF":900,"EUR":900,"USD":900}
  active            boolean not null default true,
  unique (provider, provider_price_id)
);
create index on billing.prices (plan_id);

create table billing.customers (
  id                 uuid primary key default gen_random_uuid(),
  user_id            uuid unique references auth.users on delete set null,  -- row kept for accounting
  stripe_customer_id text unique,
  created_at         timestamptz not null default now()
);

create table billing.subscriptions (
  id                   uuid primary key default gen_random_uuid(),
  customer_id          uuid not null references billing.customers,
  provider             text not null check (provider in ('stripe', 'app_store', 'play_store', 'manual')),
  provider_ref         text not null,  -- Stripe subscription id | '<store>:<user id>' | invoice reference
  price_id             uuid references billing.prices,
  plan_id              uuid not null references billing.plans,
  group_id             uuid references public.groups on delete set null,  -- the group it funds
  status               billing.status not null,
  current_period_end   timestamptz,    -- for 'grace': when the grace period ends
  cancel_at_period_end boolean not null default false,
  sandbox              boolean not null default false,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  unique (provider, provider_ref)
);
create index on billing.subscriptions (customer_id);
create index on billing.subscriptions (group_id);
create index on billing.subscriptions (price_id);
create index on billing.subscriptions (plan_id);

create table billing.grants (
  id         uuid primary key default gen_random_uuid(),
  group_id   uuid not null references public.groups on delete cascade,
  source     text not null check (source in ('legacy', 'founder_trial', 'early_access', 'manual')),
  features   text[] not null default '{}',
  limits     jsonb  not null default '{}',
  ends_at    timestamptz,
  note       text,
  created_at timestamptz not null default now()
);
create index on billing.grants (group_id);

create function billing.entitled(p_status billing.status)
returns boolean language sql immutable set search_path = '' as $$
  select p_status in ('trialing', 'active', 'grace', 'canceled_pending')
$$;

-- A group's entitlements: features, limits and where they come from.
-- Features are unioned; per limit, JSON null (unlimited) wins, else the maximum.
create function billing.entitlements(p_group_id uuid)
returns jsonb language sql stable security definer set search_path = '' as $$
  with sources as (
    select p.features, p.limits, null::jsonb as source
      from billing.plans p
     where p.code = 'free' and p.current
    union all
    select g.features, g.limits,
           jsonb_build_object('kind', 'grant', 'source', g.source, 'until', g.ends_at)
      from billing.grants g
     where g.group_id = p_group_id and (g.ends_at is null or g.ends_at > now())
    union all
    select p.features, p.limits,
           jsonb_build_object('kind', 'subscription', 'plan', p.code, 'rank', p.rank,
                              'provider', s.provider, 'status', s.status, 'payer', c.user_id,
                              'until', s.current_period_end, 'renews', not s.cancel_at_period_end)
      from billing.subscriptions s
      join billing.plans p     on p.id = s.plan_id
      join billing.customers c on c.id = s.customer_id
     where s.group_id = p_group_id
       and billing.entitled(s.status)
       -- after missed webhooks, stop honouring a period a week after it ended
       and (s.current_period_end is null or s.current_period_end > now() - interval '7 days')
  )
  select jsonb_build_object(
    'features', case cfg.mode
      when 'unlocked'  then (select coalesce(jsonb_agg(distinct f), '[]')
                               from billing.plans p, unnest(p.features) f)
      when 'prelaunch' then '[]'::jsonb
      else (select coalesce(jsonb_agg(distinct f), '[]') from sources s, unnest(s.features) f)
    end,
    'limits', case when cfg.mode = 'live' then (
      select coalesce(jsonb_object_agg(l.key, l.value), '{}')
        from (select key,
                     case when bool_or(value = 'null') then 'null'::jsonb
                          else to_jsonb(max(value::text::numeric) filter (where value <> 'null')) end as value
                from sources s, jsonb_each(s.limits)
               group by key) l)
      else '{}'::jsonb
    end,
    'sources', (select coalesce(jsonb_agg(s.source), '[]') from sources s where s.source is not null))
  from billing.config cfg
$$;

create function billing.has_feature(p_group_id uuid, p_key text)
returns boolean language sql stable security definer set search_path = '' as $$
  select billing.entitlements(p_group_id) -> 'features' ? p_key
$$;

-- null = unlimited
create function billing.limit_value(p_group_id uuid, p_key text)
returns int language sql stable security definer set search_path = '' as $$
  select (billing.entitlements(p_group_id) -> 'limits' ->> p_key)::int
$$;

-- Switch mode; also the kill switch (15.5). 'live' needs launch() first.
create function billing.set_mode(p_mode billing.mode)
returns void language sql security definer set search_path = '' as $$
  update billing.config set mode = p_mode
$$;

-- One-shot, run by an operator at D with A as the cutoff (11).
create function billing.launch(p_cutoff timestamptz)
returns void language plpgsql security definer set search_path = '' as $$
declare c billing.config;
begin
  select * into c from billing.config for update;
  if c.cutoff_at is not null then raise exception 'already launched (cutoff %)', c.cutoff_at; end if;
  if c.mode <> 'prelaunch' then raise exception 'launch needs prelaunch mode, not %', c.mode; end if;
  -- A is announced before D: a later cutoff would leave groups created
  -- between now and then without their legacy grants.
  if p_cutoff > now() then raise exception 'cutoff % is in the future', p_cutoff; end if;

  insert into billing.grants (group_id, source, limits, note)
  select g.id, 'legacy', '{"max_seats": null}', 'Created before the announcement'
    from public.groups g where g.created_at < p_cutoff;

  -- From D (now), not from A: the 6 months start when billing does.
  insert into billing.grants (group_id, source, features, ends_at, note)
  select g.id, 'founder_trial', p.features, now() + interval '6 months', 'Community included for founders'
    from public.groups g, billing.plans p
   where g.created_at < p_cutoff and p.code = 'community_s' and p.current;

  update billing.config set cutoff_at = p_cutoff, mode = 'live';
end $$;

-- Catalogue, contents subject to the B1 audit.
insert into billing.plans (code, rank, features, limits) values
  ('free',        0,  '{}',                                      '{"max_seats": 10}'),
  ('community_s', 10, '{kitchen_view,reply_cutoffs,export_csv}', '{"max_seats": 20}'),
  ('community_m', 20, '{kitchen_view,reply_cutoffs,export_csv}', '{"max_seats": 40}'),
  ('community_l', 30, '{kitchen_view,reply_cutoffs,export_csv}', '{"max_seats": 80}');

-- ── Seat cap (6.2) ───────────────────────────────────────────────────────────
-- Checked when a seat is taken: an admin inviting someone, or an account
-- member added without an invite. Following an invite never fails: the
-- invite already holds its seat.

create function billing.seats(p_group_id uuid)
returns int language sql stable security definer set search_path = '' as $$
  select count(*)::int
    from public.members m
   where m.group_id = p_group_id
     and (m.profile_id is not null
          or exists (select 1 from public.invites i where i.member_id = m.id))
$$;

-- Raises group_full if p_member_id would take a new seat in a full group.
create function billing.take_seat(p_group_id uuid, p_member_id uuid)
returns void language plpgsql security definer set search_path = '' as $$
declare v_limit int := billing.limit_value(p_group_id, 'max_seats');
begin
  if v_limit is null then return; end if;
  -- Serialise seat-taking per group: the app sends invites in parallel.
  perform pg_advisory_xact_lock(hashtextextended(p_group_id::text, 0));
  if exists (select 1 from public.members m
              where m.id = p_member_id
                and (m.profile_id is not null
                     or exists (select 1 from public.invites i where i.member_id = m.id))) then
    return;  -- already holds a seat (another invite for the same person)
  end if;
  if billing.seats(p_group_id) >= v_limit then
    raise exception using errcode = 'P0001', message = 'group_full';
  end if;
end $$;

create function billing.tg_invite_seat()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  perform billing.take_seat((select m.group_id from public.members m where m.id = new.member_id),
                            new.member_id);
  return new;
end $$;

create trigger invites_take_seat before insert on public.invites
  for each row execute function billing.tg_invite_seat();

-- Backstop for an account linked without an invite (an admin writing
-- profile_id directly). Invite redemption passes: its invite still exists
-- when the member row is updated.
create function billing.tg_member_seat()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  -- A member moved to another group would bring a seat the cap never counted
  -- (an admin of both groups could fill one past its limit). Nothing in the
  -- app moves members, so moving is refused, as row-level security refuses it
  -- to the member themselves.
  if tg_op = 'UPDATE' and new.group_id <> old.group_id then
    raise exception using errcode = '42501', message = 'a member can''t move to another group';
  end if;
  if new.profile_id is null or (tg_op = 'UPDATE' and old.profile_id is not null) then
    return new;
  end if;
  perform billing.take_seat(new.group_id, new.id);
  return new;
end $$;

create trigger members_take_seat before insert or update of profile_id, group_id on public.members
  for each row execute function billing.tg_member_seat();

-- ── Client RPC (6.3) ─────────────────────────────────────────────────────────
-- Everything the app needs, in one call: the mode, the user's groups'
-- entitlements and seats, and the catalogue. is_customer: the user has a
-- Stripe customer, so the web shows Settings → Billing (8.5).
create function public.billing_state()
returns jsonb language sql stable security definer set search_path = '' as $$
  select jsonb_build_object(
    'mode', c.mode,
    'is_founder', exists (select 1 from auth.users u
                           where u.id = auth.uid() and u.created_at < c.cutoff_at),
    'is_customer', exists (select 1 from billing.customers bc
                            where bc.user_id = auth.uid() and bc.stripe_customer_id is not null),
    'groups', coalesce((
      select jsonb_object_agg(m.group_id,
               billing.entitlements(m.group_id) || jsonb_build_object('seats', billing.seats(m.group_id)))
        from public.members m
       where m.profile_id = auth.uid()), '{}'),
    'catalog', coalesce((
      select jsonb_agg(jsonb_build_object(
               'plan', p.code, 'rank', p.rank, 'features', p.features, 'limits', p.limits,
               'prices', coalesce((
                 select jsonb_agg(jsonb_build_object('provider', pr.provider, 'id', pr.provider_price_id,
                                                     'interval', pr.interval, 'amounts', pr.amounts))
                   from billing.prices pr
                  where pr.plan_id = p.id and pr.active), '[]'))
               order by p.rank)
        from billing.plans p
       where p.current and p.code <> 'free'), '[]'))
  from billing.config c
$$;
comment on function public.billing_state() is 'The billing mode, the user''s groups'' entitlements and seats, and the plan catalogue';

revoke execute on function public.billing_state() from public, anon;
grant execute on function public.billing_state() to authenticated;

-- Design rule 5, whatever this environment's default privileges grant.
-- Triggers still fire: EXECUTE on a trigger function is only checked when the
-- trigger is created.
revoke all on schema billing from public, anon, authenticated, service_role;
revoke all on all tables in schema billing from public, anon, authenticated, service_role;
revoke all on all sequences in schema billing from public, anon, authenticated, service_role;
revoke all on all functions in schema billing from public, anon, authenticated, service_role;
