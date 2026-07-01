# GRUP Modernization Assessment & Roadmap

_Prepared 2026-06-28. Based on a full audit of the codebase (Flutter app `parousia` v1.7.2+1) across four areas: Supabase/security, state architecture, testing/CI, and web/dependencies/release._

> **Phase 0 in progress (branch `chore/phase-0-safety-net`).** See [Phase 0 progress & new findings](#phase-0-progress--findings-from-implementation) at the bottom for what's done and what hands-on work uncovered (notably: the app did **not** compile/run on current stable Flutter until several upgrade/migration gaps were fixed).

## TL;DR

The app is a small (~7.5k hand-written LOC), production Flutter + Supabase app with a **sound core** — unidirectional Redux flow, repository-isolated side effects, RLS-backed multi-tenancy — but it has accumulated debt that blocks the stated goals (more features, a pro plan, growth, thorough testing, great web, eventual offline).

The single most important finding is about **sequencing, not any one bug**: almost every worthwhile change here is a refactor (fix selector performance, move/keep RSVP logic, migrate state, add indexes), and **there is currently no safety net to refactor against** — the pre-merge CI gate is skippable, the complex RSVP logic has one shallow test, and most of the app (widgets, screens, ViewModels, epics, routing, edge functions) has zero coverage. So the roadmap is dependency-ordered:

- **Phase 0 — Build the safety net** (CI gate + characterization tests + RLS tests + migration hygiene). Prerequisite for everything else.
- **Phase 1 — High-impact, isolated, low-risk wins** (web share links, performance, persistence bugs, DB indexes).
- **Phase 2 — Strategic, decision-gated work** (state-layer evolution, realtime, offline, pro plan).

Three genuine decisions need your input before Phase 2 — see [Decisions](#decisions-need-your-input).

---

## How to read this

Each audit produced per-area `Critical/High/Medium/Low` labels. **Do not read those as a global priority order.** A "Critical" web bug and a "Critical" architecture refactor are not peers — the web bug is isolated and shippable today; the refactor needs tests first. The phases below re-sequence everything by _dependency and risk_, which is what matters for a production app. Per-area severities and `file:line` evidence are preserved in the [Appendix](#appendix-full-findings-by-area).

---

## Decisions (need your input)

These three forks genuinely change the roadmap and have real trade-offs. My recommendation is given, but they're yours to make.

### D1 — State management: fix-in-place vs migrate

The Redux core is fine; the problems are _how it's used_ (broken memoization) and _what it depends on_ (`redux_entity` is an abandoned third-party package with 0 likes / ~158 downloads / no update in ~20 months, yet it defines your state shape, reducers, and action vocabulary across 16 files).

- **Path A — Fix in place** (low risk, ~weeks): repair memoization, vendor `redux_entity` into the repo, fix the persistence bugs. Keeps the testable epic layer.
- **Path B — Migrate to Riverpod or Bloc** (medium risk, ~1–2 months): kills the per-feature boilerplate and the dead dependencies, gives first-party async/offline patterns and memoized providers.

**Recommendation: Path A now** (most of it is bug-fixing you want regardless), and treat the abandoned `redux_entity` as the trigger — when it next blocks a Dart/Flutter SDK upgrade, that's when Path B pays for itself. Path A is also the de-risking step _for_ Path B (clean boundaries + tests first).

### D2 — RSVP resolution: server-side vs client-side (this trades against offline)

The RSVP/recurrence resolution (`selectors/schedules.dart`) is the app's most complex logic and its biggest performance problem (see C1). There are two ways to fix it, and **they pull in opposite directions**:

- **Move it server-side** (Postgres view/RPC returning already-resolved instances): best for performance, web, and keeping clients thin — but it makes **offline-first harder**, because an offline client can't resolve RSVPs locally.
- **Keep it client-side but fix it** (correct memoization + materialize + cache recurrence expansion): preserves the offline path, costs more client complexity.

**Recommendation:** Since offline is an explicit future goal, **keep resolution client-side and fix it properly** (C1 a–d), _unless_ you decide offline is off the table — in which case server-side is cleaner. Don't do both blindly.

### D3 — Engagement loop: realtime + push notifications

**Blind spot across all audits:** for a collaborative RSVP app, there is **no realtime and no push/notification mechanism**. Members only see each other's replies on manual refresh, and nothing nudges anyone to reply. For "ensure growth," the missing engagement loop may matter more than any refactor.

**Recommendation:** Treat as a Phase 2 product bet. Supabase Realtime on `replies`/`members` is cheap (RLS already filters); push notifications are a larger build. Decide whether engagement or the pro plan comes first.

---

## Confirm before acting (verify, don't assume)

These are unverified hypotheses from static analysis. Each is _verify-then-act_, not a confirmed finding:

1. **Prod email-confirmation setting.** `supabase/config.toml` has `enable_confirmations = false`, but that file is **local-dev only** (CI runs `db push`, not `config push`). If prod mirrors it, there's an invite-auto-claim risk (register someone else's email → auto-link their pending invites). **Check the Supabase dashboard.**
2. **Web host: Cloudflare Pages vs GitHub Pages.** `pubspec.yaml` comment says Cloudflare; the workflow pushes to `gh-pages`; there's no `CNAME`. This gates whether you can set `COOP/COEP` headers (→ skwasm renderer), cache headers, and per-URL OG injection — and whether peanut's force-push could wipe a `CNAME`. **Confirm where `grup.rsvp` is actually served.**
3. **PostHog double-init on web.** `web/index.html` runs `posthog.init(...)` _and_ `lib/main.dart` calls `Posthog().setup(...)` with the same key. **Verify you're not double-counting web events.**
4. **Cold-start deep links.** `lib/main.dart` subscribes to `uriLinkStream` but never calls `getInitialAppLink()`; in `app_links` 6.x the launch URL isn't replayed on the stream. **Test a cold-start invite link on native + web.**

---

## Phase 0 — Build the safety net (prerequisite, low risk)

Nothing structural should be touched until this exists. None of it changes app behavior; all of it makes later phases safe.

1. **Make the CI gate real and non-skippable.** Add `flutter analyze` and `dart format --set-exit-if-changed` to `verify.yaml` (currently neither runs). Remove/justify the `startsWith(title,'Draft')` skip and require the check in branch protection — today a Draft-titled PR can merge to `main` with zero tests run. Add pub/SDK caching. _This is the single highest-leverage first step: a few lines, protects 100% of files, closes the "unverified code reaches main" hole._
2. **Characterization tests for the logic you're about to refactor** (Docker-free, hermetic): exhaustive table-driven tests for `selectors/schedules.dart` (recurrence intervals, all `CommonRecurrenceRules`, DST/timezone boundaries, default-rule-vs-override precedence) and the container `fromStore` ViewModel factories (pure functions, currently zero coverage). These lock the RSVP contract and UI-state contract before any change.
3. **Real RLS tests, actually run.** The existing `supabase/tests/rls_test.sql` tests _no policy_ and `groups_test.sql` can't pass (calls `create_group` with the wrong signature). Rewrite as real pgTAP (`login_as_user`, assert cross-tenant reads return 0 rows) and **wire `supabase test db` into `verify.yaml`** — RLS is your _sole_ tenant-isolation boundary and is currently untested.
4. **Split hermetic vs live-Supabase tests.** `flutter test` out-of-the-box fails today (the live suite imports a gitignored `localhost.json`). Tag/fold the live-backend suite separately so contributors can run unit tests Docker-free, and run the contract suite explicitly in CI.
5. **De-risk the release pipeline.** Split the monolithic `build.yaml` job so `supabase db push` **to production** isn't coupled to (and triggered on) every push to `main` with no staging gate. Add iOS to the build verification (CLAUDE.md says the app ships iOS; CI never builds it).
6. **Migration hygiene** (reproducibility/DR, not an active exploit — these already ran in prod): replace the first migration that fetches SQL over HTTP from `api.database.dev` and `EXECUTE`s it (`20230706000000_dbdev.sql`) with vendored, pinned extension installs; remove the hard-coded anon key; drop the destructive `drop table if exists …` header from the schema migration. This matters the moment you stand up a staging environment or rebuild from history.

## Phase 1 — High-impact, isolated, low-risk wins

Each is shippable independently once Phase 0 gives you coverage.

**Web — fix shareable invite links end-to-end** (the core share flow is currently broken on web):
1. Add a `/join/:code` route (and any other shared paths) to go_router + a friendly `errorBuilder`; route invite handling through go_router instead of only the `app_links` epic. Today `grup.rsvp/.../join/CODE` renders "page not found."
2. Adopt `usePathUrlStrategy()` **and** add an SPA fallback (`404.html` / `_redirects`) **together** — switching one without the other breaks routing. Removes the `#/` URLs and aligns with the universal-link config.
3. Add static Open Graph / Twitter Card meta to `web/index.html` (blank previews today); plan per-invite dynamic cards via the host's edge layer later.
4. Call `getInitialAppLink()` at startup (fixes native cold-start too — see Confirm #4).
5. Quick fixes: `manifest.json` `short_name` is `"AFIT"` (wrong app name); remove `user-scalable=no` (a11y/zoom).

**Performance — fix the RSVP selector pipeline** (C1 a–d; see D2 for the server-side option):
6. Make leaf selectors return the stored `Map`/value, not freshly-allocated `.values` iterables (reselect's `==` never matches a new iterable → the whole chain recomputes every frame). Materialize selector outputs with `.toList()`. In the schedules-list widget, index a materialized list, not a lazy iterable (`elementAt` on a lazy iterable is O(index) and re-runs the pipeline → ~O(n²) per render). Cache per-rule recurrence expansion.

**Persistence correctness:**
7. Fix `copyWithoutErrors` — it's a **no-op** (`RemoteEntityState.copyWith` does `error: error ?? this.error`, so `copyWith(error: null)` can't clear), so exception payloads are persisted to disk and reloaded. Clear errors by reconstruction.
8. Add a `version` field + migration hook to persisted state — today any model shape change silently wipes the local cache on upgrade (best case) or crash-loops.
9. Don't nuke preferences on sign-out — `rootReducer` returns `initialState()`, discarding `themeMode`/`locale`/`hasSeenFeedbackCard`. Reset only the entity/auth slices.

**Database — add the indexes that will bite at scale:**
10. Add indexes on `replies(schedule_id)`, `default_rules(schedule_id)`, `schedules(group_id)`, `invites(member_id)` — composite PKs only index the leading column, and these are RLS-subquery / cascade columns.
11. Add `set search_path = public` to the `SECURITY DEFINER` `handle_delete_user` function (every other definer function pins it).

## Phase 2 — Strategic, decision-gated

Gated on D1/D2/D3 and Phase 0 being in place.

- **State layer** — execute D1 (Path A in place, or Path B migration slice-by-slice behind the existing repository interfaces).
- **RSVP resolution** — execute D2 (server-side view/RPC, or fixed client-side).
- **Realtime + engagement** — execute D3 (Supabase Realtime on `replies`/`members`; push notifications).
- **Offline foundations** (if pursued) — this is a **data-layer rebuild, not an extension**: there are no optimistic writes today (entities change only on `Success*`), no mutation queue, no conflict resolution. The schema helps (every table has `updated_at` + client-mintable UUIDv7 ids) but lacks **soft-deletes/tombstones**, so an offline client can't learn about deletions (everything is hard `ON DELETE CASCADE`). Add `deleted_at` + a change-feed before attempting sync. Consider PowerSync/Drift if going local-first.
- **Pro plan + growth infrastructure** — none exists today (only a stale `-- TODO: check subscription status` in `create_group`, and PostHog feature flags are explicitly **disabled** in `lib/util/analytics.dart`). Needs: a `subscriptions`/`entitlements` table + enforcement in the relevant RPCs/insert paths, billing integration (RevenueCat/Stripe), enabling PostHog feature flags for gated rollouts, and richer analytics instrumentation (currently ~10 lines).
- **Environments/flavors** — make env selection `--dart-define`-driven instead of `kReleaseMode`-only (a release build is _always_ prod today), add `staging`/`prod` env files, and actually configure `flutter_flavorizr` (declared but unconfigured — no per-env bundle id/icon).
- **Dependency cleanup** — pin `supabase_auth_ui` fork to a SHA (it's on a moving `ref: main`, 31 commits behind a still-maintained upstream) or rebase customizations onto upstream; fix the false `redux_entity` "overridden below" comment; plan the `styled_text` 8→9 breaking bump.

---

## Appendix: Full findings by area

> Severities below are _per-area_, as reported by each audit. Use the phases above for global priority.

### A. Supabase / security

- **(Reproducibility/supply-chain)** `20230706000000_dbdev.sql:12-31` fetches SQL over HTTP from `api.database.dev` and `EXECUTE`s it at deploy; hard-coded anon key at `:21`. `20230707220325_schema.sql:1-10` opens with `drop table if exists …`. Already applied in prod; risk is on fresh environments / history reset.
- **(High)** RLS is the _sole_ access boundary (no app-layer ownership filters anywhere in `lib/repositories/`) and is effectively untested: `tests/groups_test.sql:7` calls `create_group` with the wrong arity and asserts a non-existent `role_id`; `tests/rls_test.sql` tests no policy; neither runs in CI. **Note:** the commented-out `getUserGroups()` filter (`repositories/groups.dart:18-20`) is **not** a data leak — RLS (`groups_select USING (is_member_of_group(id))`, etc.) covers it; that line is data-shaping, not access control.
- **(High, verify)** `config.toml:59-60` `enable_confirmations = false` → invite auto-claim via the `handle_upsert_user` trigger (`functions.sql:39-50`). Local config only — confirm prod.
- **(Medium)** No Realtime anywhere (config, migrations, or client). Collaborative data is stale until manual refresh.
- **(Medium)** Unindexed FKs / trailing composite-key columns: `replies(schedule_id)`, `default_rules(schedule_id)`, `schedules(group_id)`, `invites(member_id)`.
- **(Medium)** No billing/plan enforcement (`functions.sql:13` TODO only).
- **(Medium)** `handle_delete_user` (`functions.sql:64-68`) is `SECURITY DEFINER` without `set search_path`.
- **(Low)** Cross-group write-integrity gap in `replies`/`default_rules` policies (member from group A + schedule from group B). Storage SELECT policy misleading for a public bucket; orphaned storage on account delete. Stale `roles` table / `Buckets.private` in `repositories/const.dart`.
- **Edge function** `delete_user_account/index.ts` reviewed — **OK** (token-derived `user.id`, no IDOR, service-role server-side only).
- **Offline-readiness:** helped by `updated_at` triggers + UUIDv7; blocked by no soft-deletes/tombstones + pervasive cascade deletes.

### B. State architecture

- **(Critical)** C1 — RSVP pipeline defeats memoization and is O(n²) per frame: leaf selectors return fresh `.values` iterables (`selectors/schedules.dart:3-4`, `selectors/replies.dart:3-4`, `selectors/default_rules.dart:3-4`) so reselect never caches; `selectScheduleInstancesForSelectedDate` returns a lazy iterable (`selectors.dart:64`) so `distinct` can't short-circuit; the widget calls `.length` + `.elementAt(index)` ×2 per row (`widgets/schedules_list.dart:36-40`), re-running recurrence expansion each time.
- **(High)** H1 — `redux_entity` is abandoned/near-zero-adoption yet structurally central (16 files). H2 — `copyWithoutErrors` is a no-op (`app_state.dart:41-50` + careapp `copyWith` `error: error ?? this.error`). H3 — no persisted-state versioning/migration; upgrades silently wipe cache or crash-loop.
- **(Medium)** M1 — persistence is a read-cache, not an offline foundation (no optimistic writes, no queue, full-state JSON write per dispatch, no debounce). M2 — sign-out nukes preferences. M3 — ~12-14 files touched per new entity. M4 — hand-combined `rootReducer` (`root_reducer.dart:17` TODO) + invite-state coupled onto Group entity.
- **(Low)** `yield null` epic smell; uniform `.catchError → Fail*` swallowing (compounds H2); `DateTimeRangeCompare.contains` strict-boundary bug (`util/datetime.dart:44`); `profile.dart` container missing `distinct`; dead code (`redux_logging` unused, unused `getMember` memo, redundant `.toString()` on string ids); tri-named project (`parousia`/`grup`/`sealambda`).
- **Verdict:** core is sound; problems are usage + dead deps. Migration risk **MEDIUM** (clean boundaries). Do Path A now; Path B when `redux_entity` blocks an SDK bump.

### C. Testing / CI

- **Coverage:** strong on generic `redux_entity` reducers; **zero** on widgets, screens, container ViewModels, epics, routing, edge functions, and 11/12 selectors. No `integration_test/` directory despite the dependency. RSVP logic has one shallow, partly non-deterministic test (`selectors_test.dart:70` uses `Random()`).
- **Infra:** not hermetic — `repositories_test.dart:12-13` needs a live Dockerized Supabase; no Supabase mocking seam; default `flutter test` fails out-of-the-box.
- **CI gaps:** no `analyze`, no `format`, no coverage, no caching, single platform, no iOS build; gate skippable via Draft PR title (`verify.yaml:16`); `build.yaml` runs prod `db push` post-merge with no pgTAP gate.
- **Dead tests:** `rls_test.sql` tests nothing; `groups_test.sql` can't pass; skipped phone test (`repositories_test.dart:399`); vacuous assertion (`remote_entity_reducer_tester.dart:583`).
- **Highest-leverage first step:** non-skippable `analyze`/`format` gate; then characterization tests on `selectors/schedules.dart` + container `fromStore`.

### D. Web / dependencies / release

- **(Critical)** No `/join/:code` route + no `errorBuilder` → invite links 404 on web (`go_router_builder.dart`, `router.dart:5`; consumption only in `epics/invites.dart:51`). Hash URL strategy (no `usePathUrlStrategy()`) clashes with universal-link config, kills SEO/OG.
- **(High)** No OG/Twitter meta (`web/index.html`) → blank previews. Cold-start link dropped (`main.dart:63`, no `getInitialAppLink()`). CanvasKit-only; skwasm blocked by missing COOP/COEP headers. `supabase_auth_ui` fork on moving `ref: main`, 31 commits behind live upstream. Monolithic CI runs prod `db push` every commit.
- **(Medium)** `manifest.json:3` `short_name: "AFIT"`; `index.html:35` `user-scalable=no`; no `404.html`/`_redirects`/`CNAME` on gh-pages; host ambiguous (Cloudflare vs gh-pages); env not staging-ready (`config.dart:21` `kReleaseMode`-only; flavorizr unconfigured); false `redux_entity` override comment (`pubspec.yaml:50`); `styled_text` 8→9 pending; PostHog double-init (verify).
- **(Good)** Fonts bundled, no runtime fetch; redux_persist storage branched correctly for web; shipped web bundle contains only anon key + URL (no secrets).
- **Top web wins:** `/join` route + `errorBuilder`; path strategy + SPA fallback (together); OG tags; `getInitialAppLink()`; `short_name`/zoom fixes; confirm host → enable headers.

---

## Phase 0 progress & findings from implementation

Work done on branch `chore/phase-0-safety-net`. **All 180 local tests pass** (1 skipped — the pre-disabled phone test), including 12 new RSVP characterization tests and the full live-Supabase repository suite.

### Completed (committed, all green — analyze exit 0, 180 Dart tests + 10 pgTAP tests pass, `flutter build web` succeeds)
- **CI gate hardened** (`.github/workflows/verify.yaml`): split into a fast always-on `analyze` job (`dart format --set-exit-if-changed` + `flutter analyze --no-fatal-infos`, no Docker, runs on drafts too) and a `test` job with Flutter SDK caching, `flutter test --coverage` + coverage artifact, and `supabase test db`. Replaced the fragile title-based `Draft` skip with the native `draft` gate. _(Branch protection to make the check required is a manual GitHub step.)_
- **Analyze is clean** (exit 0): excluded generated code from the analyzer (`analysis_options.yaml`) and fixed all ~14 warning-level issues. 38 advisory infos remain (non-blocking).
- **Repo-wide `dart format`** applied as an isolated commit + `.git-blame-ignore-revs` (run `git config blame.ignoreRevsFile .git-blame-ignore-revs` once to activate locally).
- **RSVP characterization tests** (`test/schedules_characterization_test.dart`): 12 hermetic tests locking `selectors/schedules.dart` — instance expansion (daily/once/weekly/weekends, window edges, startDate clamping), default-rule subset recurrence, reply-overrides-default, non-member filtering, `targetMemberId` split, `yesCount` aggregation.
- **Real RLS pgTAP tests** (`supabase/tests/`): rewrote the dead tests into self-contained policy tests (auth via role + JWT claims) asserting cross-tenant isolation; wired into CI via `supabase test db`.
- **Auth-UI fork removed**: migrated to upstream `supabase_auth_ui` 0.6.1, dropping all `dependency_overrides` and the git fork.

### New findings (the app did not build/run on current stable Flutter)
The team's recent "finalise upgrades" commits left the project **uncompilable on stable Flutter 3.44.4**. Fixing this was a prerequisite for any testing:

1. **Migrations don't apply on a current Supabase stack** — `functions.sql` had `comment on trigger ... on auth.users`, which needs ownership the migration role lacks → `must be owner of relation users`, aborting `supabase start`. **Fixed:** removed the two non-functional comments.
2. **Public tables lack DML grants on fresh databases** — no migration ever `GRANT`s; prod got grants implicitly at provisioning, but current CLI stacks don't, so `anon/authenticated/service_role` only had `TRUNCATE/REFERENCES/TRIGGER` → `permission denied for table groups (42501)` on ~17 tests. **Fixed:** added append-only `20260628120000_grant_api_roles.sql` (idempotent, RLS still governs rows). _Both 1 & 2 are the same class as the §A dbdev reproducibility debt._
3. **font_awesome_flutter 10.x is incompatible with Flutter 3.44** — Flutter made `IconData` a `final` class; `font_awesome 10.x` extends it. **Fixed:** bumped to `^11.0.0` (override) and migrated `reply_button.dart` to the new `FaIconData` type.
5. **Current `supabase_flutter` (2.15) drags in passkeys, which crashes web at startup.** Migrating to upstream `supabase_auth_ui` 0.6.1 forced `supabase_flutter ^2.15.0`, which hard-depends on `passkeys`; `passkeys_web` registers during Flutter bootstrap and throws (white screen) unless the Corbado `bundle.js` is in `index.html` — and `flutter build web` does **not** catch this (only a runtime smoke test did). **Fixed:** added the bundle per the authors' docs. _Note: the authors' snippet hotlinks a GitHub release URL at runtime; for production, vendoring the bundle locally (or behind your own domain) is advisable — availability/privacy._ The app does not use passkeys; it came in transitively. Auth runtime smoke test (web) confirms the app now boots to `/auth` and renders `SupaEmailAuth` + `SupaSocialsAuth` with working font_awesome icons.

   **Platform deployment-target cascade (same root cause).** `passkeys_darwin`/native plugins set minimum OS floors:
   - **macOS:** required 13.5 (build failed: "PasskeysPlugin is only available in macOS 13.5 or newer"). **Fixed** — bumped the macOS target 10.15 → 13.5 (macOS desktop is dev-only, not shipped, so harmless). Also requires CocoaPods installed locally (`brew install cocoapods`).
   - **iOS — DONE (decision: accept iOS 16 minimum).** Bumped `ios/Podfile` + the 3 `IPHONEOS_DEPLOYMENT_TARGET` configs 12 → 16 so passkeys compiles. **This drops iOS 12–15 users** — update the App Store listing/expectations accordingly. **Verified: iOS simulator + macOS debug builds succeed** (device runtime still worth a final smoke test before shipping).
   - **Build system — pure CocoaPods (SPM disabled).** Flutter 3.44 auto-enables Swift Package Manager, but `flutter_contacts`/`posthog_flutter`/`sign_in_with_apple` are CocoaPods-only; the hybrid broke module resolution at launch (`Module 'flutter_contacts' not found`). Reverted the auto-SPM integration and standardized on CocoaPods. **Local requirement:** `brew install cocoapods` + `flutter config --no-enable-swift-package-manager` (documented in CLAUDE.md). Not committable per-repo (global flutter config); CI is unaffected (web/Android only).

4. **The `supabase_auth_ui` fork blocks the web build** — it pins `font_awesome ^10.6.0` (blocking the bump) AND its `supa_socials_auth.dart` returns `FontAwesomeIcons.*` as `IconData`, which font_awesome 11 makes `FaIconData`. So the fork compiles under neither font_awesome 10 (final IconData) nor 11 (its own getter breaks). **This still blocks `flutter build web` and therefore full CI green.** Needs a decision (fix the fork — a one-line `IconData`→`FaIconData` change you own — or migrate to upstream `supabase_auth_ui` 0.6.1, re-basing the `SupaPasswordAuth`/l10n customizations). Local tests were unblocked by removing a redundant `supabase_auth_ui` import from `repositories_test.dart`.

### Remaining Phase 0
- **Split hermetic vs live-Supabase tests** so `flutter test` runs Docker-free by default (tag the repository suite, run it explicitly in CI).
- **De-risk `build.yaml`** (gate prod `db push`, add iOS build) — _production-sensitive, propose before merging._
- **dbdev HTTP-fetch migration** (`20230706000000_dbdev.sql`): vendor/pin the extensions instead of fetching SQL over HTTP — _production-sensitive; the local stack currently depends on network at `supabase start`._
- **Make the CI check required** in GitHub branch protection (manual step), and **activate blame-ignore** locally: `git config blame.ignoreRevsFile .git-blame-ignore-revs`.

### Note on this branch and production
`chore/phase-0-safety-net` includes two **new/edited migrations** (`functions.sql` comment removal, `20260628120000_grant_api_roles.sql`). They are safe for prod (idempotent; prod already has these privileges and never applied the removed comment), but they **will run on `supabase db push`** when merged — review accordingly. Nothing has been pushed or deployed.
