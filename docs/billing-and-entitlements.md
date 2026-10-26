# Paid plans: billing and entitlements

Design and implementation plan.

| | |
|---|---|
| Status | Phases 0 and 1 implemented as the PR stack in 17, not yet deployed (see 1.4). Phase 2 waits for the 12.1 spike. |
| Last updated | 2026-10-26 |
| Scope | Grup app (Flutter: iOS, Android, web) and its Supabase backend |
| Seller of record | Sealambda GmbH (Switzerland) |

---

## 1. Summary

Grup sells plans **per group**. Any admin of a group can pay for it; the subscription then *funds* that group.

What a group can do (its *entitlements*) is computed in Postgres, on every read, from three sources:

- the free plan,
- *grants* (grandfathering, comps, early access),
- the entitled subscription that funds the group.

Payment providers only report subscription state. They never decide what a group gets.

| Phase | Delivers | User-visible change |
|---|---|---|
| **0 — Foundation** | `billing` schema, entitlements function, seat cap, `launch()`, entitlements in the app's repositories | None. Production runs in `prelaunch`. |
| **1 — Web billing** | Stripe Checkout, Customer Portal and webhook; three pro features; launch | Plans can be bought on the web. Pro features appear on web and Android. |
| **2 — In-app purchases** | RevenueCat, App Store and Google Play, in-app paywall, pro features on iOS | Plans can be bought inside the apps. |

Phase 2 starts when about 20 groups are paying, or when admins who only use the mobile apps ask for it.

### 1.1 Fixed decisions

| # | Decision |
|---|---|
| F1 | Postgres decides entitlements. Stripe and RevenueCat only report subscription state. |
| F2 | Any admin of a group can buy for it. A subscription funds one group. |
| F3 | Pricing is by band of **seats**: Free up to 10, Community S up to 20, M up to 40, L up to 80. Monthly 9, 19 and 35; annual is 10× monthly. Same number in CHF, EUR and USD, VAT included. |
| F4 | A seat is a member with an account, or a member with a pending invite. Members the admins manage (no account, no invite) are free and unlimited. |
| F5 | Code checks feature keys and limit keys, never plan names. |
| F6 | What Grup does on the announcement date A stays free forever. Groups that exist on A never have a seat limit. |
| F7 | Billing never deletes data or settings and never blocks replies. Losing a feature stops its behaviour and hides its screens; paying again restores both. |
| F8 | Self-hosted installs default to `unlocked`: every feature, no limits, no billing UI. |
| F9 | Phase 1 sells on the web only. The native apps show no prices and no purchase UI and never link to web checkout until Phase 2 adds in-app purchases. |

### 1.2 Design rules

These keep the system small. Anything that breaks one of them needs a reason in its PR.

1. **No recurrence in SQL.** Occurrences, default rules and RSVP resolution stay in Dart (`lib/models/rsvp.dart`). Server code only uses what is stored: `replies.instance_date`, `schedules`, `members`, `invites`.
2. **Entitlements are computed on read**, by one SQL function. Nothing is stored, so there are no recompute triggers, no backfill, no expiry job and nothing to go stale.
3. **Webhooks are triggers, not data.** Every webhook fetches the subscription's current state from the provider and upserts it, so duplicates and ordering don't matter and no event log is needed.
4. **Enforce on the server only what changes behaviour.** Seat caps and reply cutoffs are enforced in Postgres. Features that only present data members can already read (kitchen view, CSV export) are gated in the app.
5. **The `billing` schema is private.** It is not exposed through the Data API, and no API role holds a privilege on it. Clients use one RPC; Edge Functions connect to the database directly.
6. **Keys, not plans** (F5).

### 1.3 Out of scope

- One subscription funding several groups (bundles), several payers funding one group (chip-in), self-serve moving of funding between groups
- Collecting money from members, meal cost splitting
- Links from the apps to web checkout, including US link-out
- Different prices per channel
- Revenue analytics beyond the Stripe and RevenueCat dashboards

Each can be added without migrating data: bundles and chip-in replace `subscriptions.group_id` with a link table; moving is an update of `group_id`.

### 1.4 As built

Phases 0 and 1 are implemented as planned below, with these differences. The code is the reference; the listings in sections 6–10 are the plan it started from.

| Where | What |
|---|---|
| Migrations | `20261025140000_billing.sql` (6.1–6.3), `20261025140100_billing_stripe.sql` (8.2), `20261025140200_reply_cutoffs.sql` (9.2) |
| pgTAP | `supabase/tests/billing_test.sql`, `supabase/tests/reply_cutoffs_test.sql` |
| Edge Functions | `billing-checkout`, `billing-portal`, `stripe-webhook`; shared code in `_shared/billing.ts`, its pure parts (status mapping, request checks, the webhook handler) in `_shared/billing_logic.ts`, tested by `_shared/billing_logic_test.ts` (`deno test` in CI) |
| App | `models/billing.dart` (`BillingState`, `GroupAccess`, keys), `models/export.dart`, `services/billing.dart`, `repositories/billing.dart`; plan page (`GroupPlanRoute`), kitchen view (`GroupKitchenRoute`), cutoffs in the event editor and on reply controls, export in Manage, Settings → Billing |

Differences from the plan:

1. **Cutoffs read wall-clock times in the schedule's time zone.** The app stores an occurrence's start as its wall-clock time labelled UTC (18:00 is 18:00Z wherever the group meets), so `instance_date − cutoff` compared with `now()` would close answers an hour or two late in Europe and hours early in the Americas. `schedules.time_zone` (IANA, required with a cutoff, validated when set) holds the zone; the app writes it from the admin's device with the cutoff (`flutter_timezone`); `billing.reply_deadline()` computes the real deadline. The app shows locks and late changes in the device's zone (a `shortcut:` in `models/schedule.dart`).
2. **Deleting a member, a schedule or a group deletes its replies even after a cutoff.** The reply trigger skips cascades (`pg_trigger_depth() > 1`). Without that, a member with any past locked reply could neither leave nor be removed.
3. **Members can't move to another group.** An admin of two groups could otherwise fill one past its seat limit by moving members in. The seat trigger refuses a `group_id` change with `42501`, as row-level security already does for a member's own row.
4. **Guests take no seat.** The app used to give every new member a code invite, so under F4 every guest held a seat and a full group couldn't add one. A member invited with just a name now gets no invite: the admins answer for them, for free. Member details offers **Create an invite code** (takes a seat) and **Cancel invites** (frees it), which also makes "remove pending invites" in Appendix B possible. This ships before A, so no group created after A starts with coded guests.
5. **`billing_state()` also returns `is_customer`**: whether the user has a Stripe customer, for Settings → Billing (8.5).
6. **`launch()` refuses a cutoff in the future.** Groups created between the launch and such a cutoff would count as legacy without ever getting the grant.
7. **Edge Functions create their Stripe and Postgres clients on first use.** The Stripe SDK refuses to start without a key, and a self-hosted `billing-checkout` must still answer `billing_disabled`. Pinned: `npm:stripe@22.6.2` (API `2026-08-26.dahlia` unless `STRIPE_API_VERSION` says otherwise), `npm:postgres@3.4.9`. `supabase start` hands the local runtime a database host Deno can't resolve (`supabase_db_<project>`); `reachableDbUrl()` swaps it for the container's `db` alias.
8. **`delete_user_account` refuses to delete** when it can't set the user's entitled Stripe subscriptions to cancel at period end (10): better than charging a payer who can no longer cancel.
9. **The export pages through replies** (`allPages`): PostgREST answers at most 1000 rows (`max_rows`), and a year of a large group's replies is far more. The CSV keeps names that start with `= + - @` as text (spreadsheet formula injection) and starts with a byte order mark so spreadsheets read UTF-8. Phones share it with `share_plus`; the web downloads it (`XFile.saveTo`), because `share_plus` would open the system share sheet in every desktop browser that can share files, Chrome included, rather than fall back to a download.
10. **Print** (9.3) is built: `pdf` and `printing` render the day as an A4 PDF in the app's font.
11. **The `reply_locked` message has no time** ("Changes to this event have closed. Ask an admin."): the server's error doesn't carry it, and the reply controls already show "Changes closed at {time}".
12. **The plans are shown as Free, Crew, Club and Crowd**, in English in every language, with "spots" for seats. The codes and lookup keys stay `community_{s,m,l}`; only display names changed, so the Stripe products are renamed by hand in the dashboard (8.1, 3). The copy quoted in 8.5 is superseded by the ARB files. The plan page states the plan and its spots, and lists what every plan includes. "Choose a plan" opens a sheet that asks for the size (the smallest that fits is marked; a founding group, having no limit, goes straight to Crew), then monthly or yearly, then "Continue to payment". Manage → Members opens with the plan card, in place of the crown icon.

Verified on 2026-10-26, against local Supabase and the Stripe sandbox (test clocks, `stripe listen`):

- The 16.3 matrix, rows 1–7, passes. The checkout sessions came from `billing-checkout`; the subscriptions were then created through the API with the session's customer, price and `metadata.group_id`, because a hosted Checkout page can't be completed headlessly. Row 8 waits for B2.
- `billing-checkout` answers 500 until the Stripe account has a Terms of Service URL (`consent_collection`) and an active Stripe Tax setup (`automatic_tax`): B3 and B2 block checkout even in test mode.
- The sandbox's Customer Portal configuration (8.1, 5) is set and is the default. With every retry failed, the sandbox already cancels the subscription (8.1, 6).

---

## 2. Blocking inputs

| ID | Input | Blocks | Owner |
|---|---|---|---|
| B1 | **Capability audit.** List what Grup does today. Confirm that no part of `kitchen_view`, `reply_cutoffs` or `export_csv` exists, and that groups have no size limit. The home screen already shows who is coming to each event, so that stays free (F6); only the day view, the printable sheet and the late flags are new. | PR 0.1 | Product |
| B2 | **Tax mode.** Stripe Tax with Sealambda's own registrations (Swiss VAT, EU non-Union OSS), or Stripe Managed Payments if it is available to a Swiss account. Confirm with the fiduciary. Only Checkout parameters and Stripe settings differ. | PR 1.1 | Sealambda |
| B3 | **Legal texts.** Terms of Service section on subscriptions, renewal and cancellation; privacy policy listing Stripe and RevenueCat as processors; wording for the EU withdrawal right at checkout. Stripe Checkout and the App Store paywall need public URLs for these. | PR 1.1, PR 2.3 | Sealambda + counsel |
| B4 | **Dates.** The announcement date A, which is the cutoff for founders and legacy groups, and the launch date D, at least 14 days after A. | Launch | Product |

---

## 3. Glossary

| Term | Meaning |
|---|---|
| Admin | A member with `role = 'admin'`. A group can have several. |
| Seat | A member with an account (`members.profile_id is not null`) or with at least one pending invite. |
| Managed member | A member without an account or invite, whose replies admins manage. Never a seat. |
| Payer | A `billing.customers` row linked to a user. |
| Plan | A row of `billing.plans`: one version of a plan's features and limits. Existing subscribers keep the version they bought. |
| Price | Something sellable on one provider: a Stripe lookup key or a store product id. |
| Subscription | A provider-agnostic record of a payer's subscription and the group it funds. |
| Grant | Entitlements given to a group without payment: legacy, founder trial, early access, comp. |
| Feature key / limit key | Stable identifiers checked by code: `kitchen_view`, `max_seats`. |
| A | The announcement date. Accounts created before A are *founders*; groups created before A are *legacy groups*. |
| D | The launch date: production switches to `live`. |
| Mode | `unlocked` (self-host), `prelaunch` (hosted, before D) or `live`. |

---

## 4. Catalogue

### 4.1 Plans

| Code | Rank | `max_seats` | Features | Monthly | Annual |
|---|---|---|---|---|---|
| `free` | 0 | 10 | none | 0 | 0 |
| `community_s` | 10 | 20 | launch set | 9 | 90 |
| `community_m` | 20 | 40 | launch set | 19 | 190 |
| `community_l` | 30 | 80 | launch set | 35 | 350 |

Groups above 80 seats are invoiced manually (15.3).

### 4.2 Keys

| Key | Kind | Meaning |
|---|---|---|
| `max_seats` | limit | Seats a group may fill; JSON `null` or absent means unlimited |
| `kitchen_view` | feature | Day view of meal headcounts with names and late changes, printable |
| `reply_cutoffs` | feature | A per-schedule deadline after which members can't change replies |
| `export_csv` | feature | CSV export of replies over a date range |

Reserved for later features, not used until built: `daily_digest`, `roles`, `stats`, `ics_sync`, `cost_split`.

The keys live in the plans' `features` and `limits`, in `FeatureKey`/`LimitKey` in Dart, and in a pgTAP test that pins the set (16.1).

### 4.3 Grant sources

| Source | Gives | Created by | Ends |
|---|---|---|---|
| `legacy` | `{"max_seats": null}` | `billing.launch()`, for every group created before A | Never |
| `founder_trial` | Community features | `billing.launch()`, for every group created before A | D + 6 months |
| `early_access` | One new feature | Runbook 15.6, for legacy groups, when a feature ships | 60 days later |
| `manual` | Anything | Operations (15.1) | As set |

### 4.4 Changing the catalogue

- **Add a feature for all current and future subscribers:** append the key to the `features` of every current Community plan row, in place. It applies on the next read.
- **Remove a feature or tighten a limit:** insert a new plan row (version + 1), mark it `current`, and point the active prices at it. Existing subscriptions keep the version they bought, because a subscription's `plan_id` only changes when its price changes.
- A capability that existed on A never moves into a paid plan (F6).

---

## 5. Grandfathering

Promised in the announcement on A. Each is data or process, not special-case code.

| ID | Guarantee | Mechanism |
|---|---|---|
| G1 | Everything Grup does on A stays free, for everyone, forever. | B1 audit; catalogue rule 4.4 |
| G2 | Groups created before A never have a seat limit, whoever runs them. | `legacy` grant, no end |
| G3 | Groups created before A get Community features until D + 6 months. | `founder_trial` grant |
| G4 | Founders (accounts created before A) get 30% off Community for life, on the web. | Stripe coupon `founder-30` at checkout |
| G5 | Legacy groups get 60 days of early access to each new pro feature. | Runbook 15.6 |
| G6 | Billing never deletes data or blocks replies. Only cutoffs that admins set close replies. | F7 |

Groups created between A and D follow the normal rules from D, and the announcement says so. Using A rather than D as the cutoff means announcing doesn't reward signing up in the 14 days before launch.

---

## 6. Phase 0: schema and entitlements

One migration, one PR. Every merge to `main` runs `db push` on production, so the whole Phase 0 lands at once.

### 6.1 Migration `<ts>_billing.sql`

As built: `supabase/migrations/20261025140000_billing.sql`; differences in 1.4.

```sql
-- Paid plans (docs/billing-and-entitlements.md).
--
-- The billing schema is private: not in the Data API's exposed schemas, and
-- no API role holds a privilege on it. Since 20261023120000 new functions are
-- executable by no one but their owner outside public, so nothing here is
-- callable through the API. Clients use public.billing_state(); Edge
-- Functions connect as postgres through SUPABASE_DB_URL.
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
```

### 6.2 Seat cap (same migration)

The cap is checked when a seat is *taken*: when an admin invites someone, or when an account member is added without an invite. A full group therefore fails for the admin, who can upgrade or remove members, never for the person following an invite link. Following an invite never fails, because the invite already holds its seat.

A group over its limit, for example after a downgrade, keeps everyone and every pending invite. It only can't invite more until it is under the limit (F7). There is no grace state.

```sql
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
  if tg_op = 'UPDATE' and old.profile_id is not null then return new; end if;
  perform billing.take_seat(new.group_id, new.id);
  return new;
end $$;

create trigger members_take_seat before insert or update of profile_id on public.members
  for each row when (new.profile_id is not null)
  execute function billing.tg_member_seat();
```

Seats from pending invites stay taken until the invite is redeemed or an admin removes the member. The member screen should say "Pending invites use a seat".

### 6.3 Client RPC (same migration)

One call returns everything the app needs. `public` functions are executable by `authenticated` and not `anon` by default (`20261023120000`), so no grants are needed.

```sql
create function public.billing_state()
returns jsonb language sql stable security definer set search_path = '' as $$
  select jsonb_build_object(
    'mode', c.mode,
    'is_founder', exists (select 1 from auth.users u
                           where u.id = auth.uid() and u.created_at < c.cutoff_at),
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
```

### 6.4 Production step

After the Phase 0 deploy, run `select billing.set_mode('prelaunch');` on the hosted project. The migration leaves `unlocked` for self-hosters (F8). This has to happen before any build with pro screens ships; the Phase 1 PRs check it in their description.

---

## 7. Phase 0: app foundation

Billing follows the app's architecture: services, then repositories, then view models, then views.

| Layer | Adds |
|---|---|
| `models/billing.dart` | `@freezed` `BillingState` (mode, isFounder, catalog, entitlements by group id) and `GroupEntitlements` (features, limits, seats, sources). `FeatureKey` and `LimitKey` constants. `GroupAccess` (below). |
| `services/billing.dart` | `BillingService` (`SupabaseService`): `rpc('billing_state')`; in Phase 1, `functions.invoke('billing-checkout' / 'billing-portal')`. |
| `repositories/billing.dart` | `BillingRepository extends UserData`: caches `BillingState` per user, refreshes it when groups load and when a billing return lands, and returns `Result`. |
| `util/errors.dart` | `GroupFullException`, `FeatureLockedException` and `ReplyLockedException`, mapped from the `PostgrestException` message by `guard`. |
| `test/support/fake_backend.dart` | A fake `billing_state` with a settable mode and entitlements. |

Unknown modes from a newer server are treated as `prelaunch`: no pro screens and no billing UI.

```dart
// models/billing.dart

/// Flipped in the Phase 2 release. Compile-time on purpose: Phase 1 iOS
/// builds must never show pro screens, whatever the server says
/// (App Store Guideline 3.1.3(b)).
const kIapSupported = false;

/// The only place the UI asks "may this group show X here?".
/// [platform] is null on the web.
class GroupAccess {
  const GroupAccess(this.state, this.group, this.platform);

  final BillingState state;
  final GroupEntitlements group;
  final TargetPlatform? platform;

  /// The group has the feature. Use for effects, such as a reply locked by a cutoff.
  bool can(String feature) => group.features.contains(feature);

  /// Null means unlimited.
  int? limit(String key) => group.limits[key];

  /// The feature's own screens and settings may show on this platform.
  bool show(String feature) =>
      can(feature) &&
      (state.mode != BillingMode.live || platform != TargetPlatform.iOS || kIapSupported);

  /// Prices, plan pickers and upgrade prompts may show on this platform.
  bool get purchaseUi => state.mode == BillingMode.live && platform == null;
}
```

The server already folds the mode into `features` and `limits` (`unlocked` gives everything, `prelaunch` nothing), so the client doesn't branch on mode for features.

---

## 8. Phase 1: Stripe

### 8.1 Stripe configuration

Configure the test account (staging) and the live account (production) the same way, and record the ids in the PR.

1. **Business settings:** public details, and the Terms of Service URL (B3), which `consent_collection` needs.
2. **Tax (B2).** Stripe Tax: origin Switzerland, registrations for Switzerland and EU non-Union OSS, a SaaS tax code for consumer use. Managed Payments: follow Stripe's onboarding instead and adjust the Checkout parameters in 8.3.
3. **Products and prices:** three products (Grup Community S/M/L) and six recurring prices. Each uses USD as the default currency with `currency_options` for CHF and EUR, `tax_behavior = inclusive` on every currency (immutable), and these lookup keys:

   | Lookup key | Interval | Amount (USD, CHF, EUR) |
   |---|---|---|
   | `community_s_month` | month | 9.00 |
   | `community_s_year` | year | 90.00 |
   | `community_m_month` | month | 19.00 |
   | `community_m_year` | year | 190.00 |
   | `community_l_month` | month | 35.00 |
   | `community_l_year` | year | 350.00 |

4. **Coupon** `founder-30`: 30% off, duration `forever`, for the three products.
5. **Customer Portal:** allow updating the payment method, invoice history, cancelling at period end and switching between the six prices. No quantity changes. Upgrades prorate and invoice immediately; downgrades apply at the end of the period (or prorate immediately if the portal can't schedule them).
6. **Revenue recovery:** Smart Retries on; when all retries fail, **cancel the subscription**; failed-payment emails on.
7. **Payment methods:** cards, with Apple Pay and Google Pay. Leave out methods that can't recur.
8. **Webhook endpoint** `https://<project-ref>.supabase.co/functions/v1/stripe-webhook`, events `checkout.session.completed` and `customer.subscription.created`/`updated`/`deleted`, pinned to the SDK's API version. Make sure the account owner gets Stripe's emails about failing endpoints; they are the alert for missed webhooks (15.4).
9. **API key:** a restricted key for Customers, Checkout Sessions, Subscriptions, Prices (read) and Billing Portal, stored as `STRIPE_SECRET_KEY`.

### 8.2 Migration `<ts>_billing_stripe.sql`

As built: `supabase/migrations/20261025140100_billing_stripe.sql`.

```sql
insert into billing.prices (plan_id, provider, provider_price_id, interval, amounts)
select p.id, 'stripe', x.key, x.interval, x.amounts::jsonb
from (values
  ('community_s', 'community_s_month', 'month', '{"CHF":900,"EUR":900,"USD":900}'),
  ('community_s', 'community_s_year',  'year',  '{"CHF":9000,"EUR":9000,"USD":9000}'),
  ('community_m', 'community_m_month', 'month', '{"CHF":1900,"EUR":1900,"USD":1900}'),
  ('community_m', 'community_m_year',  'year',  '{"CHF":19000,"EUR":19000,"USD":19000}'),
  ('community_l', 'community_l_month', 'month', '{"CHF":3500,"EUR":3500,"USD":3500}'),
  ('community_l', 'community_l_year',  'year',  '{"CHF":35000,"EUR":35000,"USD":35000}')
) as x(code, key, interval, amounts)
join billing.plans p on p.code = x.code and p.current;

-- Upsert from the provider's current state; returns null for an unknown price.
-- Shared by Stripe and (Phase 2) the stores.
--  - plan_id changes only when the price does: renewals keep the version sold.
--  - group_id is taken from p_group_id when the subscription starts or comes
--    back from a non-entitled status, and only if the payer is that group's
--    admin. Otherwise it is left alone.
create function billing.upsert_subscription(
  p_customer_id uuid, p_provider text, p_ref text, p_price text, p_group_id uuid,
  p_status billing.status, p_period_end timestamptz, p_cancel boolean, p_sandbox boolean
) returns uuid language sql security definer set search_path = '' as $$
  insert into billing.subscriptions as s
    (customer_id, provider, provider_ref, price_id, plan_id, group_id,
     status, current_period_end, cancel_at_period_end, sandbox)
  select p_customer_id, p_provider, p_ref, pr.id, pr.plan_id,
         (select m.group_id from public.members m join billing.customers c on c.user_id = m.profile_id
           where c.id = p_customer_id and m.group_id = p_group_id and m.role = 'admin'),
         p_status, p_period_end, p_cancel, p_sandbox
    from billing.prices pr
   where pr.provider = p_provider and pr.provider_price_id = p_price
  on conflict (provider, provider_ref) do update set
    customer_id          = excluded.customer_id,
    price_id             = excluded.price_id,
    plan_id              = case when s.price_id is distinct from excluded.price_id
                                then excluded.plan_id else s.plan_id end,
    group_id             = case when not billing.entitled(s.status) and billing.entitled(excluded.status)
                                     and excluded.group_id is not null
                                then excluded.group_id else s.group_id end,
    status               = excluded.status,
    current_period_end   = excluded.current_period_end,
    cancel_at_period_end = excluded.cancel_at_period_end,
    sandbox              = excluded.sandbox,
    updated_at           = now()
  returning s.id
$$;

-- Subscriptions that need a human: paid but funding nothing (two admins paid
-- for one group, or the group was deleted), or a group funded twice.
create view billing.attention as
  select 'funds_no_group' as issue, s.id as subscription_id, null::uuid as group_id
    from billing.subscriptions s
   where billing.entitled(s.status) and s.group_id is null
  union all
  select 'group_funded_twice', null, s.group_id
    from billing.subscriptions s
   where billing.entitled(s.status) and s.group_id is not null
   group by s.group_id having count(*) > 1;
```

### 8.3 Edge Functions

As built in `supabase/functions/`; differences in 1.4 (7, 8).

There are three: `billing-checkout` and `billing-portal`, called by the web app with the user's JWT, and `stripe-webhook`, which has `verify_jwt = false` in `supabase/config.toml`. They share one module and follow `delete_user_account`: the secret key comes from `SUPABASE_SECRET_KEYS`, and CORS comes from `_shared/cors.ts`.

```ts
// supabase/functions/_shared/billing.ts
import { createClient } from "jsr:@supabase/supabase-js@2";
import postgres from "npm:postgres@<pinned>";
import Stripe from "npm:stripe@<pinned>";
import { corsHeaders } from "./cors.ts";

export const sql = postgres(Deno.env.get("SUPABASE_DB_URL")!, { prepare: false, max: 1 });
export const stripe = new Stripe(Deno.env.get("STRIPE_SECRET_KEY")!, {
  apiVersion: Deno.env.get("STRIPE_API_VERSION") as Stripe.LatestApiVersion,
  httpClient: Stripe.createFetchHttpClient(),
});
export const WEB = Deno.env.get("WEB_APP_URL")!; // e.g. https://grup.rsvp

const secretKey = JSON.parse(Deno.env.get("SUPABASE_SECRET_KEYS") || "{}").default ??
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
const admin = createClient(Deno.env.get("SUPABASE_URL")!, secretKey);

export class HttpError extends Error {
  constructor(public status: number, public code: string) { super(code); }
}

export const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, "Content-Type": "application/json" } });

/** CORS preflight, then errors as { error: code }. */
export const handle = (fn: (req: Request) => Promise<Response>) => async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  try { return await fn(req); } catch (e) {
    if (e instanceof HttpError) return json({ error: e.code }, e.status);
    console.error(e);
    return json({ error: "internal" }, 500);
  }
};

export async function requireUser(req: Request) {
  const token = req.headers.get("Authorization")?.split("Bearer ")[1];
  const { data, error } = token ? await admin.auth.getUser(token) : { data: { user: null }, error: null };
  if (error || !data.user) throw new HttpError(401, "not_authenticated");
  return data.user;
}

/** A web app address that returns to `path` after the app loads (8.4). */
export const appUrl = (path: string) => `${WEB}/?return=${encodeURIComponent(path)}`;

export function mapStripeStatus(sub: Stripe.Subscription): string | null {
  const ending = sub.cancel_at_period_end || sub.cancel_at != null;
  switch (sub.status) {
    case "trialing": return ending ? "canceled_pending" : "trialing";
    case "active": return ending ? "canceled_pending" : "active";
    case "past_due": return "grace";  // Smart Retries running
    case "unpaid": return "billing_retry";
    case "canceled": case "incomplete_expired": case "paused": return "expired";
    default: return null;             // "incomplete": wait for the next event
  }
}

/** Fetch the subscription's current state and upsert it. Safe to repeat, in any order. */
export async function syncStripeSubscription(id: string) {
  const sub = await stripe.subscriptions.retrieve(id);
  const status = mapStripeStatus(sub);
  if (status === null) return;
  const item = sub.items.data[0];
  // Since API 2025-03-31.basil the period lives on the item.
  const periodEnd = (item as any).current_period_end ?? (sub as any).current_period_end;
  const [row] = await sql`
    select billing.upsert_subscription(
      c.id, 'stripe', ${sub.id}, ${item.price.lookup_key}, ${sub.metadata?.group_id ?? null}::uuid,
      ${status}::billing.status, to_timestamp(${periodEnd}),
      ${sub.cancel_at_period_end || sub.cancel_at != null}, ${!sub.livemode}) as id
    from billing.customers c where c.stripe_customer_id = ${sub.customer as string}`;
  if (!row?.id) throw new Error(`unknown customer or price for ${sub.id}`);
}
```

#### `billing-checkout`

Request `{ group_id, plan, interval }`; response `{ url }`.

```ts
// supabase/functions/billing-checkout/index.ts
import { appUrl, handle, HttpError, json, requireUser, sql, stripe } from "../_shared/billing.ts";

const PLANS = new Set(["community_s", "community_m", "community_l"]);
const INTERVALS = new Set(["month", "year"]);
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

Deno.serve(handle(async (req) => {
  const user = await requireUser(req);
  const { group_id, plan, interval } = await req.json();
  if (!UUID.test(group_id) || !PLANS.has(plan) || !INTERVALS.has(interval)) {
    throw new HttpError(400, "invalid_plan");
  }

  const [ctx] = await sql`
    select c.mode,
           exists (select 1 from public.members m where m.group_id = ${group_id}
                     and m.profile_id = ${user.id} and m.role = 'admin') as is_admin,
           exists (select 1 from billing.subscriptions s
                    where s.group_id = ${group_id} and billing.entitled(s.status)) as funded,
           exists (select 1 from auth.users u
                    where u.id = ${user.id} and u.created_at < c.cutoff_at) as founder,
           (select max(g.ends_at) from billing.grants g
             where g.group_id = ${group_id} and g.source = 'founder_trial'
               and g.ends_at > now() + interval '48 hours') as trial_end
      from billing.config c`;
  if (ctx.mode !== "live") throw new HttpError(404, "billing_disabled");
  if (!ctx.is_admin) throw new HttpError(403, "not_admin");
  if (ctx.funded) throw new HttpError(409, "already_funded"); // band changes go through the portal

  const lookupKey = `${plan}_${interval}`;
  const { data: [price] } = await stripe.prices.list({ lookup_keys: [lookupKey], active: true, limit: 1 });
  if (!price) throw new HttpError(500, "price_not_configured");

  let [customer] = await sql`select id, stripe_customer_id from billing.customers where user_id = ${user.id}`;
  if (!customer?.stripe_customer_id) {
    const created = await stripe.customers.create(
      { email: user.email, metadata: { supabase_user_id: user.id } },
      { idempotencyKey: `customer-${user.id}` },
    );
    [customer] = await sql`
      insert into billing.customers (user_id, stripe_customer_id) values (${user.id}, ${created.id})
      on conflict (user_id) do update
        set stripe_customer_id = coalesce(billing.customers.stripe_customer_id, excluded.stripe_customer_id)
      returning id, stripe_customer_id`;
  }

  const plan_path = `/groups/${group_id}/plan`;
  const session = await stripe.checkout.sessions.create({
    mode: "subscription",
    customer: customer.stripe_customer_id,
    line_items: [{ price: price.id, quantity: 1 }],
    automatic_tax: { enabled: true },                       // Stripe Tax path (B2)
    billing_address_collection: "required",
    tax_id_collection: { enabled: true },
    customer_update: { address: "auto", name: "auto" },
    consent_collection: { terms_of_service: "required" },   // wording per B3
    discounts: ctx.founder ? [{ coupon: "founder-30" }] : undefined,
    subscription_data: {
      metadata: { group_id },
      // Founder groups have Community until the trial ends: bill from then.
      ...(ctx.trial_end ? { trial_end: Math.floor(new Date(ctx.trial_end).getTime() / 1000) } : {}),
    },
    success_url: appUrl(`${plan_path}?checkout=success`),
    cancel_url: appUrl(plan_path),
    locale: "auto",
  }, { idempotencyKey: `checkout-${user.id}-${group_id}-${lookupKey}-${Math.floor(Date.now() / 60_000)}` });

  return json({ url: session.url });
}));
```

If two admins pay for the same group at once, both payments go through. The second subscription is still upserted with the group, and `billing.attention` lists the group as `group_funded_twice`; operations refunds one (15.4).

#### `billing-portal`

```ts
// supabase/functions/billing-portal/index.ts
import { appUrl, handle, HttpError, json, requireUser, sql, stripe } from "../_shared/billing.ts";

Deno.serve(handle(async (req) => {
  const user = await requireUser(req);
  const [c] = await sql`select stripe_customer_id from billing.customers where user_id = ${user.id}`;
  if (!c?.stripe_customer_id) throw new HttpError(404, "no_customer");
  const { return_path } = await req.json().catch(() => ({}));
  const path = typeof return_path === "string" && return_path.startsWith("/") && !return_path.startsWith("//")
    ? return_path : "/";
  const session = await stripe.billingPortal.sessions.create({
    customer: c.stripe_customer_id, return_url: appUrl(path),
  });
  return json({ url: session.url });
}));
```

#### `stripe-webhook`

```ts
// supabase/functions/stripe-webhook/index.ts
import Stripe from "npm:stripe@<pinned>";
import { stripe, syncStripeSubscription } from "../_shared/billing.ts";

const cryptoProvider = Stripe.createSubtleCryptoProvider();

Deno.serve(async (req) => {
  let event: Stripe.Event;
  try {
    event = await stripe.webhooks.constructEventAsync(
      await req.text(), req.headers.get("stripe-signature") ?? "",
      Deno.env.get("STRIPE_WEBHOOK_SECRET")!, undefined, cryptoProvider);
  } catch {
    return new Response("invalid signature", { status: 400 });
  }
  const o = event.data.object as any;
  const subscriptionId = event.type === "checkout.session.completed"
    ? (o.mode === "subscription" ? o.subscription : null)
    : event.type.startsWith("customer.subscription.") ? o.id : null;
  try {
    if (subscriptionId) await syncStripeSubscription(subscriptionId);
    return new Response("ok");
  } catch (e) {
    console.error(event.id, e);
    return new Response("retry", { status: 500 }); // Stripe retries for 3 days
  }
});
```

There is no event log and no reconcile job: every delivery fetches current state, so duplicates and ordering don't matter. A webhook still failing after Stripe's 3 days of retries shows in the dashboard and in Stripe's failing-endpoint emails, and operations resend it from there. The 7-day stale guard in `billing.entitlements` stops a subscription whose cancellation was missed from being honoured indefinitely. If missed webhooks turn out to happen in practice, add a daily job that re-syncs every non-expired subscription.

### 8.4 Returning from Stripe

The web app is static on GitHub Pages, which answers a deep path loaded directly (`/groups/…`) with a 404. Stripe therefore always returns to the root with the real path in `?return=`. `redirect()` in `lib/router.dart` sends a request for `/` with a local `return` (starting with `/`, not `//`, as for `from`) to that path. This is reusable for any external return.

### 8.5 Web billing UI

Shown only where `access.purchaseUi` is true, which in Phase 1 means the web.

**Group → Plan**: `GroupPlanRoute` at `groups/:groupId/plan`, admins only, linked from Manage.

1. **Status.** The plan name (the highest-ranked `subscription` source, else Free), then one line per source:
   - "Founder benefit: Community included until {date}"
   - "Funded by {payer} · Community M · renews {date}" (or "ends {date}")
   - for `status: grace`: "Payment issue: {payer} needs to update the payment method"
2. **Seats.** "{seats} of {limit} seats", or "No seat limit". When full: "Invites are paused until the plan changes or members are removed."
3. **Plan picker** (group not funded): S, M and L with a monthly/annual toggle. Recommend the smallest band whose limit covers current seats; above 80, show "Contact us". Prices come from `catalog`, in a currency guessed from the locale (CH → CHF, euro countries → EUR, otherwise USD), with "Final price at checkout". Founders see "30% founder discount applied at checkout". With an active `founder_trial`: "Billing starts on {trial end}".
4. **Subscribe:** invoke `billing-checkout`, then `launchUrl(url, webOnlyWindowName: '_self')`.
5. **Return** (`?checkout=success`): "Activating your plan…", refreshing `billing_state` every 3 seconds until a `subscription` source appears. After 60 seconds: "Payment received. Activation is taking longer than usual; refresh in a minute."
6. **Funded by the current user:** "Manage billing" invokes `billing-portal` with `return_path` set to this page. Funded by someone else: read-only.

**Settings → Billing** (web, shown when the user has ever paid): "Manage billing", which opens the portal. This is how a payer whose group was deleted cancels.

**Analytics:** `track('checkout started', {plan, interval})` before redirecting, and `track('plan activated')` when the return flow sees the subscription.

**Native apps in Phase 1:** no plan page and no prices. Android shows the pro screens of entitled groups, which Google Play allows (no purchase, no steering). iOS shows only the effects of pro features, such as cutoff locks (`access.can`), never their screens (`access.show`).

---

## 9. Phase 1: pro features

### 9.1 Pattern

- **Server:** only features that change behaviour are enforced, with `billing.has_feature(group_id, '<key>')` in the trigger or RPC that implements them. Turning a setting on needs the feature; turning it off never does.
- **Client:** screens and settings render only if `access.show(key)`; effects use `access.can(key)`.
- **Losing a feature:** settings are kept but no longer enforced (the server check is false), and the screens hide. Paying again restores both.

### 9.2 `reply_cutoffs`

An admin sets "changes close N minutes before start" on a schedule. After the deadline, members can't change or delete their replies. Admins can still set yes or no, but nobody can delete a reply, because deleting it would silently fall back to the default.

The deadline is the occurrence's start minus the cutoff. `instance_date` is the occurrence's start, which the app writes, so no recurrence is needed in SQL; it is a wall-clock time labelled UTC, read in `schedules.time_zone` (1.4, 1). As built: `supabase/migrations/20261025140200_reply_cutoffs.sql`.

```sql
-- <ts>_reply_cutoffs.sql
alter table public.schedules
  add column cutoff_minutes_before int check (cutoff_minutes_before between 0 and 10080);

create function billing.tg_schedule_cutoff_gate()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if new.cutoff_minutes_before is not null
     and (tg_op = 'INSERT' or new.cutoff_minutes_before is distinct from old.cutoff_minutes_before)
     and not billing.has_feature(new.group_id, 'reply_cutoffs') then
    raise exception using errcode = 'P0001', message = 'feature_locked';
  end if;
  return new;
end $$;

create trigger schedules_cutoff_gate before insert or update of cutoff_minutes_before on public.schedules
  for each row execute function billing.tg_schedule_cutoff_gate();

create function billing.tg_reply_cutoff()
returns trigger language plpgsql security definer set search_path = '' as $$
declare
  r        public.replies;
  v_group  uuid;
  v_cutoff int;
begin
  if tg_op = 'DELETE' then r := old; else r := new; end if;
  select s.group_id, s.cutoff_minutes_before into v_group, v_cutoff
    from public.schedules s where s.id = r.schedule_id;

  if auth.uid() is null                                           -- service role, SQL
     or v_cutoff is null
     or now() < r.instance_date - make_interval(mins => v_cutoff)
     or not billing.has_feature(v_group, 'reply_cutoffs')
     or (tg_op <> 'DELETE' and public.is_member_of_group(v_group, '{admin}'::public.group_roles[])) then
    return r;
  end if;
  raise exception using errcode = 'P0001', message = 'reply_locked';
end $$;

create trigger replies_cutoff before insert or update or delete on public.replies
  for each row execute function billing.tg_reply_cutoff();
```

The app upserts replies, which fires the insert trigger first and then the update trigger on conflict. Both apply the same check.

**Late changes** are computed in the app, not stored. A reply, or the default rule it falls back to, is *late* when its `updated_at` is at or after the deadline and before the start. This needs `updatedAt` on `Reply` and `DefaultRule`.

**Accepted limit (v1):** default rules are not locked, because which occurrences a rule covers is only known in Dart. Editing a default after the deadline shows up as a late change; deleting it after the deadline changes the meal silently. If cooks report this, lock defaults per member in the app when they are edited inside a deadline window.

**Client:**
- Schedule editor (`access.show`): "Changes close" with 1, 2, 4 and 24 hours before start, plus custom.
- Reply controls on every platform: after the deadline, "Changes closed at {time}". Members see the controls disabled; admins can still answer, and see a "late change" badge.
- `ReplyLockedException`: "Changes for this meal closed at {time}. Ask an admin."

### 9.3 `kitchen_view`

A day view of a group's events. For each event it shows the yes count (account members and managed members separately), the no and no-answer counts, the names of those coming, and late changes. It is computed in the app with `rsvp.dart` from the data the group screens already load. There is no RPC, because members can already read all of this (design rule 4).

- Route: `GroupKitchenRoute` at `groups/:groupId/kitchen?date=YYYY-MM-DD`, any member, behind `access.show('kitchen_view')`.
- "Print" builds a PDF with `pdf` and `printing`, which work on web and Android. It can follow in a later release if the launch is tight.

### 9.4 `export_csv`

Admins pick a date range of at most one year. The app loads replies for the range (`RepliesService.getRepliesForDateRange`), resolves them with `rsvp.dart`, and builds a CSV with the columns date, time, event, name, managed, answer, source (reply/default/none) and late. It is delivered through `share_plus`, already a dependency: the share sheet on Android, a download on the web (verify this fallback). Admin only, behind `access.show('export_csv')`.

### 9.5 Checklist: a new pro feature

1. Pick a key. Add it to `FeatureKey` and to the pgTAP key list.
2. If it changes behaviour, enforce it on the server with `billing.has_feature`, and add pgTAP tests.
3. Gate its screens with `access.show` and its effects with `access.can`. Add widget tests.
4. Confirm it did not exist for free on A (G1).
5. In a migration, append the key to the current Community plans (4.4).
6. At release, run the early-access grant (15.6).

---

## 10. Phase 1 deliverable: account deletion

Before `delete_user_account` deletes the auth user, it sets `cancel_at_period_end: true` on each of the user's entitled Stripe subscriptions. The customer row stays, with `user_id` set to null, for accounting; the group stays funded until the period ends.

---

## 11. Launch runbook

| When | Step |
|---|---|
| Before A | Phases 0 and 1 deployed. Production in `prelaunch`. App builds with pro screens released, screens hidden. Stripe live configuration complete. B3 texts published. The 16.3 matrix green in test mode. |
| A | Announce: email to all users, web banner, pricing and FAQ page stating G1–G6, A and D. Record A to the second. |
| D | `select billing.launch('<A>');` in production. Irreversible: a second person confirms first. |
| D | Check that `legacy` grants equal the groups created before A, that `billing_state()` returns `live`, and that a legacy group shows Community features. |
| D + 1h | A team member buys Community S for a real non-legacy group with a real card. Check the group's entitlements, then refund and cancel in Stripe and check that the group falls back to Free. |
| D + 1d | `select * from billing.attention;` is empty, and the Stripe webhook shows no failures. |

---

## 12. Phase 2: in-app purchases with RevenueCat

Scope: an in-app purchase buys one band for one group. A store account holds at most one Community subscription at a time: one App Store subscription group, and the same rule enforced by the app on Google Play. Everything else stays on the web.

### 12.1 Spike (1–2 days, first)

Make sandbox purchases on both stores and record in this document:

1. The Play product identifier format (subscription id plus base plan), as it appears in the webhook `product_id`, in the SDK's `StoreProduct.identifier` and in the keys of `GET /v1/subscribers` → `subscriptions`.
2. The `GET /v1/subscribers` fields (`expires_date`, `billing_issues_detected_at`, `grace_period_expires_date`, `unsubscribe_detected_at`, `refunded_at`, `period_type`, `store`, `is_sandbox`) during renewal, Apple grace period, billing retry, Play account hold, cancellation, refund, upgrade and downgrade.
3. Whether a subscriber attribute set right before a purchase (`Purchases.setAttributes({'group_id': …})`) is present in `GET /v1/subscribers` by the time the purchase's webhook arrives. If it isn't reliably there, use a server-side intent row written by an RPC before the purchase instead; the rest is unchanged.
4. The `purchases_flutter` version to pin, and its API for purchasing, product change on Google, restore and `managementURL`.

### 12.2 Store and RevenueCat configuration

**App Store Connect:** Paid Applications agreement, tax and banking; Small Business Program. Subscription group "Grup Community" with `community_{s,m,l}_{month,year}`, levels L = 1, M = 2, S = 3 (monthly and annual share a level). The price point closest to the nominal amount in each storefront, with CHF and EUR set explicitly. **Family Sharing off** (irreversible). Localised names in every language the app ships (EN, IT, DE, FR, ES). API and In-App Purchase keys for RevenueCat; Server Notifications V2 to RevenueCat. Product ids are permanent.

**Google Play Console:** subscriptions `community_{s,m,l}`, each with base plans `month` (P1M) and `year` (P1Y); default grace period and account hold; Real-time developer notifications to RevenueCat; license testers.

**RevenueCat:** project "Grup" with both apps; products imported; entitlement `community` (client convenience only); offering `default`. App User ID = Supabase user id. Transfer behaviour **Keep with original App User ID**: a store subscription stays with the Grup account that bought it, so there are no transfers to handle. Webhook to `…/functions/v1/revenuecat-webhook` with `Authorization: Bearer <RC_WEBHOOK_AUTH>`, production and sandbox. The v1 secret key as `RC_SECRET_API_KEY`; the public SDK keys as dart-defines.

### 12.3 Migration `<ts>_billing_iap.sql`

```sql
alter table billing.config add column iap_enabled boolean not null default false;
-- and add 'iap_enabled' to public.billing_state()

insert into billing.prices (plan_id, provider, provider_price_id, interval)
select p.id, x.provider, x.product_id, x.interval
from (values
  ('community_s', 'app_store',  'community_s_month', 'month'),
  ('community_s', 'app_store',  'community_s_year',  'year'),
  ('community_m', 'app_store',  'community_m_month', 'month'),
  ('community_m', 'app_store',  'community_m_year',  'year'),
  ('community_l', 'app_store',  'community_l_month', 'month'),
  ('community_l', 'app_store',  'community_l_year',  'year'),
  -- Play identifiers exactly as recorded in the spike
  ('community_s', 'play_store', 'community_s:month', 'month'),
  ('community_s', 'play_store', 'community_s:year',  'year'),
  ('community_m', 'play_store', 'community_m:month', 'month'),
  ('community_m', 'play_store', 'community_m:year',  'year'),
  ('community_l', 'play_store', 'community_l:month', 'month'),
  ('community_l', 'play_store', 'community_l:year',  'year')
) as x(code, provider, product_id, interval)
join billing.plans p on p.code = x.code and p.current;
```

**Store subscriptions are one row per payer and store**, `provider_ref = '<store>:<user id>'`. Renewals, band changes and resubscribing all update that row. The group comes from the `group_id` attribute and is applied by `upsert_subscription` only when the row starts or comes back from expiry, and only for an admin of that group. A paywall the user dismisses can't move an active subscription.

### 12.4 `revenuecat-webhook`

```ts
// supabase/functions/revenuecat-webhook/index.ts
import { sql } from "../_shared/billing.ts";

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const STORES = { APP_STORE: "app_store", PLAY_STORE: "play_store" } as const;
const ms = (d: string | null) => (d ? Date.parse(d) : 0);

// Adjust to the spike's fixtures.
export function mapRevenueCatStatus(s: any, now = Date.now()): string {
  if (s.refunded_at) return "expired";
  if (s.billing_issues_detected_at) {
    return ms(s.grace_period_expires_date) > now || ms(s.expires_date) > now ? "grace" : "billing_retry";
  }
  if (ms(s.expires_date) <= now) return "expired";
  if (s.period_type === "trial") return "trialing";
  if (s.unsubscribe_detected_at) return "canceled_pending";
  return "active";
}

async function syncUser(userId: string) {
  const res = await fetch(`https://api.revenuecat.com/v1/subscribers/${userId}`, {
    headers: { Authorization: `Bearer ${Deno.env.get("RC_SECRET_API_KEY")}` },
  });
  if (!res.ok) throw new Error(`RevenueCat ${res.status}`);
  const { subscriber } = await res.json();
  const groupId = subscriber.subscriber_attributes?.group_id?.value ?? null;
  const [customer] = await sql`
    insert into billing.customers (user_id) values (${userId})
    on conflict (user_id) do update set user_id = excluded.user_id returning id`;

  for (const store of Object.values(STORES)) {
    // The latest-expiring subscription on this store; unknown products are ignored by the upsert.
    const [productId, s] = Object.entries<any>(subscriber.subscriptions ?? {})
      .filter(([, s]) => s.store === store)
      .sort(([, a], [, b]) => ms(b.expires_date) - ms(a.expires_date))[0] ?? [];
    if (!s) continue;
    const status = mapRevenueCatStatus(s);
    const periodEnd = status === "grace" ? (s.grace_period_expires_date ?? s.expires_date) : s.expires_date;
    await sql`select billing.upsert_subscription(
      ${customer.id}, ${store}, ${`${store}:${userId}`}, ${productId}, ${UUID.test(groupId ?? "") ? groupId : null}::uuid,
      ${status}::billing.status, ${periodEnd}::timestamptz, ${status === "canceled_pending"}, ${s.is_sandbox})`;
  }
}

Deno.serve(async (req) => {
  if (req.headers.get("authorization") !== `Bearer ${Deno.env.get("RC_WEBHOOK_AUTH")}`) {
    return new Response("unauthorized", { status: 401 });
  }
  const { event } = await req.json();
  if (!(event.store in STORES) || !UUID.test(event.app_user_id)) return new Response("ignored");
  try {
    await syncUser(event.app_user_id);
    return new Response("ok");
  } catch (e) {
    console.error(event.id, e);
    return new Response("retry", { status: 500 }); // RevenueCat retries
  }
});
```

### 12.5 App

Set `kIapSupported = true` in this release, and extend `GroupAccess.purchaseUi` to `mode == live && (web || (kIapSupported && iapEnabled))`. Add `purchases_flutter` at the pinned version, guarded to iOS and Android.

- **Identity:** configure Purchases with `appUserID` = the Supabase user id after sign-in, and `logIn`/`logOut` on user changes, in the composition root next to the other per-user switches.
- **Paywall** (Plan page, admins of unfunded groups, `access.purchaseUi`):
  - load `getOfferings().current` and map packages to bands through `catalog` by product id, recommending a band as on the web;
  - show for each band: plan name, seat limit, features, `storeProduct.priceString` per period, "Renews automatically until cancelled" with how to cancel, and links to the Terms (EULA) and Privacy Policy;
  - on iOS, also show **Restore Purchases** (Guideline 3.1.2 and Google Play's requirements).
- **Buying:** `setAttributes({'group_id': groupId})`, then purchase the package, then poll `billing_state` as on the web.
- **Already subscribed on this store** (`community` entitlement active): no purchase. Show "Your subscription funds {group}" and **Manage subscription** (`managementURL`).
- **Changing band** (the payer): on iOS, buy the other package (StoreKit handles it within the group); on Android, use product change with `WITH_TIME_PRORATION` for upgrades and `DEFERRED` for downgrades. The row and its group stay.
- **Web-funded group on mobile:** "Funded by {payer} · Community M", with no price, link or mention of the web.
- **Account deletion:** with an active store subscription, warn "Deleting your account doesn't cancel your App Store / Google Play subscription" and offer `managementURL`.

### 12.6 Enabling

1. TestFlight and internal testing; the 16.4 matrix.
2. `update billing.config set iap_enabled = true;` before submitting the iOS build with its products, so App Review sees the paywall. Phase 2 Android builds already released start showing the paywall too: accept that, or release Android after iOS approval.
3. Review notes: a demo account that is admin of a demo group; one subscription unlocks features for one group.
4. Rollback: `iap_enabled = false` hides the paywall. Existing store subscriptions keep being honoured.

---

## 13. Subscription lifecycle

| Event | Status | Group |
|---|---|---|
| Checkout or in-app purchase completes | `active` / `trialing` | Funded (Stripe metadata or store attribute) |
| Renewal | `active` | Unchanged |
| Payment failing, retries running (Stripe `past_due`, store grace) | `grace` | Still funded; admins see a payment-issue line |
| Stripe gives up (cancels) | `expired` | Free plus grants |
| Store billing retry after grace | `billing_retry` | Free plus grants until recovered; expires when the store gives up |
| Cancel at period end | `canceled_pending` | Funded until the period ends, then `expired` |
| Upgrade | `active`, new plan | Higher band immediately |
| Downgrade | `active`, plan changes at renewal | Lower band at renewal; invites pause if over the new limit |
| Refund (web: ops refunds and cancels; store: reported) | `expired` | Free plus grants immediately |
| Missed webhooks | Stripe/RevenueCat retries; ops resend | Honoured at most 7 days past period end |
| Payer deletes account | Stripe: cancels at period end (10). Store: user cancels in the store. | Funded until expiry |
| Group deleted | Unchanged | `group_id` null; shows in `billing.attention` |

---

## 14. Self-hosting

Migrations leave `mode = 'unlocked'`: every feature on, no seat limit, `billing-checkout` answers `404 billing_disabled`, and the app shows no billing UI. The billing Edge Functions need Stripe/RevenueCat secrets but are never called. Document in the self-hosting guide that nothing needs configuring and that `billing.launch()` refuses to run outside `prelaunch`.

---

## 15. Operations

Run as `postgres` in the SQL editor. Entitlements are computed on read, so every change below applies immediately.

### 15.1 Comp a group

```sql
insert into billing.grants (group_id, source, features, limits, ends_at, note)
select '<group-id>', 'manual', p.features, p.limits, now() + interval '3 months', 'Support: <ticket>'
from billing.plans p where p.code = 'community_m' and p.current;
```

### 15.2 Refunds

- **Web:** refund in the Stripe dashboard **and** cancel the subscription immediately; the webhook expires it.
- **Stores:** Apple and Google decide; RevenueCat reports the refund and the row expires.

### 15.3 Invoiced customers and groups above 80 seats

Issue a Swiss QR-bill outside the system, then:

```sql
with c as (
  insert into billing.customers (user_id) values ('<payer-user-id>')
  on conflict (user_id) do update set user_id = excluded.user_id returning id)
insert into billing.subscriptions (customer_id, provider, provider_ref, plan_id, group_id, status, current_period_end)
select c.id, 'manual', '<invoice-ref>', p.id, '<group-id>', 'active', '<paid-until>'
from c, billing.plans p where p.code = 'community_l' and p.current;
```

Extend after payment with `update billing.subscriptions set current_period_end = '<date>' where provider = 'manual' and provider_ref = '<invoice-ref>';`. Above 80 seats, also add a `manual` grant with `{"max_seats": null}`.

### 15.4 Weekly check

`select * from billing.attention;`, plus the Stripe webhook dashboard.

- `funds_no_group`: the group was deleted, or the payer stopped being an admin before the first webhook. Ask the payer: move the subscription (`update billing.subscriptions set group_id = …`) or cancel and refund.
- `group_funded_twice`: two admins paid at once. Refund and cancel the newer one.
- Failed webhook deliveries: fix the cause, then resend them from Stripe or RevenueCat.

### 15.5 Kill switch

`select billing.set_mode('unlocked');` turns every feature on and lifts every limit; paying users lose nothing, and checkout stops. Revert with `select billing.set_mode('live');`. Never use `prelaunch` as a kill switch: it takes features away from paying groups.

### 15.6 Early access for a new feature (G5)

```sql
insert into billing.grants (group_id, source, features, ends_at, note)
select g.group_id, 'early_access', array['<key>'], now() + interval '60 days', 'Early access: <key>'
from billing.grants g where g.source = 'legacy';
```

---

## 16. Testing

### 16.1 pgTAP (`supabase/tests/billing_test.sql`)

Each test sets the mode it needs inside its transaction.

- **Privileges:** `anon`, `authenticated` and `service_role` have no usage on schema `billing` and no privilege on its tables. `authenticated` can execute `public.billing_state()` and `anon` can't. (The existing tests already cover search paths and `public` tables.)
- **Keys:** every feature and limit key in `billing.plans` and `billing.grants` is in the pinned list (4.2).
- **Modes:** `unlocked` gives every feature and `{}` limits; `prelaunch` gives none and `{}`; `live` follows the sources; `live` without a cutoff violates the constraint.
- **Entitlements:** free only; with a grant; an expired grant is ignored; an entitled subscription; a non-entitled one; one more than 7 days past its period; features are unioned; for limits, `null` beats numbers and otherwise the maximum wins.
- **Seats:** at the limit, a new invite raises `group_full`; a second invite for an invited member passes; redeeming an invite in a full group passes (both `consume_invite_code` and signup); an admin writing `profile_id` on an uninvited managed member of a full group raises; managed members never count; no cap outside `live` or with a `legacy` grant.
- **Launch:** creates one `legacy` and one `founder_trial` grant per group created before the cutoff; refuses a second run and refuses outside `prelaunch`; a group created after the cutoff is capped at 10.
- **Subscriptions:** `upsert_subscription` keeps `plan_id` on renewal and moves it on a price change; takes the group only on start or reactivation and only for an admin; returns null for an unknown price; `attention` lists both issues.
- **Cutoffs:** turning a cutoff on raises `feature_locked` without the feature, and turning it off is always allowed. After the deadline, a member's insert, update and delete raise `reply_locked`; an admin's insert and update pass and an admin's delete raises. Before the deadline, without the feature, or as service role, everything passes.

### 16.2 Edge Functions (Deno tests)

- `mapStripeStatus` and `mapRevenueCatStatus`, table-driven, with the fixtures recorded in the spike.
- Webhooks: an invalid signature or auth gets 400/401; a sync failure gets 500.

### 16.3 Stripe test mode (staging, with test clocks)

1. A purchase funds the target group, and the plan page shows it within seconds of return.
2. Founder: the coupon applies; a legacy group bills from its trial end (`trialing`, then `active`).
3. Renewal; failed renewal → `grace` → recovery; all retries failing → `expired`.
4. Portal upgrade S → M is immediate; downgrade M → S applies at renewal.
5. Cancel at period end → `canceled_pending` → `expired`.
6. Checkout for a funded group gets 409; two simultaneous checkouts appear in `attention`.
7. Deleting a webhook delivery, then resending it, repairs the state.
8. Tax and currency: a Swiss consumer pays CHF with VAT included; a German consumer EUR with German VAT; an EU business with a VAT id gets reverse charge; a US customer pays USD.

### 16.4 In-app sandbox (iOS StoreKit + sandbox, Android license testers)

Purchase funds the group through the attribute; accelerated renewal; upgrade (immediate) and downgrade (deferred); cancel → `canceled_pending` → `expired`; billing issue → grace → `billing_retry` and Play account hold; refund; a user who holds a subscription is offered "Manage", not "Buy"; resubscribing after expiry funds the group chosen in the new purchase; restore on a second Grup account is refused (Keep with original).

### 16.5 App

- Unit tests for `GroupAccess` across mode × platform (web, Android, iOS) × `kIapSupported`. In particular, iOS in Phase 1 never shows pro screens or prices.
- Widget tests with `FakeBackend` for the plan page, seat-full invite handling, cutoff-locked reply controls, the kitchen view and export.
- `test/app_flow_test.dart`: `/?return=/groups/<id>/plan?checkout=success` lands on the plan page; `?return=//evil` goes home.
- Before each iOS release, check every screen for prices, upgrade prompts and links to the web.

---

## 17. Delivery

Review zones: **Ship** (merge on green), **Guard** (easy to reverse, harmful while wrong), **Decide** (hard to undo; agree on the shape first), **Stop** (both; read every line).

| PR | Zone | Contents | Depends on |
|---|---|---|---|
| 0.1 | Decide | Phase 0 migration (6.1–6.3), pgTAP, app foundation (7) | B1 |
| — | Stop (prod) | `select billing.set_mode('prelaunch');` | 0.1 deployed |
| 1.1 | Stop | Stripe configuration (8.1), Stripe migration (8.2), Edge Functions (8.3), `config.toml`, account deletion (10) | 0.1, B2, B3 |
| 1.2 | Guard | `reply_cutoffs` (9.2) | 0.1 |
| 1.3 | Ship | `kitchen_view`, `export_csv` (9.3, 9.4) | 1.2 (late flags) |
| 1.4 | Guard | Return routing (8.4), plan page and Settings → Billing (8.5) | 1.1 |
| Launch | Stop (prod) | Runbook 11 | all of the above, B4 |
| 2.0 | Ship | Spike results recorded here (12.1) | — |
| 2.1 | Decide | Store and RevenueCat configuration, IAP migration (12.2, 12.3) | 2.0 |
| 2.2 | Stop | `revenuecat-webhook` (12.4) | 2.1 |
| 2.3 | Guard | In-app purchases in the app, `kIapSupported = true` (12.5) | 2.2, B3 |
| — | Guard (prod) | `iap_enabled = true`, App Review (12.6) | 2.3 |

The PRs 0.1 to 1.4 are one stack of branches, `feat/billing-0.1-foundation`, `-1.1-stripe`, `-1.2-cutoffs`, `-1.3-kitchen-export` and `-1.4-plan-page`, each on the one before, so the migrations merge in timestamp order (`db push` refuses an older one). 1.1 can merge before B2 and B3: outside `live`, `billing-checkout` answers `billing_disabled`, the webhook refuses every request without its secret, account deletion finds no subscription to cancel, and the app calls none of them before 1.4.

**One-way doors**, to agree on before the PR that creates them:

- the seat definition (F4) and the bands;
- the grandfathering promises (section 5) and the cutoff A, which can't be withdrawn once announced;
- Stripe prices (`tax_behavior` is immutable) and lookup keys;
- App Store product ids, levels, Family Sharing off;
- RevenueCat App User ID and transfer behaviour;
- feature and limit key names.

### 17.1 Rollback

Supabase migrations are forward-only. Undoing a migration means writing a new one.

| Phase | Rollback |
|---|---|
| 0 | A migration dropping the triggers and the `billing` schema. It holds no customer data yet. |
| 1 | `billing.set_mode('unlocked')` (15.5). Stripe keeps billing: communicate and refund as needed. The cutoff and grants remain. |
| 2 | `iap_enabled = false`. Store subscriptions stay honoured. |

### 17.2 Done when

| Phase | Done when |
|---|---|
| 0 | pgTAP green; production in `prelaunch`; no visible change. |
| 1 | The 16.3 matrix green in test mode; launch executed; first live purchase and refund verified; `attention` empty after a day. |
| 2 | The 16.4 matrix green on both stores; App Review approved; `iap_enabled = true`. |

---

## Appendix A — Configuration

**`billing.config`:** `mode` (default `unlocked`), `cutoff_at` (A, set by `launch()`), and `iap_enabled` from Phase 2. The other durations are written where they are used: the 7-day stale guard (`billing.entitlements`), 6 months of founder trial (`launch()`), 60 days of early access (15.6).

**Edge Function secrets** (`supabase secrets set`):

| Name | Used by |
|---|---|
| `STRIPE_SECRET_KEY` (restricted) | checkout, portal, webhook, account deletion |
| `STRIPE_WEBHOOK_SECRET` | stripe-webhook |
| `STRIPE_API_VERSION` | all Stripe calls; matches the webhook endpoint |
| `WEB_APP_URL` | return URLs |
| `RC_SECRET_API_KEY`, `RC_WEBHOOK_AUTH` | revenuecat-webhook (Phase 2) |
| `SUPABASE_URL`, `SUPABASE_SECRET_KEYS`, `SUPABASE_DB_URL` | provided by Supabase |

**`supabase/config.toml`:**

```toml
[functions.stripe-webhook]
verify_jwt = false

[functions.revenuecat-webhook]
verify_jwt = false
```

**App:** `kIapSupported` in `models/billing.dart`; from Phase 2, `--dart-define=RC_IOS_API_KEY=…` and `RC_ANDROID_API_KEY=…`.

---

## Appendix B — Error codes

Raised as the `message` of SQLSTATE `P0001` by SQL, or as `{ "error": code }` by Edge Functions.

| Code | Raised by | App |
|---|---|---|
| `group_full` | Invite insert, account member insert | "This group has no free seats." Web admins get a link to the plan page; elsewhere "Remove members or pending invites to free a seat." If an invite fails this way, the repository removes the member it just created. |
| `feature_locked` | Turning on a cutoff | Hide the setting; refresh `billing_state` |
| `reply_locked` | Reply trigger | "Changes for this meal closed at {time}. Ask an admin." |
| `not_authenticated` | Edge Functions | Sign in again |
| `not_admin` | Checkout | Refresh the group |
| `already_funded` | Checkout | Refresh; show who funds the group |
| `billing_disabled` | Checkout | Hide billing UI; refresh `billing_state` |
| `invalid_plan` | Checkout | Programming error; report it |
| `no_customer` | Portal | Hide "Manage billing" |
| `price_not_configured` | Checkout | Ops alert: the Stripe catalogue is out of sync |
