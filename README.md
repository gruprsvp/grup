# Parousia

A calendar app for humans.

[Test environment](http://parousia-flutter.pages.dev)

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

Tests can be run with the following command:

```sh
flutter test
```

Tests are configure to run against a local Supabase server.
If you want to run tests against a different server,
you can configure a different file in `supabase/config/`
and set it accordingly in the test file.

The app can similarly be configured to run on local or remote servers.

## TODO

- [ ] Use Flutter flavours to configure dev and test environments
- [ ] Tailscale to connect to local Supabase server

[^flutter-get-started]: https://docs.flutter.dev/get-started/install

[^supabase-cli]: https://supabase.com/docs/guides/cli/getting-started
