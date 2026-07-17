# GRUP Modernization Assessment & Roadmap

_Prepared 2026-06-28. Based on a full audit of the codebase (Flutter app `parousia` v1.7.2+1) across four areas: Supabase/security, state architecture, testing/CI, and web/dependencies/release._

> **Phase 0 in progress (branch `chore/phase-0-safety-net`).** See [Phase 0 progress & new findings](#phase-0-progress--findings-from-implementation) at the bottom for what's done and what hands-on work uncovered (notably: the app did **not** compile/run on current stable Flutter until several upgrade/migration gaps were fixed).
>
> **Second audit 2026-07-09.** A follow-up review (four parallel deep-dives: core Dart layers, presentation/l10n, backend/tests/CI, tooling/dependencies) verified the Phase-0 work and found **three holes in the safety net itself** plus one systemic blind spot the first audit missed: **the failure half of nearly every flow is untrustworthy** — errors are dropped by type inference, never caught, never surfaced to the user, or recorded as false successes. New plan items are woven into the phases below tagged **[A2]**; a new [Phase 1.5](#phase-15--failure-path-correctness-a2-added-2026-07-09) carries the error-handling workstream; full evidence is in [Appendix E](#e-second-audit-2026-07-09--full-findings).

## TL;DR

The app is a small (~7.5k hand-written LOC), production Flutter + Supabase app with a **sound core** — unidirectional Redux flow, repository-isolated side effects, RLS-backed multi-tenancy — but it has accumulated debt that blocks the stated goals (more features, a pro plan, growth, thorough testing, great web, eventual offline).

The single most important finding is about **sequencing, not any one bug**: almost every worthwhile change here is a refactor (fix selector performance, move/keep RSVP logic, migrate state, add indexes), and **there is currently no safety net to refactor against** — the pre-merge CI gate is skippable, the complex RSVP logic has one shallow test, and most of the app (widgets, screens, ViewModels, epics, routing, edge functions) has zero coverage. So the roadmap is dependency-ordered:

- **Phase 0 — Build the safety net** (CI gate + characterization tests + RLS tests + migration hygiene). Prerequisite for everything else.
- **Phase 1 — High-impact, isolated, low-risk wins** (web share links, performance, persistence bugs, DB indexes; **[A2]** invite-perimeter security fixes, crash-path/l10n/tooling quick wins).
- **Phase 1.5 — Failure-path correctness [A2]** (typed Fail actions, a shared error wrapper, honest deletes, error surfacing in the UI, pagination). Added by the second audit; also a hard prerequisite for offline, which is *entirely* failure paths.
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

### Phase 0 addendum [A2] — holes found in the safety net itself (2026-07-09)

The second audit verified the Phase-0 work as built. Three items don't yet deliver what they claim; fix them **before** relying on the net:

7. **Un-track `supabase/config/localhost.json`** (`git rm --cached supabase/config/localhost.json`). The file was committed before it was gitignored, so it exists on every fresh clone — and the live-suite self-skip checks file *existence* (`test/repositories_test.dart:115`). Result: `flutter test` without Docker **fails today**, contradicting `dart_test.yaml` and CLAUDE.md. (The file also carries the local demo `JWT_SECRET`/`SERVICE_ROLE_KEY` — well-known defaults, but noise; CI regenerates it anyway in `verify.yaml:70` / `build.yaml:46`.)
8. **Close the draft-gate bypass in `verify.yaml`.** The trigger is bare `pull_request:` (no `ready_for_review` type) and the `test` job is skipped on drafts. Push everything as a draft, mark ready → no new run triggers, and a **skipped** required check satisfies branch protection → merge with zero tests. Fix: `types: [opened, synchronize, reopened, ready_for_review]` (or enforce a merge queue).
9. **Make the new tests cover what they claim.**
   - *pgTAP*: the rewritten tests genuinely run as the `authenticated` role with real JWT claims (good), but touch **3 of 16 RLS policies, SELECT-only** — zero INSERT/DELETE policy tests, no admin-vs-plain-member distinction, both `*_all_self` policies (i.e. reply spoofing) and all 3 storage policies untested. ~10 more assertions close the worst gaps. Coverage table in [Appendix E](#e-second-audit-2026-07-09--full-findings).
   - *Characterization tests*: every input is `DateTime.utc(...)` at **midnight**, under which the `copyWith(isUtc: true)` clock-time reinterpretation (`selectors/schedules.dart:49,68`) — the exact hack the suite exists to lock before refactoring — is a no-op. Add local-time/DST inputs, a `startDate` with a time-of-day component, month-boundary rules (monthly on the 29th–31st), `UNTIL`, and `interval > 1` (~6 cases).
10. **Release-pipeline hardening bundle** (extends item 5): add a `concurrency` group to `build.yaml` (two quick merges to `main` currently race prod `db push`, the `gh-pages` force-push, and Play uploads); move `supabase db push` **after** the draft-release version gate (today a forgotten `pubspec.yaml` bump migrates prod, then blocks all app deploys → schema/app skew); add `permissions: contents: read` blocks; SHA-pin third-party actions (`r0adkll/upload-google-play@v1` receives the Play service-account JSON on a movable tag); add the `github-actions` ecosystem to `dependabot.yml`; add `timeout-minutes` to all jobs.

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
   - **[A2] Same theme, one layer up — do it in the same pass:** `distinct: true` is a no-op in ~11 containers because the freezed `_ViewModel`s hold closures (`onSave`, `onReplyChanged`, …) as fields; fresh closures never compare equal, so every dispatch rebuilds every mounted connected container. Hoist callbacks out of equality (exclude from `==`, or a stable callback holder built once per store). `containers/date_dropdown.dart:23-33` additionally has no `==` at all. Also stop storing `Future`s in ViewModels (`containers/group_events.dart:44,63` puts an unmemoized `Future<RruleL10n>` in the VM — guarantees inequality and resets its `FutureBuilder` to "Loading" every rebuild).

**Persistence correctness:**
7. Fix `copyWithoutErrors` — it's a **no-op** (`RemoteEntityState.copyWith` does `error: error ?? this.error`, so `copyWith(error: null)` can't clear), so exception payloads are persisted to disk and reloaded. Clear errors by reconstruction.
8. Add a `version` field + migration hook to persisted state — today any model shape change silently wipes the local cache on upgrade (best case) or crash-loops.
9. Don't nuke preferences on sign-out — `rootReducer` returns `initialState()`, discarding `themeMode`/`locale`/`hasSeenFeedbackCard`. Reset only the entity/auth slices.

**Database — add the indexes that will bite at scale:**
10. Add indexes on `replies(schedule_id)`, `default_rules(schedule_id)`, `schedules(group_id)`, `invites(member_id)` — composite PKs only index the leading column, and these are RLS-subquery / cascade columns.
11. Add `set search_path = public` to the `SECURITY DEFINER` `handle_delete_user` function (every other definer function pins it).

**[A2] Security — close the invite perimeter** (one small PR; isolated, shippable now):

12. Generate invite codes with **`Random.secure()`** — `lib/repositories/invites.dart:35` uses time-seeded `Random()` for 40-bit group-join codes.
13. **`REVOKE EXECUTE` on the SECURITY DEFINER functions from `anon`/`PUBLIC`**, granting back only what each flow needs. The grants migration deliberately withheld table DML from `anon` but never touched function EXECUTE — `check_invite_code` (`20231023170520_functions.sql:114`) is callable unauthenticated via `/rest/v1/rpc/…` with just the anon key, unrate-limited: an enumeration oracle over weakly-generated codes → join arbitrary groups after signup.
14. **Fix the phone-invite contradiction** — `handle_upsert_user` matches `value = '+' || new.phone` (`functions.sql:43`) while `handle_new_invite` matches `phone = new.value` (`functions.sql:162`); the same stored value can't satisfy both, so one flow silently no-ops. Masked because the only phone test is `skip: true` (`test/repositories_test.dart:429`). Pick one canonical format (E.164 with `+`), fix both paths, un-skip the test.
15. **Member self-service policies** — `members` has only `members_select` + admin-only `members_all` (`schema.sql:261-274`): a regular member cannot leave a group (DELETE own row) or set their own `display_name_override`, despite the column comment saying that's the intent. Any future "leave group" UI would silently update 0 rows (see Phase 1.5 item 3 — those deletes would even report success).

**[A2] Correctness & UX quick fixes** (each tiny and independent):

16. Fix `onInit: store.dispatch(AppStartedAction())` (`lib/app.dart:28`) — it *calls* dispatch during build and passes the result (null) as the callback; `AppStartedAction` re-fires on every root rebuild. Should be `onInit: (store) => store.dispatch(AppStartedAction())`.
17. **Null-assertion crash paths on loading state** — controls render tappable while their data is still null: delete menu `group!.id` (`screens/group_manage.dart:42`), reply buttons `scheduleInstance!`/`targetMemberId!` (`screens/group_schedule_details.dart:89-97,134-138`), `member!` tap handlers (`screens/group_member_details.dart:63,72,118,127`), empty-state CTA `group!` (`widgets/group_events.dart:87,95`), `getNameInitials(name)!` (`widgets/group_members.dart:41`). Disable/skeleton the controls while loading; remove the `!`s.
18. **l10n reality** — the .arb layer is 100% translated (5 locales × 99 messages), but three whole categories bypass it: the **entire auth screen** (localization delegate dropped in the `supabase_auth_ui` 0.6.1 migration — TODO at `lib/app.dart:63-67`), **all recurrence text** (`RruleL10nEn.create()` hardcoded at `selectors/locale.dart:21` + `widgets/schedule_form.dart:73`), and **all dates/times** (`Intl.defaultLocale` never set → `DateFormat` renders en_US in every locale). A German user's first screen is fully English. Also: `Text('Licenses')` (`screens/settings_more.dart:18`); raw `snapshot.error.toString()` shown to users (`screens/select_contacts.dart:96`).
19. **Leaks & rebuild churn** — `contact_form.dart:24-27` has three `TextEditingController`s and no `dispose()` at all; `containers/schedules_list.dart:25-31` never disposes its `PageController`; `widgets/schedule_form.dart:72` creates `FutureBuilder(future: RruleL10nEn.create())` per build, so each keystroke collapses the recurrence field to a spinner — hoist the future.
20. **Theme hygiene** — light and dark are seeded from unrelated colors (blue `0xFF34558B` vs olive `0xFF93920B`, `lib/app.dart:30-42`): the brand changes identity in dark mode; twelve orphaned `Color(0x...)` expression statements live inside `build` (`app.dart:44-58`); migrate the 15 deprecated `withOpacity` → `withValues`; `reply_button.dart:125,154` uses raw `Colors.green/red` with surface-colored text (~2.1:1 contrast, WCAG needs 4.5:1) and is theme-blind in dark mode.
21. **A11y pass** — tooltips/semantic labels on icon-only buttons (`widgets/group_events.dart:47-50`, `widgets/image_crop.dart:26-28`, `screens/select_contacts.dart:46-61`, `widgets/invite_modal.dart:72-78`, profile avatar button); `AutofillHints.name` on the profile field; theme-aware reply colors (item 20 fixes contrast).
22. **Deep-link/navigation gaps** — the global redirect squashes every scheme'd URI to `/` (`lib/router.dart:7`) so external deep links to concrete routes are impossible (only invite paths survive via the epic); no `refreshListenable` on GoRouter, so session expiry leaves users parked on protected screens; `AuthRoute` has no signed-in reverse redirect; `GroupManageRoute` is reachable by non-admins (self-acknowledged TODO, `go_router_builder.dart:118-120`); the deeplink invite epic runs while unauthenticated (`consume_invite_code` with `auth.uid() = null` always errors → invitee's first impression is an error banner) and parses bare `/join` as the literal code `"join"`. Slot the route-level fixes into Phase 1 web item 1 — same files.

**[A2] Tooling** (half a day, locks a whole bug-class out):

23. **Strict analyzer modes + lints** — `strict-casts: true` + `strict-raw-types: true` produce only 16 new errors across ~10 sites (measured). Add `avoid_dynamic_calls`, `always_declare_return_types`, `unawaited_futures`, `cancel_subscriptions`, `close_sinks`, `type_annotate_public_apis` (or adopt `very_good_analysis` and subtract). Motivation: `strict-inference`/`always_declare_return_types` would have caught Phase 1.5's headline bug (untyped `FailRetrieveOne`) at compile time. Cheap wins to reach 0 infos: the `withOpacity` migration (item 20), `constant_identifier_names` in `repositories/const.dart:9`.
24. **Delete dead weight** — `linux/` (9 files) + `windows/` (18 files) are never built by CI or released; `DateFab` + `DateFabContainer` are exported but unreferenced; fix the stale `# overridden below` comment on `redux_entity` (`pubspec.yaml:50` — no override exists anymore); **vendor the passkeys `bundle.js`** (`web/index.html:135` hotlinks a GitHub release URL at runtime — availability/privacy, already flagged below in Phase-0 progress notes).

## Phase 1.5 — Failure-path correctness [A2] (added 2026-07-09)

**The second audit's biggest finding, absent from the first audit.** Four defect classes compound so that the store's `loading`/`error`/entity state reliably reflects only the happy path — whenever the network or RLS says no, the app silently shows stale/phantom data or an infinite spinner. The fixes are small and mechanical; do them as one workstream because they share a test seam (a fake repository that fails on demand). This phase is also a **hard prerequisite for offline** (Phase 2): offline is nothing but failure paths.

1. **Type every generic Fail action.** `FailRetrieveOne(id: …, error: …)` without a type argument infers `FailRetrieveOne<dynamic>`, which matches no `RemoteEntityReducer<T>` — the action is silently dropped and `loadingIds[id]` stays true forever (`epics/groups.dart:119`, `epics/members.dart:71` — the latter also stuffs a *group* id into the *members* entity state). Audit every generic action construction; the Phase-1 tooling lints then keep it fixed.
2. **One shared `catch → Fail` wrapper for epics.** Several paths have *no* handler at all (errors become uncaught zone errors — Sentry noise — and dispatch nothing): `_createRetrieveAllGroupsEpic` (`epics/groups.dart:89-96`, `loadingAll` stuck true), the `Future.wait` fan-outs (`epics/members.dart:31`, `epics/invites.dart:39` — partial invite batches with zero feedback), the storage uploads sitting *outside* the `catchError` chain (`epics/groups.dart:132,152`, `epics/profiles.dart:84`), `deleteUserFiles`/sign-out (`epics/profiles.dart:127`). While there, guard the `store.state.auth.user!` / `currentUser!` assertions in long-running epics (`epics/profiles.dart:85,89,126`, `repositories/members.dart:60`, `repositories/storage.dart:17`) — a sign-out racing an in-flight save crashes instead of failing.
3. **Make deletes honest.** All four delete repositories issue `.delete().eq(…)` without `.select()` (`repositories/members.dart:52`, `schedules.dart:33`, `replies.dart:41`, `default_rules.dart:31`) — an RLS-filtered 0-row delete still resolves → `SuccessDeleteOne` → the entity vanishes locally but survives on the server. Append `.select()` and dispatch Fail on 0 rows.
4. **Surface errors in the UI.** There are **zero** reads of any `RemoteEntityState.error` field in `lib/presentation/` and no listener on `Fail*` actions — every failure is an infinite "Loading" or a lying empty state, and `ProfileScreen` pops immediately after dispatching a save (`screens/profile.dart:118-131`), losing failures silently. Minimum viable: one global `Fail*` → SnackBar listener + an error/retry state on the group screens. Also make pull-to-refresh reachable on the empty home screen (`screens/home.dart:113-116` wraps a non-scrollable `Column`, so the new user with a stuck fetch can't even refresh).
5. **Reconcile deletions on fetch.** `SuccessRetrieveMany` only *upserts* (redux_entity), so schedules/replies/default-rules deleted by another member persist locally until sign-out — an admin deletes tomorrow's event and everyone else keeps seeing it with live-looking counts. Decide merge-vs-replace per collection (group-scoped replace on group open is the cheap fix); revisit properly with D3/offline.
6. **Pagination.** No `.range()`/`.limit()` anywhere; PostgREST's default 1000-row cap silently truncates `getUserGroups()`'s embedded members×profiles select — and since `SuccessRetrieveAll<Member>` *replaces* state, known members can vanish. Paginate or raise limits deliberately.
7. **Regression tests that lock this in:** a live test for the reply-upsert conflict path — `onConflict: 'member_id, schedule_id, instance_date'` (`repositories/replies.dart:34`) **contains spaces**, PostgREST whitespace-tolerance is not guaranteed, and "change my RSVP" is exactly the untested path; the un-skipped phone-invite test (Phase 1 item 14); epic tests through the fake failing repository.
8. **Smaller confirmed defects to sweep in the same pass:** theme switcher cycles *backwards* (`reducers/theme.dart:10`, `index - 1`); `DateTime.now()` inside a memoized reselect selector freezes feedback-card eligibility (`selectors/feedback.dart:12`); server enums decode with no unknown-value fallback (`models/enum.dart` — one new server-side enum value fails the *whole* list fetch inside `withConverter`); `updateMember`/`updateProfile` null-skip semantics mean an override/name/picture can never be *cleared* (`repositories/members.dart:37-49`); `getRepliesForDay` uses `toUtc()` while every other path relabels with `copyWith(isUtc: true)` (`repositories/replies.dart:12` — latent wrong-day fetch east of UTC); `Navigator.pop(context)` passes the BuildContext as the pop result (`screens/profile.dart:130`); `sign_out_tile.dart:64` calls `Supabase…signOut()` directly from the widget, bypassing the action→epic flow.

## Phase 2 — Strategic, decision-gated

Gated on D1/D2/D3 and Phase 0 being in place.

- **State layer** — execute D1 (Path A in place, or Path B migration slice-by-slice behind the existing repository interfaces).
- **RSVP resolution** — execute D2 (server-side view/RPC, or fixed client-side).
- **Realtime + engagement** — execute D3 (Supabase Realtime on `replies`/`members`; push notifications).
- **Offline foundations** (if pursued) — this is a **data-layer rebuild, not an extension**: there are no optimistic writes today (entities change only on `Success*`), no mutation queue, no conflict resolution. The schema helps (every table has `updated_at` + client-mintable UUIDv7 ids) but lacks **soft-deletes/tombstones**, so an offline client can't learn about deletions (everything is hard `ON DELETE CASCADE`). Add `deleted_at` + a change-feed before attempting sync. Consider PowerSync/Drift if going local-first.
- **Pro plan + growth infrastructure** — none exists today (only a stale `-- TODO: check subscription status` in `create_group`, and PostHog feature flags are explicitly **disabled** in `lib/util/analytics.dart`). Needs: a `subscriptions`/`entitlements` table + enforcement in the relevant RPCs/insert paths, billing integration (RevenueCat/Stripe), enabling PostHog feature flags for gated rollouts, and richer analytics instrumentation (currently ~10 lines).
- **Environments/flavors** — make env selection `--dart-define`-driven instead of `kReleaseMode`-only (a release build is _always_ prod today), add `staging`/`prod` env files, and actually configure `flutter_flavorizr` (declared but unconfigured — no per-env bundle id/icon).
- **Dependency cleanup** — pin `supabase_auth_ui` fork to a SHA (it's on a moving `ref: main`, 31 commits behind a still-maintained upstream) or rebase customizations onto upstream; fix the false `redux_entity` "overridden below" comment; plan the `styled_text` 8→9 breaking bump. **[A2] 2026-07-09 status:** the fork is gone (upstream 0.6.1, no overrides — done); 7 direct deps now have pending **major** bumps (`google_fonts` 6→8, `flutter_contacts` 1→2, `app_links` 6→7, `device_info_plus`, `package_info_plus`, `share_plus`, `styled_text` 8→9); none of the redux family is formally discontinued on pub.dev, but `redux`/`flutter_redux`/`redux_persist`/`reselect` last published **2021–2022** — consistent with D1's framing.
- **[A2] Storage lifecycle & the profile-write path** — every group/profile picture update uploads a new `uuid.v7` object and never deletes the old one (unbounded orphan growth); group pictures are stored under the *uploader's* user folder (`repositories/storage.dart:17`), so account deletion (`deleteUserFiles`) breaks the picture of every group that user ever set an image for; `bucket().list(path: userId)` uses the default 100-item limit, so "delete everything" doesn't; files are deleted *before* the `delete_user_account` edge function runs (a failure strands a user minus their images). Related: `handle_upsert_user` fires on every `auth.users` UPDATE and can clobber a user-edited display name/picture on the next OAuth sign-in (`functions.sql:34-37`), and `profiles` has no UPDATE policy at all — profile writes exist *only* via that trigger. Redesign the write path (dedicated bucket paths per entity + explicit profile UPDATE policy) alongside D1/offline work.
- **[A2] PII at rest** — the persisted `AppState` includes invitees' emails/phone numbers and the serialized Supabase `User`, written unencrypted to SharedPreferences / web `localStorage` (`lib/main.dart:96-110`). Fold into the persistence-versioning work (Phase 1 item 8): encrypt, or exclude the invites slice and auth payload from persistence.
- **[A2] Widgetbook: invest or remove** — exactly one story file exists (`group_form.stories.dart`, 2 use cases) against ~27 presentation widgets, and `lib/widgetbook.dart:29-33` registers generic `ThemeData.light()/dark()` rather than the app's seeded schemes/font, so even that one component doesn't render as it does in the app. Either wire the real themes and adopt a story-per-widget convention, or delete the scaffolding — a half-maintained catalog is worse than none.

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

### E. Second audit (2026-07-09) — full findings

_Four parallel deep-dives: core Dart layers, presentation/l10n, backend/tests/CI, tooling. Everything below is **new** relative to sections A–D; items are cross-referenced from the phases above. Confidence noted where it isn't "confirmed by reading the code path end-to-end"._

**E1. Failure-path defects (→ Phase 1.5)**
- Untyped `FailRetrieveOne` → `FailRetrieveOne<dynamic>` matches no reducer; dropped silently (`epics/groups.dart:119`, `epics/members.dart:71` — which also uses a group id as a members-state key).
- Epics with no error handler: `epics/groups.dart:89-96,132,152`, `epics/members.dart:31`, `epics/invites.dart:39`, `epics/profiles.dart:84,127`. `EpicMiddleware` subscribes without `onError`, so these surface as uncaught zone errors.
- Fire-and-forget deletes (no `.select()`): `repositories/members.dart:52`, `schedules.dart:33`, `replies.dart:41`, `default_rules.dart:31`.
- Zero reads of `RemoteEntityState.error` in `lib/presentation/`; save-and-pop loses failures (`screens/profile.dart:118-131`); pull-to-refresh unreachable on the empty home screen (`screens/home.dart:113-116`).
- `SuccessRetrieveMany` merge-only → deletions by other users never evicted locally (redux_entity reducer; only `SuccessRetrieveAll` resets `entities`).
- No pagination anywhere (no `.range()`/`.limit()`; PostgREST default 1000-row cap — cap value is standard hosted config, _plausible_ for this project's setting).
- Reply-upsert `onConflict` contains spaces (`repositories/replies.dart:34`) — _plausible_ (needs one live test); the conflict path ("change my RSVP") is untested.
- Auth null-assertion races in epics/repos: `epics/profiles.dart:85,89,126`, `repositories/members.dart:60`, `repositories/storage.dart:17`.
- Deeplink invite epic runs unauthenticated + parses bare `/join` as the code `"join"` (`epics/invites.dart`).
- Smaller: backwards theme cycle (`reducers/theme.dart:10`); `DateTime.now()` in a memoized selector (`selectors/feedback.dart:12`); strict enum decoding, no unknown-value fallback (`models/enum.dart`); un-clearable name/picture/override (`repositories/members.dart:37-49`, `profiles.dart`); `toUtc()` vs `copyWith(isUtc:true)` inconsistency (`repositories/replies.dart:12`, latent); `pop(context)` as result (`screens/profile.dart:130`); direct `signOut()` from a widget (`widgets/sign_out_tile.dart:64`).

**E2. Safety-net holes (→ Phase 0 addendum)**
- `supabase/config/localhost.json` git-tracked since before it was gitignored → live-suite self-skip (`test/repositories_test.dart:115`) never fires; `flutter test` without Docker fails on a fresh clone. Contains local demo secrets; CI overwrites it (`verify.yaml:70`, `build.yaml:46`).
- verify.yaml draft-gate bypass: bare `pull_request:` trigger (no `ready_for_review`) + skipped-check-passes branch-protection semantics.
- Characterization tests: all inputs `DateTime.utc` midnight → `copyWith(isUtc:true)` reinterpretation (`selectors/schedules.dart:49,68`) unpinned; no DST/local, month-boundary, `UNTIL`, `interval>1`, or time-of-day `startDate` cases.
- Live-test hygiene (minor): un-awaited `deleteUser` in a catch path (`repositories_test.dart:68`); `DateTime.now()` near-midnight-UTC flake window (`:725-761`); benign double-delete in `runWithTemporaryGroup` (`:100-104`).

**RLS policy coverage as of this branch** (pgTAP = the new `supabase/tests/`; Live = the Dart `live` suite):

| Table | Policy | pgTAP (as `authenticated`) | Live suite |
|---|---|---|---|
| profiles | profiles_select | — | positive only |
| groups | groups_select | ✅ pos+neg | ✅ pos+neg |
| groups | groups_update | partial (no-op UPDATE; WITH CHECK never exercised) | ✅ pos+neg |
| groups | groups_delete | — | ✅ pos+neg |
| groups | insert (RPC `create_group`) | ✅ | ✅ |
| members | members_select | neg only | ✅ pos |
| members | members_all | — | ✅ pos+neg |
| invites | invites_all | — | pos only |
| schedules | schedules_select | — | pos only |
| schedules | schedules_all | — | pos only; **non-admin write never tested anywhere** |
| default_rules | default_rules_select | — | pos only |
| default_rules | default_rules_all | — | pos (admin) |
| default_rules | default_rules_all_self | — | **untested** |
| replies | replies_select | — | pos only |
| replies | replies_all | — | pos (admin) |
| replies | replies_all_self | — | **untested** (incl. within-group reply-spoofing negative) |
| storage.objects | insert / select / delete (3) | — | **untested anywhere** |

**E3. Backend/security (→ Phase 1 items 12–15, Phase 2)**
- Non-crypto `Random()` invite codes (`repositories/invites.dart:35`) + PUBLIC-executable `check_invite_code` SECURITY DEFINER (`functions.sql:114`) = unauthenticated, unrate-limited enumeration oracle (exploitability _plausible_; both facts confirmed).
- Phone-invite format contradiction (`functions.sql:43` vs `:162`); masked by the skipped test.
- `members` policies block self-service (leave group / own `display_name_override`) — `schema.sql:261-274`.
- `handle_upsert_user` fires on every `auth.users` UPDATE; OAuth sign-in can clobber user profile edits (_plausible_); `profiles` has no UPDATE/DELETE policy — trigger is the only write path.
- Grants migration verified sound + idempotent; residual gaps: default privileges make future tables `authenticated`-writable until RLS is enabled (a forgotten `enable row level security` = cross-tenant DML), and function EXECUTE untouched (see above).
- Edge function `delete_user_account`: no HTTP-method check, no `Access-Control-Allow-Methods` on preflight, no top-level try/catch, `SERVICE_ROLE_KEY ?? ""` builds a broken client instead of failing fast (all low; token validation itself is correct).
- config.toml drift: no `[auth.external.google]` and apple disabled — the app's social-auth path is untestable locally/in CI; `site_url` points at prod from local.
- Very low: no format CHECK on `invites.value`; duplicate email invites possible; `default_rules.recurrence_rule ⊆ schedule.recurrence_rule` unenforced (TODO at `schema.sql:133`). Positives: composite PK prevents duplicate replies; timestamptz everywhere; partial unique index guards code collisions.

**E4. CI/release (→ Phase 0 addendum item 10)**
- build.yaml: no concurrency group (racing prod `db push` / gh-pages force-push / Play uploads); `db push` before the draft-release version gate (schema/app skew on a forgotten version bump); unused `workflow_dispatch` `version` input.
- Both workflows: no `permissions:` blocks; tag-pinned actions (incl. `r0adkll/upload-google-play@v1` holding the Play service account); dependabot lacks `github-actions`; no `timeout-minutes`.

**E5. Presentation (→ Phase 1 items 6b, 16–22)**
- `distinct: true` defeated by closures in freezed ViewModels across ~11 containers; `date_dropdown.dart:23-33` has no `==`; Futures stored in VMs (`containers/group_events.dart:44,63`).
- `onInit` dispatch-during-build (`app.dart:28`); null-assertion crash paths (E1 list, item 17 above); undisposed controllers; per-build `RruleL10nEn.create()` future.
- Navigation: scheme-URI redirect squash (`router.dart:7`), no `refreshListenable`, no reverse redirect on `/auth`, non-admin `GroupManageRoute` (TODO'd at `go_router_builder.dart:118-120`), guarded-route back-stack workaround (`screens/auth.dart:31`).
- l10n: .arb complete (5×99, 0 untranslated) but auth screen / recurrence text / date-time formatting are English-only in all non-English locales; `Intl.defaultLocale` never set.
- A11y: unlabeled icon-only buttons (5 sites), ~2.1:1 reply-button contrast, missing autofill hints.
- Theme: unrelated light/dark seeds; 12 dead `Color` statements in `build`; `withOpacity` deprecations; `empty_state.dart:24` fakes dark mode via `invertColors` (_plausible_ visual defect).
- Dead/rotting: `DateFab`(+container) unreferenced; Widgetbook at 1 story / ~27 widgets with non-app themes.

**E6. Tooling/dependencies (→ Phase 1 items 23–24)**
- `flutter analyze`: exit 0, 39 infos (18 `strict_top_level_inference`, 15 `deprecated_member_use`, …). `strict-casts` + `strict-raw-types`: only 16 new errors at ~10 sites (`lib/main.dart:87-93`, `repositories/groups.dart:76-79`, `widgets/form_builder_recurrence_rule.dart:215-216`, `app.dart:28`, `actions/groups.dart:28`, `go_router_builder.dart:186`, `util/supabase_config.dart:28`).
- Major bumps pending: `google_fonts` 6→8, `flutter_contacts` 1→2, `app_links` 6→7, `device_info_plus` 12→13, `package_info_plus` 9→10, `share_plus` 12→13, `styled_text` 8→9. Dormant-not-discontinued: `redux`/`redux_persist`/`reselect` (2021), `flutter_redux` (2022), `mailto` (2021).
- Android tooling current (AGP 8.11.2, Kotlin 2.2.0, Gradle 8.14.3, SDK levels on Flutter defaults); `linux/`+`windows/` dead weight; passkeys `bundle.js` still hotlinked (`web/index.html:135`); PostHog double-init still unverified (Confirm #3); 37 TODOs in `lib/` — notable: `go_router_builder.dart:114` (missing admin check), `app.dart:67` (auth l10n re-base).

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
   - **Build system — SPM kept (Flutter default).** A `Module 'flutter_contacts' not found` failure at launch looked like an SPM/CocoaPods-hybrid problem, but the real cause was a broken `pod install` (CocoaPods had been uninstalled + a stale `GoogleSignIn` pin in `ios/Podfile.lock`). With CocoaPods installed and the lock regenerated, **both iOS-simulator and macOS builds succeed with SPM enabled** — no need to disable it. **Local requirement:** just `brew install cocoapods` (documented in CLAUDE.md). CI unaffected (web/Android only).

4. **The `supabase_auth_ui` fork blocks the web build** — it pins `font_awesome ^10.6.0` (blocking the bump) AND its `supa_socials_auth.dart` returns `FontAwesomeIcons.*` as `IconData`, which font_awesome 11 makes `FaIconData`. So the fork compiles under neither font_awesome 10 (final IconData) nor 11 (its own getter breaks). **This still blocks `flutter build web` and therefore full CI green.** Needs a decision (fix the fork — a one-line `IconData`→`FaIconData` change you own — or migrate to upstream `supabase_auth_ui` 0.6.1, re-basing the `SupaPasswordAuth`/l10n customizations). Local tests were unblocked by removing a redundant `supabase_auth_ui` import from `repositories_test.dart`.

### Remaining Phase 0 _(updated 2026-07-17 — all automatable items done; only manual GitHub steps remain)_
- ~~**Split hermetic vs live-Supabase tests**~~ **Done** (`dart_test.yaml` `live` tag, `@Tags` + self-skip in `repositories_test.dart`). The addendum-7 concern is moot: `supabase/config/localhost.json` is **not** git-tracked (verified 2026-07-17), so the self-skip works on fresh clones.
- ~~**De-risk `build.yaml`**~~ **Done 2026-07-17** (addendum item 10): non-cancelling `concurrency` group serializes deploys; prod `db push` moved **after** the draft-release version gate; default `permissions: contents: read` (build job keeps `write`); `timeout-minutes` everywhere; third-party actions SHA-pinned (incl. `upload-google-play`, which receives the Play service-account JSON); dependabot now tracks `github-actions`. _Not done: iOS build in CI (needs a macOS runner — cost decision) and a staging gate for `db push` (needs a staging environment — Phase 2 environments work)._
- ~~**Close the verify.yaml draft-gate bypass**~~ **Done 2026-07-17**: explicit `types: [opened, synchronize, reopened, ready_for_review]` on the `pull_request` trigger.
- ~~**Widen pgTAP + characterization coverage**~~ **Done 2026-07-17** (addendum item 9): `write_policies_test.sql` (20 assertions — admin-vs-member writes, reply/default-rule spoofing negatives, no-direct-INSERT on `groups`, and a pin on "a plain member cannot leave a group" to flip when Phase 1 item 15 lands) + `storage_test.sql` (7 — INSERT/SELECT behavioral; DELETE pinned declaratively because the storage service's statement-level `protect_objects_delete` trigger blocks all direct SQL deletes). pgTAP total: 37 assertions. Characterization suite grew 12 → 19: local-time relabeling (verified under two extreme TZs), moment-vs-day matching, time-of-day `startDate`, monthly 29th/31st boundaries, `UNTIL`, `interval > 1`.
- ~~**dbdev HTTP-fetch migration**~~ **Done 2026-07-17**: `20230706000000_dbdev.sql` now vendors `gen_random_uuid_v7()` verbatim (pinned from `kiwicopple-pg_idkit` 0.0.4, the prod-installed version) instead of fetching installer SQL over HTTP; `http`/`pg_tle` and the unused idkit functions are no longer installed on fresh environments. Prod is unaffected (migration already in its history). Verified: `supabase db reset` applies offline; pgTAP 37/37; full Flutter suite 187 passing incl. live.
- **Make the CI check required** in GitHub branch protection (manual step — require both `analyze` and `test`), and **activate blame-ignore** locally: `git config blame.ignoreRevsFile .git-blame-ignore-revs`.

_Small corrections from re-verification: analyze is exit 0 with **39** infos (not 38); everything else in "Completed" above checks out as claimed (split CI jobs with caching, upstream `supabase_auth_ui` 0.6.1 with zero overrides, clean working tree)._

### Note on this branch and production
`chore/phase-0-safety-net` includes two **new/edited migrations** (`functions.sql` comment removal, `20260628120000_grant_api_roles.sql`). They are safe for prod (idempotent; prod already has these privileges and never applied the removed comment), but they **will run on `supabase db push`** when merged — review accordingly. Nothing has been pushed or deployed.
