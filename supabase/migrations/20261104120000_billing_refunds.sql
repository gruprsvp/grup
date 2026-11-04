-- Refunds that leave a plan running (docs/billing-and-entitlements.md 15.4).
-- A Stripe refund doesn't cancel the subscription, and under Managed Payments
-- Link may refund on its own (up to 60 days after a payment). The terms say a
-- refunded plan ends, so operations cancels it: stripe-webhook records each
-- full refund here and billing.attention lists the subscription.
alter table billing.subscriptions add column refunded_at timestamptz;

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
     and not s.cancel_at_period_end;

-- Design rule 5 (see 20261025140000).
revoke all on all tables in schema billing from public, anon, authenticated, service_role;
