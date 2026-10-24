# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

GRUP is a Flutter app for group event scheduling and RSVP tracking, backed by Supabase. It ships to Android, iOS, and web.

**Naming gotcha:** the repo is "grup"/GRUP but the Dart package is `parousia` (legacy name). All internal imports use `package:parousia/...` and the app/bundle id is `is.giorgio.app.parousia`.

## Commands

```sh
# First-time / after pulling
flutter pub get

# Codegen — REQUIRED whenever you touch models, state, or routes.
dart run build_runner watch --delete-conflicting-outputs   # leave running during dev
dart run build_runner build  --delete-conflicting-outputs  # one-shot

# Local backend (Docker must be running). Do this BEFORE running tests.
supabase start
# Write the file the app (debug/profile) and tests read, with this Mac's LAN
# address instead of 127.0.0.1: on a physical phone, 127.0.0.1 is the phone.
# Re-run it when the Mac's IP changes (another network).
ip=$(ipconfig getifaddr "$(route -n get default | awk '/interface:/ {print $2}')")
supabase status -o json | sed "s/127\.0\.0\.1/${ip:-127.0.0.1}/g" > supabase/config/localhost.json

flutter analyze --no-fatal-infos           # CI gate (warnings/errors fail; infos advisory)
flutter test                              # whole suite (live tests self-skip if no Supabase)
flutter test --exclude-tags live          # hermetic only — no Docker/Supabase needed
flutter test --tags live                  # only the live-Supabase service suite
flutter test test/app_flow_test.dart      # a single file
flutter test --plain-name "substring"     # a single test/group by name

flutter run                               # the app (web/Chrome needs no extra setup)
flutter gen-l10n                           # regenerate localizations from lib/l10n/*.arb
```

**iOS / macOS builds use Swift Package Manager only.** Every plugin ships as a Swift
package, so there is no Podfile and CocoaPods isn't needed. Xcode Cloud archives with
automatic package resolution off, so `ios/Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved`
is committed and must be regenerated whenever plugin dependencies change (a
`flutter build ios` does it). A "failed to emit precompiled module" error after dependency
changes is stale DerivedData (delete `~/Library/Developer/Xcode/DerivedData/Runner-*`).
Minimum OS: **iOS 16**, **macOS 13.5** (set for the since-removed `passkeys`
dependency; sentry_flutter 10 needs iOS 15, so iOS could go back to 15).
CI only builds web + Android; Xcode Cloud builds iOS.

**Android toolchain:** AGP 9.1 / Gradle 9.3.1 / Kotlin Gradle plugin 2.4 (the newest Flutter
3.47 supports), Groovy DSL. Builds on Android Studio's bundled JDK and on Java 17 (CI).
`android/gradle.properties` keeps `android.builtInKotlin=false` and `android.newDsl=false`:
these are temporary opt-outs because `in_app_review` and `posthog_flutter` still apply KGP
(the build prints them). Flip both to `true` once those plugins migrate; Flutter will
eventually drop the opt-out. Minimum Android is **API 26** (sentry_flutter 10).

**Material is `package:material_ui`.** Since Flutter 3.47 Material ships as the `material_ui`
pub package; app code imports `package:material_ui/material_ui.dart`, never
`package:flutter/material.dart`. The two define distinct types (`MaterialApp`, `Theme`,
`MaterialLocalizations`, …), and mixing them usually fails at runtime, not at compile time:
go_router silently drops page transitions, and framework widgets miss their Theme,
localizations or `ScaffoldMessenger`. Third-party widgets still built on framework Material
live in **legacy islands**. Today there is one, `lib/presentation/screens/auth.dart`
(`supabase_auth_ui`), which rebuilds the framework ancestor chain under
`MaterialUiCompatibilityBridge`. The `analyze` CI job fails on framework-Material imports
outside that allowlist; a new island needs an allowlist entry in `verify.yaml` and a widget
test like `test/auth_screen_test.dart`. In tests, use `appTheme()`,
`appLocalizationsDelegates` and `appSupportedLocales` from `lib/app.dart` (plus
`test/support/fake_supabase.dart`), not `AppLocalizations.localizationsDelegates`: gen-l10n
lists the framework Material delegates, which `material_ui` widgets don't read.

**`dart fix` gotcha:** `dart fix --apply`, even with `--code=...`, also applies the pubspec
`missing_dependency` fix, which can move a dev-only package into runtime `dependencies` if
anything under `lib/` imports it. Keep test-only code (e.g. `test/support/fake_data.dart`,
which uses `faker`) under `test/`, and check the pubspec diff after running it.

**Live vs hermetic tests.** Most tests are hermetic. The `services_test.dart` suite is tagged `live` and hits a real local Supabase; it **self-skips** when `supabase/config/localhost.json` is absent, so a plain `flutter test` works without Docker. To run the live suite, bring up Supabase first (see below). CI's `verify.yaml` has three jobs: a Docker-free `analyze` job (format + analyze) on every PR, a `test` job that runs `supabase start` → `supabase test db` (pgTAP) → `flutter test --coverage` → `flutter build web`, and an `android` job (debug APK + release R8 minification, no signing) so Android breakage surfaces before the release job.

## Code generation

Large parts of `lib/` are generated and must not be hand-edited: `*.freezed.dart` (freezed), `*.g.dart` (json_serializable / go_router_builder), `go_router_builder.g.dart`, and `lib/l10n/app_localizations*.dart`. Change the source (`@freezed` class, `@TypedGoRoute`, `.arb` file) and rerun build_runner / gen-l10n.

## Architecture

MVVM as in Flutter's architecture guide (docs.flutter.dev/app-architecture): **services → repositories → view models → views**, with `provider` for dependency injection. Data flows one way: a view calls a view-model method or `Command`; the view model calls a repository; the repository calls services, updates its cached data and notifies; view models listening to it recompute and notify; views rebuild.

Layers under `lib/` (each has a barrel file that re-exports the folder):

- **`models/`** — `@freezed` domain types (`Group`, `Member`, `Schedule`, `Reply`, `Profile`, `Invite`, `DefaultRule`) plus `enum.dart`. Recurring schedules use `RecurrenceRule` from the `rrule` package. `rsvp.dart` holds the RSVP resolution (`getScheduleInstances`, `repliesForScheduleInstance`, `scheduleInstanceDetails`): pure functions combining replies, default rules and recurrence instances. It is the most domain-heavy code, pinned by `test/schedules_characterization_test.dart`.
- **`services/`** — Supabase data access, stateless; they throw. All extend `SupabaseService` and mix in `Postgrest` and/or `Storage` (`services/supabase.dart`). Table and bucket names come from the `Tables`/`Buckets` enums in `services/const.dart`. Some writes go through Postgres RPC functions (e.g. `create_group`). Lists decode row by row (`decodeRows`), so one undecodable row doesn't sink the list. Deletes select the deleted row, so a delete that matched nothing fails (PGRST116). `LocalCache` (SharedPreferences) keeps the repositories' data on the device.
- **`repositories/`** — the source of truth: `ChangeNotifier`s that cache data and return `Result` (`util/result.dart`); they never throw, `guard` (`util/errors.dart`) turns failures into typed `AppException`s and reports the unexpected ones to Sentry. `GroupsRepository` (groups, members, profiles, invites), `SchedulesRepository` (schedules, default rules, replies; replies and rules are optimistic and roll back), `ProfileRepository` (own profile), `AuthRepository` (who is signed in; notifies only when the user changes), `SettingsRepository` (theme, language, feedback; survive sign-out). The user-data repositories extend `UserData`: `switchUser` swaps in a user's cached data, and results of requests started for a previous user are dropped (read `generation` before the request, apply with `ifCurrent`). **Deliberate deviation from the guide: no abstract repository classes** — the test seam is at the services (`test/support/fake_backend.dart`), so each repository would have one implementation.
- **`dependencies.dart`** — the composition root: builds services (`supabaseServices`), repositories (`Repositories.create`) and their providers, and switches the repositories to the new user on every auth change. `main.dart` and the tests use it.
- **`presentation/`**:
  - `view_models/` — one `ViewModel` (a `ChangeNotifier` that relays its repositories and commands) per screen. User actions are `Command`s (`util/command.dart`, from the guide plus a `catch`): views read `running`/`result` and show failures with `showFailure`. Actions the user may repeat quickly (answering events) are plain methods returning `Result`, because a command ignores calls while running.
  - `containers/` — create a screen's view model (`ChangeNotifierProvider` + `Consumer`, or a `State` when there are side effects such as navigation) and pass its data and callbacks to the screen.
  - `screens/` — "dumb" widgets; receive everything via constructor params.
  - `widgets/` — reusable presentational pieces, also dumb.

Tests mirror the layers: `test/services_test.dart` (live), `test/repositories/`, `test/view_models/` and the widget tests run the real repositories and view models over `FakeBackend` (`test/support/harness.dart#fakeApp`); `test/app_flow_test.dart` and `test/router_test.dart` drive the whole app.

## Routing

`go_router` with typed routes (`go_router_builder`). The whole route tree is declared with `@TypedGoRoute` annotations on `GoRouteData` classes in `lib/go_router_builder.dart`; `lib/router.dart` creates the `GoRouter` with `refreshListenable: AuthRepository` and one top-level `redirect`: signed-out users go to `/auth?from=…` and come back after signing in; links that open the app (Flutter deep linking is on for Android and iOS) arrive with scheme and host and are opened at their path. `/auth` is a top-level route so nothing is built under it. Invite links are `/join/:code`. Navigate with the generated route objects (e.g. `GroupDetailsRoute(groupId: id).go(context)`, `GroupScheduleCreateRoute(groupId: id).push<Schedule>(context)`) rather than raw path strings. Use `go` when the new page's parent route is the page on screen: the stack is the same and the web address follows it (`push` leaves the address alone; `optionURLReflectsImperativeAPIs` is discouraged by go_router). Use `push` for pages that return a result, or whose parent route isn't on screen (member details is opened from manage, but its parent route is group details; settings is opened from profile, but its parent route is home). `test/app_flow_test.dart` checks the address.

## Configuration & environments

- `assets/env/{local,supabase}.json` (`ConfigService` in `lib/util/config.dart`) — picks `local` in debug, `supabase` in release (`kReleaseMode`). Holds `supabaseConfigPath` and OAuth client ids.
- That `supabaseConfigPath` points at a Supabase connection file (`supabase/config/localhost.json` locally, `supabase/config/supabase.json` in release), parsed by `SupabaseConfig`. The app uses its `API_URL` and `PUBLISHABLE_KEY`, never the legacy `ANON_KEY`; `test/util/supabase_config_test.dart` checks that the release file holds a publishable key. The local file is generated by `supabase status -o json` (with the Mac's LAN address, see Commands) and is gitignored — you must create it for the app/tests to start. The LAN address works from the simulators, the Android emulator, the browser and the tests too, since local Supabase listens on all interfaces. iOS asks for Local Network access the first time the app reaches it; if that was denied, the connection fails until it's re-enabled in Settings → Privacy & Security → Local Network.

## Backend (`supabase/`)

- `migrations/` — SQL schema, functions, RLS, and storage buckets. Production deploy happens in `.github/workflows/build.yaml` (`supabase db push` on merge to `main`). **New objects get no privileges by default** (`20261023120000_default_privileges.sql`, matching Supabase's 2026-10-30 change): a new table needs `enable row level security` plus explicit `grant select, insert, update, delete … to authenticated, service_role`, or prod answers 42501. A new function is executable by `authenticated` and `service_role` only; revoke that too for trigger functions. `supabase/tests/default_privileges_test.sql` checks every table, and CI runs `supabase db advisors --local --type security --fail-on warn`.
- `functions/` — Deno edge functions (e.g. `delete_user_account`). The same `build.yaml` step deploys them (`supabase functions deploy`, after `db push`). They read the secret key from `SUPABASE_SECRET_KEYS`; the legacy `SUPABASE_SERVICE_ROLE_KEY` is only a fallback.
- `tests/` — pgTAP SQL tests for RLS and group logic (`supabase test db`).
- CI pins the Supabase CLI (`version:` on `supabase/setup-cli` in `verify.yaml` and in `build.yaml`, which also runs the prod `db push`). Dependabot doesn't bump it: update both, and your local CLI, together.

## Store listings & release notes

`fastlane/metadata/{android,ios}/<locale>/` is the source of truth for both store
listings (see `fastlane/README.md`). Merging changes there triggers
`store-metadata.yaml` which pushes them to the stores. User-facing release notes
for the next release live in `fastlane/metadata/android/<locale>/changelogs/default.txt`
(mirrored in `ios/<locale>/release_notes.txt`) and flow into the GitHub draft
release, the Play "What's new", and TestFlight "What to Test".

## Release

Merging to `main` runs `build.yaml`: tests → create/update a draft GitHub release tagged from the `version:` in `pubspec.yaml` → push DB migrations and deploy edge functions → deploy web to the `gh-pages` branch via `peanut` → build & upload the Android bundle → upload symbols/sources to Sentry. Analytics is PostHog, error reporting is Sentry. The app starts both in release builds only; on web, PostHog is started by the `web/index.html` snippet on any host except localhost. Local runs therefore don't reach production analytics.

**Minimum version.** `web/app_version.json` holds the oldest `version:` (pubspec, without `+N`) each store build still supports; older Android/iOS installs show only `UpdateRequiredScreen`. It ships with the web deploy, i.e. on every merge to `main`, so raise it in its own PR, and only once the new version is live in that store: raising it alongside the release would block users from an update they can't install yet. Unreadable or missing, it blocks nobody.
