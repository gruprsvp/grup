# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

One Material 3 design language on every target: Android, iOS and web (Flutter, `package:material_ui`), following Flutter's platform-adaptation guidance. OS-defined behaviours adapt automatically (transitions, back gestures, scroll physics, text selection). Controls users know from the OS use the `.adaptive()` constructors (dialogs, switches, checkboxes, radios, progress indicators). iOS still gets its OS guarantees: safe areas, edge-swipe back, Reduce Motion. There is no separate Cupertino design language.

## Users

**Primary: the organiser of a recurring group activity.** One person runs something that happens regularly, such as weekly training, a club session, game night or a standing dinner, and needs to know who is coming each time without chasing people. Design decisions break ties in their favour.

**Secondary: the members.** They mostly answer: open the app (or the web), say yes or no, set a default answer once and forget it. Some members never install the app; an admin can track their answers for them.

Store marketing also addresses families, couples and friend groups. They are reached through the same organiser-and-members model, not a peer-calendar model.

## Product Purpose

GRUP is group event scheduling with RSVPs. You create a group (or join one), schedule one-off or recurring events for it, and see at a glance who is in and who is out for each occurrence. Success means the organiser knows the headcount for the next occurrence without sending a single "who's coming?" message.

## Positioning

Competes in the shared-calendar space (TimeTree, Cozi, Howbout), but wins on the RSVP: every event collects answers, so "see who's coming" is the product, not a feature on top of a calendar. Recurring events plus **default answers** ("I'm always in on Tuesdays", "weekdays") mean a regular activity is set up once and the attendance mostly fills itself in. RSVP resolution (replies + default rules + recurrence instances) runs client-side.

## Operating Context

- The organiser checks the upcoming occurrence's attendance shortly before it happens, often on a phone.
- Members answer in a few seconds, often from an invite link (`/join/:code`) or a shared web link; answering quickly and repeatedly must never be blocked.
- Groups are small, known-people circles: a team, a club, a family, friends.
- Five locales ship: English, German, Spanish, French, Italian (`lib/l10n/*.arb`, `fastlane/metadata/`).

## Capabilities and Constraints

- **Built:** groups with `admin` and `member` roles; one-off and recurring events (`RecurrenceRule`); replies `yes`/`no`; per-member default rules for recurring events; invites by single-use code, email, or phone; admins tracking members without accounts; profiles with pictures; theme and language settings; in-app feedback; an update-required gate for unsupported app versions.
- **Not built, so never imply it:** push or any other notifications (the store listings currently claim them; that copy is wrong and needs fixing); anonymous replies without an account (discussion #148); custom recurrence patterns beyond the supported rules (discussion #154); realtime updates; offline mode.
- **Account required** to use the app.
- **Technical:** Flutter + Supabase; MVVM (services → repositories → view models → views); typed `go_router` routes, with deep links on Android and iOS. Minimum iOS 16, Android API 26. Dart package is named `parousia` (legacy).

## Brand Commitments

- Name: **GRUP**, written in capitals. Made by Sealambda.
- Existing assets: app icons in `assets/icon/` (standard, dark, grayscale, monochrome); the logo, hosted at grup.rsvp (`/images/logo.png`, `/images/logo-darkmode.png`); marketing images in `assets/images/`.
- Voice in shipped copy: warm, plain, people-first ("get your people together"). App Store copy cannot contain emoji, so iOS and Android listings deliberately differ.
- Open source under AGPL-3.0. Not VC-backed. Public promises: the free core tier will not be made worse, and user data will not be sold.

## Evidence on Hand

- Store listings for 5 locales on both stores: `fastlane/metadata/{android,ios}/`.
- Store-screenshot golden harness: `docs/STORE_SCREENSHOTS.md`.
- FAQ and positioning: `README.md`.
- No testimonials, user counts, ratings, press or case studies are on hand. Do not invent them.

## Product Principles

1. **Who's coming is the answer.** Every surface should get the organiser to the headcount faster. Calendar features serve attendance, not the other way round.
2. **Set it once.** Recurring events and default answers exist so regular activities need no weekly upkeep. Never add per-occurrence chores the defaults could handle.
3. **Answering is instant.** A member's reply is one tap and works from a link. Friction in answering costs the organiser their data.
4. **Simple over complete.** GRUP stays focused on groups and their events, not a general-purpose calendar.
5. **Honest and free at the core.** Claim only what ships, and keep the free core whole.
