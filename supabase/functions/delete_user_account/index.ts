// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";
import { cancelStripeSubscriptions } from "../_shared/billing.ts";

// The secret key replaces the legacy service_role key, which Supabase turns
// off by the end of 2026; both are set while the legacy keys are active.
const secretKey =
  JSON.parse(Deno.env.get("SUPABASE_SECRET_KEYS") || "{}").default ??
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
if (!secretKey) throw new Error("No Supabase secret key is set");

Deno.serve(async (req) => {
  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const supabase = createClient(Deno.env.get("SUPABASE_URL") ?? "", secretKey);

  const headers = { ...corsHeaders, "Content-Type": "application/json" };

  const token = req.headers.get("Authorization")?.split("Bearer ")[1];
  if (!token) {
    return new Response(JSON.stringify({ error: "No token provided" }), {
      status: 401,
      headers,
    });
  }

  const { data: { user }, error: userError } = await supabase.auth.getUser(
    token,
  );
  if (userError || !user) {
    console.error(`Failed to get user: ${userError}`);
    return new Response(JSON.stringify({ error: "Invalid token" }), {
      status: 401,
      headers,
    });
  }

  // Once the account is gone the payer can't cancel: stop renewals first,
  // or refuse to delete rather than keep charging them.
  try {
    await cancelStripeSubscriptions(user.id);
  } catch (e) {
    console.error(`Failed to cancel subscriptions: ${e}`);
    return new Response(
      JSON.stringify({ error: "Could not cancel the subscriptions" }),
      { status: 500, headers },
    );
  }

  const { error: deleteError } = await supabase.auth.admin.deleteUser(
    user.id,
  );
  if (deleteError) {
    console.error(`Failed to delete user: ${deleteError}`);
    return new Response(JSON.stringify({ error: deleteError.message }), {
      status: 400,
      headers,
    });
  }

  return new Response(
    JSON.stringify({ message: "User deleted successfully" }),
    {
      status: 200,
      headers,
    },
  );
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request with a signed-in user's access token. It deletes that user.

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/delete_user_account' \
    --header 'Authorization: Bearer <access token>'

*/
