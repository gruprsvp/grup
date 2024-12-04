# AppFor.it

A calendar app for humans.

[Access it here](https://appfor.it)

## Getting started

### Requirements

1. Flutter[^flutter-get-started]
2. Supabase CLI[^supabase-cli]
3. Docker or another compatible runtime

### Local development

Make sure Docker is running.

From the root of the project, run the following command to start the Supabase server:

```sh
supabase start
```

Export the Supabase URL and API key (this is only needed once):

```sh
supabase status -o json > supabase/config/localhost.json
```

And change the app configuration in `lib/main.dart` (`supabaseConfigFile`) to point to it when running locally.

While making changes, run `build_runner` in watch mode for code generation:

```sh
dart run build_runner watch --delete-conflicting-outputs
```

Tests can be run with the following command:

```sh
flutter test
```

Tests are configure to run against a local Supabase server.
If you want to run tests against a different server,
you can configure a different file in `supabase/config/`
and set it accordingly in the test file.

The app can similarly be configured to run on local or remote servers.

## Release

To release a new version of the app, update the version in `pubspec.yaml` and commit the changes.

Only the `build-name` part - before the plus sign(+) - should be updated:
the `build-number` is incremented automatically by the CI (GitHub Actions and Xcode Cloud).

This will trigger a GitHub action that will create a new release then continue to build and deploy.

[^flutter-get-started]: https://docs.flutter.dev/get-started/install

[^supabase-cli]: https://supabase.com/docs/guides/cli/getting-started
