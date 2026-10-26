// The billing functions' pure parts (docs/billing-and-entitlements.md 8.3).
// Nothing here reads the environment or the network, so tests import it as is.

export const UUID =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

const PLANS = new Set(["community_s", "community_m", "community_l"]);
const INTERVALS = new Set(["month", "year"]);

/**
 * SUPABASE_DB_URL as Deno can reach it. shortcut: `supabase start` (unlike
 * `functions serve` and the hosted platform) names the local database host
 * supabase_db_<project>, which Deno's DNS refuses for its underscores; the
 * same container answers to `db`. Drop once the CLI passes a resolvable host.
 */
export function reachableDbUrl(url: string): string {
  const parsed = new URL(url);
  if (!parsed.hostname.startsWith("supabase_db_")) return url;
  parsed.hostname = "db";
  return parsed.toString();
}

/** The fields of a Stripe subscription its status depends on. */
export interface StripeSubscriptionState {
  status: string;
  cancel_at_period_end: boolean;
  cancel_at: number | null;
}

/** billing.status for a Stripe subscription; null to wait for the next event. */
export function mapStripeStatus(sub: StripeSubscriptionState): string | null {
  const ending = sub.cancel_at_period_end || sub.cancel_at != null;
  switch (sub.status) {
    case "trialing":
      return ending ? "canceled_pending" : "trialing";
    case "active":
      return ending ? "canceled_pending" : "active";
    case "past_due":
      return "grace"; // Smart Retries running
    case "unpaid":
      return "billing_retry";
    case "canceled":
    case "incomplete_expired":
    case "paused":
      return "expired";
    default:
      return null; // "incomplete": wait for the next event
  }
}

/** A checkout request ({ group_id, plan, interval }), or null if invalid. */
export function parseCheckout(
  body: unknown,
): { groupId: string; plan: string; interval: string } | null {
  const { group_id, plan, interval } = (body ?? {}) as Record<string, unknown>;
  if (
    typeof group_id !== "string" || !UUID.test(group_id) ||
    typeof plan !== "string" || !PLANS.has(plan) ||
    typeof interval !== "string" || !INTERVALS.has(interval)
  ) {
    return null;
  }
  return { groupId: group_id, plan, interval };
}

/** A path in the app to come back to, or "/" for anything else. */
export function safeReturnPath(path: unknown): string {
  return typeof path === "string" && path.startsWith("/") &&
      !path.startsWith("//")
    ? path
    : "/";
}

type StripeEvent = { id: string; type: string; data: { object: unknown } };

/**
 * The stripe-webhook handler. Events are only triggers: [sync] fetches the
 * subscription's current state, so duplicates and ordering don't matter.
 */
export const stripeWebhook = (
  verify: (body: string, signature: string) => Promise<StripeEvent>,
  sync: (subscriptionId: string) => Promise<void>,
) =>
async (req: Request): Promise<Response> => {
  let event: StripeEvent;
  try {
    event = await verify(
      await req.text(),
      req.headers.get("stripe-signature") ?? "",
    );
  } catch {
    return new Response("invalid signature", { status: 400 });
  }
  const subscriptionId = subscriptionOf(event);
  try {
    if (subscriptionId) await sync(subscriptionId);
    return new Response("ok");
  } catch (e) {
    console.error(event.id, e);
    return new Response("retry", { status: 500 }); // Stripe retries for 3 days
  }
};

/** The subscription a Stripe event is about, if it is one to sync. */
export function subscriptionOf(event: StripeEvent): string | null {
  const o = event.data.object as Record<string, unknown>;
  if (event.type === "checkout.session.completed") {
    return o.mode === "subscription" && typeof o.subscription === "string"
      ? o.subscription
      : null;
  }
  return event.type.startsWith("customer.subscription.") &&
      typeof o.id === "string"
    ? o.id
    : null;
}
