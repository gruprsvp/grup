-- The public cancellation page (billing-cancel, docs/billing-and-entitlements.md
-- 8.5): cancelling and withdrawing without signing in (§ 312k and § 356a BGB,
-- EU CRD Art. 11a).

-- Every request, for the rate limit only: a hash of the email typed, not the
-- email, since most may not belong to anyone. Kept a day.
create table billing.cancel_requests (
  id           uuid primary key default gen_random_uuid(),
  email_hash   text not null,
  action       text not null check (action in ('cancel', 'withdraw')),
  requested_at timestamptz not null default now()
);
create index on billing.cancel_requests (email_hash, requested_at);

-- Withdrawals to process (15.2). Never refunded automatically: anyone can type
-- an email. Recorded outside the 14 days too; operations decides.
create table billing.withdrawals (
  id              uuid primary key default gen_random_uuid(),
  subscription_id uuid not null references billing.subscriptions,
  user_id         uuid references auth.users on delete set null,  -- kept: a legal record
  name            text not null,   -- as the person typed it
  requested_at    timestamptz not null default now(),
  handled_at      timestamptz,     -- refunded and ended, or answered, by operations
  note            text
);
create index on billing.withdrawals (subscription_id);
create index on billing.withdrawals (user_id);

create or replace view billing.attention as
  select 'funds_no_group' as issue, s.id as subscription_id, null::uuid as group_id
    from billing.subscriptions s
   where billing.entitled(s.status) and s.group_id is null
  union all
  select 'group_funded_twice', null, s.group_id
    from billing.subscriptions s
   where billing.entitled(s.status) and s.group_id is not null
   group by s.group_id having count(*) > 1
  union all
  -- Ended or set to end: handled. Operations clears a refund it keeps the
  -- plan for with `update billing.subscriptions set refunded_at = null`.
  select 'refunded_still_active', s.id, s.group_id
    from billing.subscriptions s
   where s.refunded_at is not null and billing.entitled(s.status)
     and not s.cancel_at_period_end
  union all
  select distinct 'withdrawal_pending', s.id, s.group_id
    from billing.withdrawals w join billing.subscriptions s on s.id = w.subscription_id
   where w.handled_at is null;

-- Design rule 5 (see 20261025140000).
revoke all on all tables in schema billing from public, anon, authenticated, service_role;
