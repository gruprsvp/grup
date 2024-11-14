// https://supabase.com/docs/guides/functions/cors

// When you're building a Supabase Function, you'll need to handle CORS headers.
// This is a common pattern for serverless functions, and it's important to ensure that your function can be invoked from a browser.
export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};
