// The public cancellation page's function (docs/billing-and-entitlements.md
// 8.5): cancel a payer's plans, or record a withdrawal, from an email address,
// with or without signing in. Runs without a Supabase JWT (verify_jwt = false
// in config.toml).
import { handle, sql, stripe } from "../_shared/billing.ts";
import {
  billingCancel,
  cancelEmail,
  type CancelRequest,
  matchSubscriptions,
  type PayerSubscription,
  RATE_LIMIT,
} from "../_shared/cancel_logic.ts";
import { sendEmail } from "../_shared/email.ts";

// Supabase's runtime: keeps the function alive until background work ends.
declare const EdgeRuntime: { waitUntil(work: Promise<unknown>): void };

/** Records the request; false once the address made too many this hour. */
async function allow(emailHash: string, action: string) {
  const [{ recent }] = await sql()`
    with _ as (delete from billing.cancel_requests where requested_at < now() - interval '1 day'),
         inserted as (insert into billing.cancel_requests (email_hash, action)
                      values (${emailHash}, ${action}) returning 1)
    select count(*)::int as recent from billing.cancel_requests
     where email_hash = ${emailHash} and requested_at > now() - interval '1 hour'`;
  // The count doesn't see this request's own row (same statement).
  return recent < RATE_LIMIT;
}

async function process(request: CancelRequest) {
  const at = new Date();
  const [user] = await sql()`
    select id, email from auth.users where lower(email) = ${request.email}`;
  if (!user) return; // no account: nothing to do, nobody to email

  const rows = await sql()`
    select s.id, s.provider_ref, s.provider, s.status, s.cancel_at_period_end,
           s.current_period_end, p.code as plan, s.group_id, g.display_name as group_name
      from billing.subscriptions s
      join billing.customers c on c.id = s.customer_id
      join billing.plans p on p.id = s.plan_id
      left join public.groups g on g.id = s.group_id
     where c.user_id = ${user.id}`;
  const plans = matchSubscriptions(
    rows.map((r): PayerSubscription => ({
      id: r.id,
      providerRef: r.provider_ref,
      provider: r.provider,
      status: r.status,
      ending: r.cancel_at_period_end,
      currentPeriodEnd: r.current_period_end,
      plan: r.plan,
      groupId: r.group_id,
      groupName: r.group_name,
    })),
    request.groupId,
  );

  if (request.action === "cancel") {
    for (const plan of plans.filter((p) => !p.ending)) {
      // The webhook then syncs the row; the payer can undo it in the portal.
      const sub = await stripe().subscriptions.update(plan.providerRef, {
        cancel_at_period_end: true,
      });
      // deno-lint-ignore no-explicit-any
      const end = (sub.items.data[0] as any)?.current_period_end;
      if (end) plan.currentPeriodEnd = new Date(end * 1000);
    }
  } else {
    for (const plan of plans) {
      await sql()`
        insert into billing.withdrawals (subscription_id, user_id, name, requested_at)
        values (${plan.id}, ${user.id}, ${request.name}, ${at})`;
    }
  }

  await sendEmail(user.email, cancelEmail(request, at, plans));
}

Deno.serve(handle(billingCancel({
  allow,
  process,
  background: (work) => EdgeRuntime.waitUntil(work),
})));
