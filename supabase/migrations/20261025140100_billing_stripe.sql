-- Web billing with Stripe (docs/billing-and-entitlements.md 8.2).

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

-- Design rule 5 (see 20261025140000).
revoke all on all tables in schema billing from public, anon, authenticated, service_role;
revoke all on all functions in schema billing from public, anon, authenticated, service_role;
