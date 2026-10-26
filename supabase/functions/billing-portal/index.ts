// A Stripe Customer Portal session for the signed-in payer
// (docs/billing-and-entitlements.md 8.3). Request { return_path }; response { url }.
import {
  appUrl,
  handle,
  HttpError,
  json,
  requireUser,
  sql,
  stripe,
} from "../_shared/billing.ts";
import { safeReturnPath } from "../_shared/billing_logic.ts";

Deno.serve(handle(async (req) => {
  const user = await requireUser(req);
  const [c] = await sql()`
    select stripe_customer_id from billing.customers where user_id = ${user.id}`;
  if (!c?.stripe_customer_id) throw new HttpError(404, "no_customer");
  const { return_path } = await req.json().catch(() => ({}));
  const session = await stripe().billingPortal.sessions.create({
    customer: c.stripe_customer_id,
    return_url: appUrl(safeReturnPath(return_path)),
  });
  return json({ url: session.url });
}));
