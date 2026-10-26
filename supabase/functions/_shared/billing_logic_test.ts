import { assertEquals } from "jsr:@std/assert@1.0.19";
import {
  mapStripeStatus,
  parseCheckout,
  reachableDbUrl,
  safeReturnPath,
  stripeWebhook,
} from "./billing_logic.ts";

Deno.test("mapStripeStatus", () => {
  const cases: [string, boolean, number | null, string | null][] = [
    ["trialing", false, null, "trialing"],
    ["trialing", true, null, "canceled_pending"],
    ["active", false, null, "active"],
    ["active", true, null, "canceled_pending"],
    ["active", false, 1_900_000_000, "canceled_pending"], // cancel_at set
    ["past_due", false, null, "grace"],
    ["past_due", true, null, "grace"],
    ["unpaid", false, null, "billing_retry"],
    ["canceled", false, null, "expired"],
    ["incomplete_expired", false, null, "expired"],
    ["paused", false, null, "expired"],
    ["incomplete", false, null, null],
    ["something_new", false, null, null],
  ];
  for (const [status, cancel_at_period_end, cancel_at, expected] of cases) {
    assertEquals(
      mapStripeStatus({ status, cancel_at_period_end, cancel_at }),
      expected,
      `${status}, cancel_at_period_end ${cancel_at_period_end}, cancel_at ${cancel_at}`,
    );
  }
});

Deno.test("reachableDbUrl swaps only the local CLI's database host", () => {
  assertEquals(
    reachableDbUrl(
      "postgresql://postgres:postgres@supabase_db_supabase_test:5432/postgres",
    ),
    "postgresql://postgres:postgres@db:5432/postgres",
  );
  const hosted =
    "postgresql://postgres.abc:secret@aws-0-eu-central-1.pooler.supabase.com:6543/postgres";
  assertEquals(reachableDbUrl(hosted), hosted);
  const served = "postgresql://postgres:postgres@db:5432/postgres";
  assertEquals(reachableDbUrl(served), served);
});

Deno.test("parseCheckout accepts a known plan and interval for a group", () => {
  const groupId = "0190a0e4-7c7b-7d3c-9f43-1a2b3c4d5e6f";
  assertEquals(
    parseCheckout({ group_id: groupId, plan: "community_m", interval: "year" }),
    { groupId, plan: "community_m", interval: "year" },
  );
  for (
    const body of [
      null,
      "community_m",
      { group_id: groupId, plan: "community_xl", interval: "year" },
      { group_id: groupId, plan: "community_m", interval: "week" },
      { group_id: "not-a-uuid", plan: "community_m", interval: "year" },
      { group_id: 42, plan: "community_m", interval: "year" },
      { plan: "community_m", interval: "year" },
    ]
  ) {
    assertEquals(parseCheckout(body), null, JSON.stringify(body));
  }
});

Deno.test("safeReturnPath keeps paths in the app only", () => {
  assertEquals(safeReturnPath("/groups/1/plan"), "/groups/1/plan");
  assertEquals(safeReturnPath("/settings"), "/settings");
  for (const path of ["//evil.example", "https://evil.example", "", null, 7]) {
    assertEquals(safeReturnPath(path), "/", String(path));
  }
});

const event = (type: string, object: Record<string, unknown>) =>
  Promise.resolve({ id: "evt_1", type, data: { object } });

const post = () =>
  new Request("http://localhost/stripe-webhook", {
    method: "POST",
    body: "{}",
    headers: { "stripe-signature": "t=1,v1=abc" },
  });

Deno.test("the webhook rejects an invalid signature with 400", async () => {
  const synced: string[] = [];
  const handler = stripeWebhook(
    () => Promise.reject(new Error("No signatures found")),
    (id) => Promise.resolve(void synced.push(id)),
  );
  const response = await handler(post());
  assertEquals(response.status, 400);
  assertEquals(synced, []);
});

Deno.test("the webhook syncs the subscription an event is about", async () => {
  const cases: [string, Record<string, unknown>, string[]][] = [
    ["customer.subscription.updated", { id: "sub_1" }, ["sub_1"]],
    ["customer.subscription.deleted", { id: "sub_2" }, ["sub_2"]],
    [
      "checkout.session.completed",
      { mode: "subscription", subscription: "sub_3" },
      ["sub_3"],
    ],
    ["checkout.session.completed", { mode: "payment" }, []],
    ["invoice.paid", { id: "in_1", subscription: "sub_4" }, []],
  ];
  for (const [type, object, expected] of cases) {
    const synced: string[] = [];
    const handler = stripeWebhook(
      () => event(type, object),
      (id) => Promise.resolve(void synced.push(id)),
    );
    const response = await handler(post());
    assertEquals(response.status, 200, type);
    assertEquals(synced, expected, type);
  }
});

Deno.test("the webhook answers 500 when the sync fails, so Stripe retries", async () => {
  const handler = stripeWebhook(
    () => event("customer.subscription.updated", { id: "sub_1" }),
    () => Promise.reject(new Error("database down")),
  );
  const error = console.error;
  console.error = () => {};
  try {
    assertEquals((await handler(post())).status, 500);
  } finally {
    console.error = error;
  }
});
