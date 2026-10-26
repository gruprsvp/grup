// Shared by the billing functions (docs/billing-and-entitlements.md 8.3).
//
// Clients are created on first use: a self-hosted install has no Stripe key
// (the SDK refuses to start without one), yet billing-checkout must still
// answer billing_disabled.
import { createClient, type SupabaseClient } from "jsr:@supabase/supabase-js@2";
import postgres from "npm:postgres@3.4.9";
import Stripe from "npm:stripe@22.6.2";
import { corsHeaders } from "./cors.ts";
import { mapStripeStatus, reachableDbUrl, UUID } from "./billing_logic.ts";

let _sql: postgres.Sql | undefined;
/** The database, as postgres: the billing schema isn't in the Data API. */
export const sql = () =>
  _sql ??= postgres(reachableDbUrl(Deno.env.get("SUPABASE_DB_URL")!), {
    prepare: false,
    max: 1,
  });

let _stripe: Stripe | undefined;
export const stripe = () =>
  _stripe ??= new Stripe(Deno.env.get("STRIPE_SECRET_KEY") ?? "", {
    // Unset: the SDK's own version. Set it to the webhook endpoint's.
    apiVersion: Deno.env.get("STRIPE_API_VERSION") as
      | Stripe.LatestApiVersion
      | undefined,
    httpClient: Stripe.createFetchHttpClient(),
  });

let _admin: SupabaseClient | undefined;
const admin = () =>
  _admin ??= createClient(
    Deno.env.get("SUPABASE_URL")!,
    JSON.parse(Deno.env.get("SUPABASE_SECRET_KEYS") || "{}").default ??
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"),
  );

export class HttpError extends Error {
  constructor(public status: number, public code: string) {
    super(code);
  }
}

export const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

/** CORS preflight, then errors as { error: code }. */
export const handle =
  (fn: (req: Request) => Promise<Response>) => async (req: Request) => {
    if (req.method === "OPTIONS") {
      return new Response("ok", { headers: corsHeaders });
    }
    try {
      return await fn(req);
    } catch (e) {
      if (e instanceof HttpError) return json({ error: e.code }, e.status);
      console.error(e);
      return json({ error: "internal" }, 500);
    }
  };

export async function requireUser(req: Request) {
  const token = req.headers.get("Authorization")?.split("Bearer ")[1];
  const { data, error } = token
    ? await admin().auth.getUser(token)
    : { data: { user: null }, error: null };
  if (error || !data.user) throw new HttpError(401, "not_authenticated");
  return data.user;
}

/** A web app address that returns to `path` after the app loads (8.4). */
export function appUrl(path: string) {
  const web = Deno.env.get("WEB_APP_URL"); // e.g. https://grup.rsvp
  if (!web) throw new Error("WEB_APP_URL is not set");
  return `${web}/?return=${encodeURIComponent(path)}`;
}

/** Fetch the subscription's current state and upsert it. Safe to repeat, in any order. */
export async function syncStripeSubscription(id: string) {
  const sub = await stripe().subscriptions.retrieve(id);
  const status = mapStripeStatus(sub);
  if (status === null) return;
  const item = sub.items.data[0];
  // Since API 2025-03-31.basil the period lives on the item.
  // deno-lint-ignore no-explicit-any
  const periodEnd = (item as any).current_period_end ??
    // deno-lint-ignore no-explicit-any
    (sub as any).current_period_end;
  // Set by billing-checkout; editable in the dashboard, so checked.
  const groupId = UUID.test(sub.metadata?.group_id ?? "")
    ? sub.metadata.group_id
    : null;
  const ending = sub.cancel_at_period_end || sub.cancel_at != null;
  const sandbox = !sub.livemode;
  const customer = sub.customer as string;
  const [row] = await sql()`
    select billing.upsert_subscription(
      c.id, 'stripe', ${sub.id}, ${item.price.lookup_key}, ${groupId}::uuid,
      ${status}::billing.status, to_timestamp(${periodEnd}), ${ending}, ${sandbox}) as id
    from billing.customers c where c.stripe_customer_id = ${customer}`;
  if (!row?.id) throw new Error(`unknown customer or price for ${sub.id}`);
}

/**
 * Sets the user's entitled Stripe subscriptions to cancel at the end of their
 * period (10): once the account is gone they can't do it themselves. Their
 * groups stay funded until then.
 */
export async function cancelStripeSubscriptions(userId: string) {
  const rows = await sql()`
    select s.provider_ref from billing.subscriptions s
      join billing.customers c on c.id = s.customer_id
     where c.user_id = ${userId} and s.provider = 'stripe'
       and billing.entitled(s.status) and not s.cancel_at_period_end`;
  for (const { provider_ref } of rows) {
    await stripe().subscriptions.update(provider_ref, {
      cancel_at_period_end: true,
    });
  }
}
