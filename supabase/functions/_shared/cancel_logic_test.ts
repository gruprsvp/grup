import { assertEquals } from "jsr:@std/assert@1.0.19";
import {
  billingCancel,
  cancelEmail,
  type CancelRequest,
  emailHash,
  matchSubscriptions,
  parseCancelRequest,
  type PayerSubscription,
  RATE_LIMIT,
} from "./cancel_logic.ts";

const GROUP = "bbbbbbbb-0000-0000-0000-000000000001";

Deno.test("parseCancelRequest normalises the email and checks each field", () => {
  assertEquals(
    parseCancelRequest({ action: "cancel", email: "  Ann@Example.COM " }),
    {
      action: "cancel",
      email: "ann@example.com",
      groupId: null,
      name: null,
      locale: "en",
    },
  );
  assertEquals(
    parseCancelRequest({
      action: "withdraw",
      email: "ann@example.com",
      group_id: GROUP,
      name: " Ann Smith ",
      locale: "de",
    }),
    {
      action: "withdraw",
      email: "ann@example.com",
      groupId: GROUP,
      name: "Ann Smith",
      locale: "de",
    },
  );
  // An unknown language falls back to English.
  assertEquals(
    parseCancelRequest({ action: "cancel", email: "a@b.co", locale: "xx" })
      ?.locale,
    "en",
  );
  for (
    const body of [
      null,
      {},
      { action: "refund", email: "a@b.co" },
      { action: "cancel", email: "not an email" },
      { action: "cancel", email: `${"a".repeat(250)}@b.co` },
      { action: "cancel", email: "a@b.co", group_id: "x" },
      { action: "withdraw", email: "a@b.co" }, // a withdrawal needs a name
      { action: "withdraw", email: "a@b.co", name: "  " },
      { action: "withdraw", email: "a@b.co", name: "x".repeat(201) },
    ]
  ) {
    assertEquals(parseCancelRequest(body), null, JSON.stringify(body));
  }
});

Deno.test("emailHash is stable and doesn't contain the email", async () => {
  const hash = await emailHash("ann@example.com");
  assertEquals(hash, await emailHash("ann@example.com"));
  assertEquals(hash.length, 64);
  assertEquals(hash.includes("ann"), false);
});

const sub = (over: Partial<PayerSubscription>): PayerSubscription => ({
  id: "s",
  providerRef: "sub_1",
  provider: "stripe",
  status: "active",
  ending: false,
  currentPeriodEnd: new Date("2027-01-31T00:00:00Z"),
  plan: "community_s",
  groupId: GROUP,
  groupName: "Club",
  ...over,
});

Deno.test("matchSubscriptions keeps the payer's running web plans, for one group or all", () => {
  const plans = [
    sub({ id: "active" }),
    sub({ id: "trialing", status: "trialing" }),
    sub({ id: "grace", status: "grace" }),
    sub({ id: "ending", status: "canceled_pending", ending: true }),
    sub({ id: "other group", groupId: "bbbbbbbb-0000-0000-0000-000000000002" }),
    sub({ id: "deleted group", groupId: null, groupName: null }),
    sub({ id: "expired", status: "expired" }),
    sub({ id: "billing_retry", status: "billing_retry" }),
    sub({ id: "store", provider: "app_store" }),
    sub({ id: "manual", provider: "manual" }),
  ];
  assertEquals(matchSubscriptions(plans, null).map((s) => s.id), [
    "active",
    "trialing",
    "grace",
    "ending",
    "other group",
    "deleted group",
  ]);
  assertEquals(matchSubscriptions(plans, GROUP).map((s) => s.id), [
    "active",
    "trialing",
    "grace",
    "ending",
  ]);
});

const post = (body: unknown) =>
  new Request("http://localhost/billing-cancel", {
    method: "POST",
    body: JSON.stringify(body),
  });

Deno.test("billing-cancel answers the same whether or not the email has an account", async () => {
  const answers: [number, string][] = [];
  for (
    const process of [
      () => Promise.resolve(), // a payer with plans
      () => Promise.reject(new Error("no such user")), // or anything failing
      () => new Promise<void>(() => {}), // or still working
    ]
  ) {
    const work: Promise<void>[] = [];
    const handler = billingCancel({
      allow: () => Promise.resolve(true),
      process,
      background: (w) => work.push(w),
    });
    const error = console.error;
    console.error = () => {};
    try {
      const response = await handler(
        post({ action: "cancel", email: "ann@example.com" }),
      );
      answers.push([response.status, await response.text()]);
      await Promise.race([work[0], Promise.resolve()]);
    } finally {
      console.error = error;
    }
  }
  assertEquals(answers, Array(3).fill([200, '{"ok":true}']));
});

Deno.test("billing-cancel refuses invalid requests and too many requests", async () => {
  const processed: CancelRequest[] = [];
  const counts = new Map<string, number>();
  const handler = billingCancel({
    allow: (hash) => {
      const recent = counts.get(hash) ?? 0;
      counts.set(hash, recent + 1);
      return Promise.resolve(recent < RATE_LIMIT);
    },
    process: (r) => Promise.resolve(void processed.push(r)),
    background: () => {},
  });
  assertEquals((await handler(post({ action: "cancel" }))).status, 400);

  const statuses = [];
  for (let i = 0; i <= RATE_LIMIT; i++) {
    statuses.push(
      (await handler(post({ action: "cancel", email: "Ann@example.com" })))
        .status,
    );
  }
  assertEquals(statuses, [...Array(RATE_LIMIT).fill(200), 429]);
  // Another address isn't affected.
  assertEquals(
    (await handler(post({ action: "cancel", email: "bob@example.com" })))
      .status,
    200,
  );
});

Deno.test("cancelEmail says what was asked, when, which plans and what next", () => {
  const at = new Date("2026-11-04T23:40:00Z");
  const cancel = cancelEmail(
    {
      action: "cancel",
      email: "ann@example.com",
      groupId: null,
      name: null,
      locale: "en",
    },
    at,
    [sub({}), sub({ plan: "community_l", groupName: null })],
  );
  assertEquals(cancel.subject, "Your GRUP cancellation");
  assertEquals(
    cancel.text.split("\n").slice(0, 4),
    [
      "We received your cancellation on November 4, 2026 at 11:40 PM UTC.",
      "",
      "- Crew for Club: ends on January 31, 2027 and won't renew",
      "- Crowd for a deleted group: ends on January 31, 2027 and won't renew",
    ],
  );

  const withdraw = cancelEmail(
    {
      action: "withdraw",
      email: "ann@example.com",
      groupId: null,
      name: "Ann Smith",
      locale: "de",
    },
    at,
    [sub({})],
  );
  assertEquals(withdraw.subject, "Dein Widerruf bei GRUP");
  assertEquals(withdraw.text.split("\n")[2], "- Crew für Club");
  assertEquals(withdraw.text.includes("Ann Smith"), true);

  const none = cancelEmail(
    {
      action: "cancel",
      email: "ann@example.com",
      groupId: null,
      name: null,
      locale: "en",
    },
    at,
    [],
  );
  assertEquals(none.text.includes("We found no running plan"), true);
});
