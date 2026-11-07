// billing-cancel's pure parts (docs/billing-and-entitlements.md 8.5): the
// public page that cancels or withdraws from plans without signing in.
// Nothing here reads the environment or the network, so tests import it as is.
import { UUID } from "./billing_logic.ts";
import { corsHeaders } from "./cors.ts";

export type CancelAction = "cancel" | "withdraw";

export interface CancelRequest {
  action: CancelAction;
  /** Trimmed and lowercased. */
  email: string;
  /** One group's plan, or null for all the payer's plans. */
  groupId: string | null;
  /** Required for a withdrawal (§ 356a BGB). */
  name: string | null;
  locale: Locale;
}

/** Requests per email address and hour, both actions together. */
export const RATE_LIMIT = 5;

const EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/** A request from the page, or null if it can't be one. */
export function parseCancelRequest(body: unknown): CancelRequest | null {
  const { action, email, group_id, name, locale } = (body ?? {}) as Record<
    string,
    unknown
  >;
  if (action !== "cancel" && action !== "withdraw") return null;
  if (typeof email !== "string") return null;
  const address = email.trim().toLowerCase();
  if (address.length > 254 || !EMAIL.test(address)) return null;
  if (
    group_id != null && (typeof group_id !== "string" || !UUID.test(group_id))
  ) {
    return null;
  }
  const trimmedName = typeof name === "string" ? name.trim() : "";
  if (trimmedName.length > 200) return null;
  if (action === "withdraw" && !trimmedName) return null;
  return {
    action,
    email: address,
    groupId: group_id ?? null,
    name: trimmedName || null,
    locale: LOCALES.includes(locale as Locale) ? locale as Locale : "en",
  };
}

/** What the rate limit counts by: never the email itself. */
export async function emailHash(email: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(email),
  );
  return Array.from(
    new Uint8Array(digest),
    (b) => b.toString(16).padStart(2, "0"),
  )
    .join("");
}

/** A payer's subscription as billing-cancel reads it. */
export interface PayerSubscription {
  id: string;
  providerRef: string;
  provider: string;
  status: string;
  /** Set to end: cancel_at_period_end or cancel_at in Stripe. */
  ending: boolean;
  currentPeriodEnd: Date | null;
  plan: string;
  groupId: string | null;
  groupName: string | null;
}

const ENTITLED = new Set(["trialing", "active", "grace", "canceled_pending"]);

/**
 * The plans a request is about: the payer's running web plans, for one group
 * or all. Store plans (Phase 2) are cancelled in the store.
 */
export function matchSubscriptions(
  subscriptions: PayerSubscription[],
  groupId: string | null,
): PayerSubscription[] {
  return subscriptions.filter((s) =>
    s.provider === "stripe" && ENTITLED.has(s.status) &&
    (groupId === null || s.groupId === groupId)
  );
}

const json = (body: unknown, status: number) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });

/**
 * The billing-cancel handler. A valid request always gets the same answer,
 * whether or not the email has an account or a plan, and before anything is
 * looked up, so neither the answer nor its timing tells who has an account.
 * [allow] records the request and says if it's within the rate limit;
 * [process] does the work in the [background].
 */
export const billingCancel = (deps: {
  allow: (emailHash: string, action: CancelAction) => Promise<boolean>;
  process: (request: CancelRequest) => Promise<void>;
  background: (work: Promise<void>) => void;
}) =>
async (req: Request): Promise<Response> => {
  const request = parseCancelRequest(await req.json().catch(() => null));
  if (!request) return json({ error: "invalid_request" }, 400);
  if (!await deps.allow(await emailHash(request.email), request.action)) {
    return json({ error: "rate_limited" }, 429);
  }
  deps.background(
    deps.process(request).catch((e) => console.error("billing-cancel", e)),
  );
  return json({ ok: true }, 200);
};

// ── The confirmation email ──────────────────────────────────────────────────
// The confirmation on a durable medium that § 312k (4) and § 356a (4) BGB
// require: what was asked, when, which plans, and what happens next.

const LOCALES = ["en", "de", "fr", "it", "es"] as const;
type Locale = typeof LOCALES[number];

/** The plans as the app names them (docs 1.4, 12). */
const PLAN_NAMES: Record<string, string> = {
  community_s: "Crew",
  community_m: "Club",
  community_l: "Crowd",
};

interface Copy {
  cancelSubject: string;
  withdrawSubject: string;
  cancelReceived: (at: string) => string;
  withdrawReceived: (at: string, name: string) => string;
  forGroup: (plan: string, group: string) => string;
  deletedGroup: string;
  endsOn: (date: string) => string;
  noPlans: string;
  cancelNext: string;
  withdrawNext: string;
  questions: string;
}

const COPY: Record<Locale, Copy> = {
  en: {
    cancelSubject: "Your GRUP cancellation",
    withdrawSubject: "Your GRUP withdrawal",
    cancelReceived: (at) => `We received your cancellation on ${at}.`,
    withdrawReceived: (at, name) =>
      `We received your withdrawal on ${at}, from ${name}.`,
    forGroup: (plan, group) => `${plan} for ${group}`,
    deletedGroup: "a deleted group",
    endsOn: (date) => `ends on ${date} and won't renew`,
    noPlans:
      "We found no running plan paid for by this account, so nothing changes.",
    cancelNext:
      "Each plan stays active until the date above, then the group returns to Free. Nothing is deleted. Changed your mind? Use Manage billing in GRUP before that date.",
    withdrawNext:
      "If this is within 14 days of your first payment for the plan, we refund that payment in full within 14 days; the plan ends when the refund is made, and the group returns to Free. Link sends you the refund receipt. Otherwise, we'll get back to you.",
    questions: "Questions? Write to hello@grup.rsvp.",
  },
  de: {
    cancelSubject: "Deine Kündigung bei GRUP",
    withdrawSubject: "Dein Widerruf bei GRUP",
    cancelReceived: (at) => `Wir haben deine Kündigung am ${at} erhalten.`,
    withdrawReceived: (at, name) =>
      `Wir haben deinen Widerruf am ${at} erhalten, von ${name}.`,
    forGroup: (plan, group) => `${plan} für ${group}`,
    deletedGroup: "eine gelöschte Gruppe",
    endsOn: (date) => `endet am ${date} und verlängert sich nicht`,
    noPlans:
      "Wir haben keinen laufenden Plan gefunden, den dieses Konto bezahlt. Es ändert sich also nichts.",
    cancelNext:
      "Jeder Plan bleibt bis zum genannten Datum aktiv, danach ist die Gruppe wieder bei Free. Es wird nichts gelöscht. Doch anders entschieden? Nutze vor diesem Datum „Abrechnung verwalten“ in GRUP.",
    withdrawNext:
      "Liegt dein Widerruf innerhalb von 14 Tagen nach deiner ersten Zahlung für den Plan, erstatten wir diese Zahlung innerhalb von 14 Tagen vollständig; der Plan endet mit der Erstattung, und die Gruppe ist wieder bei Free. Den Beleg für die Erstattung schickt dir Link. Andernfalls melden wir uns bei dir.",
    questions: "Fragen? Schreib an hello@grup.rsvp.",
  },
  fr: {
    cancelSubject: "Ta résiliation GRUP",
    withdrawSubject: "Ta rétractation GRUP",
    cancelReceived: (at) => `Nous avons reçu ta résiliation le ${at}.`,
    withdrawReceived: (at, name) =>
      `Nous avons reçu ta rétractation le ${at}, de la part de ${name}.`,
    forGroup: (plan, group) => `${plan} pour ${group}`,
    deletedGroup: "un groupe supprimé",
    endsOn: (date) => `se termine le ${date} et ne sera pas renouvelé`,
    noPlans:
      "Nous n’avons trouvé aucun forfait en cours payé par ce compte : rien ne change.",
    cancelNext:
      "Chaque forfait reste actif jusqu’à la date indiquée, puis le groupe repasse à Free. Rien n’est supprimé. Tu as changé d’avis ? Utilise « Gérer la facturation » dans GRUP avant cette date.",
    withdrawNext:
      "Si ta demande arrive dans les 14 jours suivant ton premier paiement pour le forfait, nous te remboursons ce paiement en entier sous 14 jours ; le forfait prend fin au remboursement et le groupe repasse à Free. Link t’envoie le reçu du remboursement. Sinon, nous reviendrons vers toi.",
    questions: "Des questions ? Écris à hello@grup.rsvp.",
  },
  it: {
    cancelSubject: "La tua disdetta GRUP",
    withdrawSubject: "Il tuo recesso GRUP",
    cancelReceived: (at) => `Abbiamo ricevuto la tua disdetta il ${at}.`,
    withdrawReceived: (at, name) =>
      `Abbiamo ricevuto il tuo recesso il ${at}, da ${name}.`,
    forGroup: (plan, group) => `${plan} per ${group}`,
    deletedGroup: "un gruppo eliminato",
    endsOn: (date) => `termina il ${date} e non si rinnova`,
    noPlans:
      "Non abbiamo trovato piani attivi pagati da questo account, quindi non cambia nulla.",
    cancelNext:
      "Ogni piano resta attivo fino alla data indicata, poi il gruppo torna a Free. Non viene eliminato nulla. Hai cambiato idea? Usa «Gestisci fatturazione» in GRUP prima di quella data.",
    withdrawNext:
      "Se la richiesta arriva entro 14 giorni dal tuo primo pagamento per il piano, ti rimborsiamo quel pagamento per intero entro 14 giorni; il piano termina con il rimborso e il gruppo torna a Free. La ricevuta del rimborso te la invia Link. Altrimenti ti ricontattiamo noi.",
    questions: "Domande? Scrivi a hello@grup.rsvp.",
  },
  es: {
    cancelSubject: "Tu cancelación de GRUP",
    withdrawSubject: "Tu desistimiento de GRUP",
    cancelReceived: (at) => `Hemos recibido tu cancelación el ${at}.`,
    withdrawReceived: (at, name) =>
      `Hemos recibido tu desistimiento el ${at}, de ${name}.`,
    forGroup: (plan, group) => `${plan} para ${group}`,
    deletedGroup: "un grupo eliminado",
    endsOn: (date) => `termina el ${date} y no se renueva`,
    noPlans:
      "No hemos encontrado ningún plan activo pagado por esta cuenta, así que no cambia nada.",
    cancelNext:
      "Cada plan sigue activo hasta la fecha indicada; después, el grupo vuelve a Free. No se borra nada. ¿Has cambiado de idea? Usa «Gestionar facturación» en GRUP antes de esa fecha.",
    withdrawNext:
      "Si tu solicitud llega dentro de los 14 días siguientes a tu primer pago del plan, te devolvemos ese pago íntegro en un plazo de 14 días; el plan termina con el reembolso y el grupo vuelve a Free. Link te envía el recibo del reembolso. Si no, nos pondremos en contacto contigo.",
    questions: "¿Preguntas? Escribe a hello@grup.rsvp.",
  },
};

/** The confirmation email for [request], received [at], about [plans]. */
export function cancelEmail(
  request: CancelRequest,
  at: Date,
  plans: PayerSubscription[],
): { subject: string; text: string } {
  const copy = COPY[request.locale];
  const dateTime = (d: Date) =>
    new Intl.DateTimeFormat(request.locale, {
      dateStyle: "long",
      timeStyle: "short",
      timeZone: "UTC",
    }).format(d) + " UTC";
  const date = (d: Date) =>
    new Intl.DateTimeFormat(request.locale, {
      dateStyle: "long",
      timeZone: "UTC",
    }).format(d);
  const withdraw = request.action === "withdraw";
  const lines = plans.map((s) => {
    const plan = copy.forGroup(
      PLAN_NAMES[s.plan] ?? s.plan,
      s.groupName ?? copy.deletedGroup,
    );
    return withdraw || !s.currentPeriodEnd
      ? `- ${plan}`
      : `- ${plan}: ${copy.endsOn(date(s.currentPeriodEnd))}`;
  });
  return {
    subject: withdraw ? copy.withdrawSubject : copy.cancelSubject,
    text: [
      withdraw
        ? copy.withdrawReceived(dateTime(at), request.name ?? "")
        : copy.cancelReceived(dateTime(at)),
      "",
      ...(plans.length
        ? [...lines, "", withdraw ? copy.withdrawNext : copy.cancelNext]
        : [copy.noPlans]),
      "",
      copy.questions,
    ].join("\n"),
  };
}
