# Grup

Event Scheduling for Groups

[Access it here](https://grup.rsvp)

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

Any changes to `main` will trigger both GitHub Actions and Xcode Cloud workflows.

These workflows will build and upload the app to the Play Store and App Store respectively.
Upon upload, the will be available for internal testing in both stores.

Additionally, the GitHub Action will create a new release with the app's version and changelog, marking it as a draft.
It will also deploy the app to Cloudflare Pages.

Once we decide to release the app, we manually request a review from the Play Store and App Store.
Then, we can publish the release on GitHub.

Finally, on the next PR we bump the version on `pubspec.yaml` to prepare for the next release.
Only the `build-name` part - before the plus sign(+) - should be updated:
the `build-number` is incremented automatically by the CI (GitHub Actions and Xcode Cloud).

[^flutter-get-started]: https://docs.flutter.dev/get-started/install

[^supabase-cli]: https://supabase.com/docs/guides/cli/getting-started
