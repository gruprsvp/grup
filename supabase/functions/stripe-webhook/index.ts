// Stripe's webhook (docs/billing-and-entitlements.md 8.3). Runs without a
// Supabase JWT (verify_jwt = false in config.toml): Stripe's signature
// authenticates it.
import Stripe from "npm:stripe@22.6.2";
import { stripe, syncStripeSubscription } from "../_shared/billing.ts";
import { stripeWebhook } from "../_shared/billing_logic.ts";

const cryptoProvider = Stripe.createSubtleCryptoProvider();

Deno.serve(stripeWebhook(
  (body, signature) =>
    stripe().webhooks.constructEventAsync(
      body,
      signature,
      Deno.env.get("STRIPE_WEBHOOK_SECRET") ?? "",
      undefined,
      cryptoProvider,
    ),
  syncStripeSubscription,
));
