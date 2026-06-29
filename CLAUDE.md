# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

GRUP is a Flutter app for group event scheduling and RSVP tracking, backed by Supabase. It ships to Android, iOS, and web.

**Naming gotcha:** the repo is "grup"/GRUP but the Dart package is `parousia` (legacy name). All internal imports use `package:parousia/...` and the app/bundle id is `is.giorgio.app.parousia`.

## Commands

```sh
# First-time / after pulling
flutter pub get

# Codegen — REQUIRED whenever you touch models, state, routes, or widgetbook stories.
dart run build_runner watch --delete-conflicting-outputs   # leave running during dev
dart run build_runner build  --delete-conflicting-outputs  # one-shot

# Local backend (Docker must be running). Do this BEFORE running tests.
supabase start
supabase status -o json > supabase/config/localhost.json   # app + tests read this file

flutter analyze --no-fatal-infos           # CI gate (warnings/errors fail; infos advisory)
flutter test                              # whole suite (live tests self-skip if no Supabase)
flutter test --exclude-tags live          # hermetic only — no Docker/Supabase needed
flutter test --tags live                  # only the live-Supabase repository suite
flutter test test/selectors_test.dart     # a single file
flutter test --plain-name "substring"     # a single test/group by name

flutter run                               # the app
flutter run -t lib/widgetbook.dart        # the Widgetbook component catalog
flutter gen-l10n                           # regenerate localizations from lib/l10n/*.arb
```

**Live vs hermetic tests.** Most tests are hermetic. The `repositories_test.dart` suite is tagged `live` and hits a real local Supabase; it **self-skips** when `supabase/config/localhost.json` is absent, so a plain `flutter test` works without Docker. To run the live suite, bring up Supabase first (see below). CI's `verify.yaml` has two jobs: a Docker-free `analyze` job (format + analyze) on every PR, and a `test` job that runs `supabase start` → `supabase test db` (pgTAP) → `flutter test --coverage` → `flutter build web`.

## Code generation

Large parts of `lib/` are generated and must not be hand-edited: `*.freezed.dart` (freezed), `*.g.dart` (json_serializable / go_router_builder / app_state), `go_router_builder.g.dart`, `widgetbook.directories.g.dart`, and `lib/l10n/app_localizations*.dart`. Change the source (`@freezed` class, `@TypedGoRoute`, `.arb` file) and rerun build_runner / gen-l10n.

## Architecture

Redux is the backbone (`redux`, `redux_epics`, `redux_persist`, `redux_entity`, `reselect`, `rxdart`). The store is assembled in `lib/main.dart#_initStore`. Data flows one direction: **UI dispatches action → epic performs side effect → epic dispatches result action → reducer updates state → selector derives view data → container rebuilds**.

Layers under `lib/` (each has a barrel file that re-exports the folder):

- **`models/`** — `@freezed` domain types (`Group`, `Member`, `Schedule`, `Reply`, `Profile`, `Invite`, `DefaultRule`) plus `enum.dart`. Recurring schedules use `RecurrenceRule` from the `rrule` package.
- **`state/`** — `AppState` (freezed, JSON-serializable). Remote data is held as normalized `RemoteEntityState<T>` (from `redux_entity`), one per entity type. Persisted to disk via `redux_persist`; `copyWithoutErrors` strips errors on save and `selectedDate` is reset to today on load.
- **`actions/`** — Redux actions. Note many actions are the **generic** ones from `redux_entity` parameterized by type, e.g. `RequestRetrieveAll<Group>`, `SuccessRetrieveOne<Schedule>`, `FailCreateOne`. Domain actions (e.g. `CreateGroupAction`, `GroupDetailsOpenAction`) live here too.
- **`reducers/`** — pure reducers; `root_reducer.dart` wires them by hand. `remote_entities.dart` defines a `RemoteEntityReducer` per entity (with the `selectId` used as the normalized map key — note composite keys for `DefaultRule` and `Reply`). Signing out resets to `AppState.initialState()`.
- **`epics/`** — all side effects (rxdart streams). Epics call repositories and translate domain actions into the generic `redux_entity` request/success/fail actions (see `epics/groups.dart` for the canonical pattern). Cross-cutting epics react to auth/app-lifecycle actions to trigger loads.
- **`selectors/`** — memoized `reselect` selectors. The RSVP-resolution logic (combining replies + default rules + recurrence instances into a `ScheduleInstanceSummary`) lives in `selectors/schedules.dart` and is the most domain-heavy code.
- **`repositories/`** — Supabase data access. All extend `SupabaseRepository` and mix in `Postgrest` and/or `Storage` (`repositories/supabase.dart`). Table and bucket names come from the `Tables`/`Buckets` enums in `repositories/const.dart`. Some writes go through Postgres RPC functions (e.g. `create_group`).
- **`presentation/`** — three sub-layers:
  - `screens/` — "dumb" widgets; receive everything via constructor params, never touch the store.
  - `containers/` — connect Redux to screens via `StoreConnector` + a `@freezed _ViewModel` with a `fromStore(Store)` factory that builds props and wires `onX` callbacks to `store.dispatch(...)`. (See `containers/home.dart`.)
  - `widgets/` — reusable presentational pieces; `*.stories.dart` are Widgetbook stories.

## Routing

`go_router` with typed routes (`go_router_builder`). The whole route tree is declared with `@TypedGoRoute` annotations on `GoRouteData` classes in `lib/go_router_builder.dart`; `lib/router.dart` just feeds `$appRoutes` to `GoRouter`. Protected routes mix in `AuthenticationGuard`. Navigate using the generated route objects (e.g. `HomeScreenRoute().location`, `GroupDetailsRoute(groupId).go(context)`) rather than raw path strings. Routing-as-side-effect is handled by `epics/routing.dart` + `createRouterEpics`.

## Configuration & environments

- `assets/env/{local,supabase}.json` (`ConfigService` in `lib/util/config.dart`) — picks `local` in debug, `supabase` in release (`kReleaseMode`). Holds `supabaseConfigPath` and OAuth client ids.
- That `supabaseConfigPath` points at a Supabase connection file (`supabase/config/localhost.json` locally), parsed by `SupabaseConfig`. This file is generated by `supabase status -o json` and is gitignored — you must create it for the app/tests to start.
- `flutter_flavorizr` manages build flavors.

## Backend (`supabase/`)

- `migrations/` — SQL schema, functions, RLS, and storage buckets. Production deploy happens in `.github/workflows/build.yaml` (`supabase db push` on merge to `main`).
- `functions/` — Deno edge functions (e.g. `delete_user_account`).
- `tests/` — pgTAP SQL tests for RLS and group logic (`supabase test db`).

## Release

Merging to `main` runs `build.yaml`: tests → push DB migrations → deploy web to the `gh-pages` branch via `peanut` → build & upload the Android bundle → upload symbols/sources to Sentry → create/update a draft GitHub release tagged from the `version:` in `pubspec.yaml`. Analytics is PostHog; error reporting is Sentry (release builds only).
