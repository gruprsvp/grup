-- Accepting the terms of service (docs/billing-and-entitlements.md 8.6).
-- Everyone accepts each version once, at sign-up or the next sign-in.

-- The version in force, e.g. its effective date '2026-11-15'. Null asks
-- nobody to accept anything: self-hosted installs, and the hosted service
-- until the terms are published.
alter table billing.config add column terms_version text;

-- Who accepted which version, and when: the record the terms promise (2.7).
create table public.terms_acceptances (
  user_id     uuid not null default auth.uid() references auth.users on delete cascade,
  version     text not null,
  accepted_at timestamptz not null default now(),
  primary key (user_id, version)
);
comment on table public.terms_acceptances is 'Which version of the terms each user accepted, and when';

alter table public.terms_acceptances enable row level security;
create policy "Users read their own acceptances" on public.terms_acceptances
  for select to authenticated using (user_id = (select auth.uid()));
-- accepted_at = now(): the time is the server's, never a backdated one.
create policy "Users record their own acceptances" on public.terms_acceptances
  for insert to authenticated
  with check (user_id = (select auth.uid()) and accepted_at = now());
-- No update or delete policy: a record of acceptance doesn't change.
grant select, insert, update, delete on public.terms_acceptances to authenticated, service_role;

-- As 20261025140000, plus the terms: their version and whether the user
-- accepted it.
create or replace function public.billing_state()
returns jsonb language sql stable security definer set search_path = '' as $$
  select jsonb_build_object(
    'mode', c.mode,
    'is_founder', exists (select 1 from auth.users u
                           where u.id = auth.uid() and u.created_at < c.cutoff_at),
    'is_customer', exists (select 1 from billing.customers bc
                            where bc.user_id = auth.uid() and bc.stripe_customer_id is not null),
    'terms_version', c.terms_version,
    'terms_accepted', exists (select 1 from public.terms_acceptances t
                               where t.user_id = auth.uid() and t.version = c.terms_version),
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
