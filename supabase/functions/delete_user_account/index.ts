// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { corsHeaders } from "../_shared/cors.ts";

Deno.serve(async (req) => {
  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL") ?? "",
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
  );

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
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/delete_user_account' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
