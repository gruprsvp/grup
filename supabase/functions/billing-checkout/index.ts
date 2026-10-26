// A Stripe Checkout session for an admin to buy a plan for their group
// (docs/billing-and-entitlements.md 8.3). Request { group_id, plan, interval };
// response { url }.
import {
  appUrl,
  handle,
  HttpError,
  json,
  requireUser,
  sql,
  stripe,
} from "../_shared/billing.ts";
import { parseCheckout } from "../_shared/billing_logic.ts";

Deno.serve(handle(async (req) => {
  const user = await requireUser(req);
  const checkout = parseCheckout(await req.json().catch(() => null));
  if (!checkout) throw new HttpError(400, "invalid_plan");
  const { groupId, plan, interval } = checkout;

  const [ctx] = await sql()`
    select c.mode,
           exists (select 1 from public.members m where m.group_id = ${groupId}
                     and m.profile_id = ${user.id} and m.role = 'admin') as is_admin,
           exists (select 1 from billing.subscriptions s
                    where s.group_id = ${groupId} and billing.entitled(s.status)) as funded,
           exists (select 1 from auth.users u
                    where u.id = ${user.id} and u.created_at < c.cutoff_at) as founder,
           (select max(g.ends_at) from billing.grants g
             where g.group_id = ${groupId} and g.source = 'founder_trial'
               and g.ends_at > now() + interval '48 hours') as trial_end
      from billing.config c`;
  if (ctx.mode !== "live") throw new HttpError(404, "billing_disabled");
  if (!ctx.is_admin) throw new HttpError(403, "not_admin");
  if (ctx.funded) throw new HttpError(409, "already_funded"); // band changes go through the portal

  const lookupKey = `${plan}_${interval}`;
  const { data: [price] } = await stripe().prices.list({
    lookup_keys: [lookupKey],
    active: true,
    limit: 1,
  });
  if (!price) throw new HttpError(500, "price_not_configured");

  let [customer] = await sql()`
    select id, stripe_customer_id from billing.customers where user_id = ${user.id}`;
  if (!customer?.stripe_customer_id) {
    const created = await stripe().customers.create(
      { email: user.email, metadata: { supabase_user_id: user.id } },
      { idempotencyKey: `customer-${user.id}` },
    );
    [customer] = await sql()`
      insert into billing.customers (user_id, stripe_customer_id) values (${user.id}, ${created.id})
      on conflict (user_id) do update
        set stripe_customer_id = coalesce(billing.customers.stripe_customer_id, excluded.stripe_customer_id)
      returning id, stripe_customer_id`;
  }

  const planPath = `/groups/${groupId}/plan`;
  const session = await stripe().checkout.sessions.create({
    mode: "subscription",
    customer: customer.stripe_customer_id,
    line_items: [{ price: price.id, quantity: 1 }],
    automatic_tax: { enabled: true }, // Stripe Tax path (B2)
    billing_address_collection: "required",
    tax_id_collection: { enabled: true },
    customer_update: { address: "auto", name: "auto" },
    consent_collection: { terms_of_service: "required" }, // wording per B3
    discounts: ctx.founder ? [{ coupon: "founder-30" }] : undefined,
    subscription_data: {
      metadata: { group_id: groupId },
      // Founder groups have Community until the trial ends: bill from then.
      ...(ctx.trial_end
        ? { trial_end: Math.floor(new Date(ctx.trial_end).getTime() / 1000) }
        : {}),
    },
    success_url: appUrl(`${planPath}?checkout=success`),
    cancel_url: appUrl(planPath),
    locale: "auto",
  }, {
    idempotencyKey: `checkout-${user.id}-${groupId}-${lookupKey}-${
      Math.floor(Date.now() / 60_000)
    }`,
  });

  return json({ url: session.url });
}));
