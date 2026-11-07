// Transactional email through Cloudflare Email Service, the provider that
// production Supabase Auth sends through (custom SMTP from
// grup@notifications.grup.rsvp). Its REST API, so no SMTP client is needed:
// https://developers.cloudflare.com/email-service/api/send-emails/rest-api/

/**
 * Sends a plain-text email. Without CLOUDFLARE_ACCOUNT_ID and
 * CLOUDFLARE_EMAIL_TOKEN (local runs, self-hosted installs) it only logs it.
 */
export async function sendEmail(
  to: string,
  { subject, text }: { subject: string; text: string },
) {
  const account = Deno.env.get("CLOUDFLARE_ACCOUNT_ID");
  const token = Deno.env.get("CLOUDFLARE_EMAIL_TOKEN");
  if (!account || !token) {
    // Subject only: production logs must not hold addresses or names.
    console.warn(`email not configured; not sent: ${subject}`);
    return;
  }
  const response = await fetch(
    `https://api.cloudflare.com/client/v4/accounts/${account}/email/sending/send`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        // shortcut: a bare address, no display name: the API page documents
        // only that form. Add "GRUP" once the named-address shape is checked.
        from: Deno.env.get("EMAIL_FROM") ?? "grup@notifications.grup.rsvp",
        to,
        subject,
        text,
      }),
    },
  );
  const body = await response.json().catch(() => null);
  if (!response.ok || !body?.success) {
    throw new Error(
      `email not sent (${response.status}): ${JSON.stringify(body?.errors)}`,
    );
  }
}
