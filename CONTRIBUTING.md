# Contributing

Hey there! Thanks for thinking about contributing to GRUP! We appreciate all kinds of help, whether it's fixing bugs, adding new features, or improving our documentation.

This guide will help you get started.

## Got ideas or questions?

Check out our [discussions](https://github.com/gruprsvp/grup/discussions). If you don't see a topic that matches your idea or question, feel free to start a new one!

## Reporting Issues

Found a bug? Please let us know by [submitting an issue](https://github.com/gruprsvp/grup/issues/new). Your feedback helps us improve!

## Development

Before diving into a new feature, please start a discussion to share your idea. We love to hear what you're thinking!

If you're new to the project, issues labeled with [good first issue](https://github.com/gruprsvp/grup/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) are a great place to start.

### Setting up your development environment

1. Fork the repository and clone your fork.
2. Make sure you have these tools installed:
   - Flutter[^flutter-get-started]
   - Supabase CLI[^supabase-cli]
   - Docker or another compatible runtime
3. Ensure Docker is running.
4. From the root of the project, start the Supabase server:
   ```sh
   supabase start
   ```
5. Export the Supabase URL and API key (you only need to do this once):
   ```sh
   supabase status -o json > supabase/config/localhost.json
   ```
6. Update the app configuration in `lib/main.dart` (`supabaseConfigFile`) to point to your local setup.
7. While making changes, run `build_runner` in watch mode for code generation:
   ```sh
   dart run build_runner watch --delete-conflicting-outputs
   ```
8. Run tests to make sure everything is working:
   ```sh
   flutter test
   ```

### Submitting a Pull Request

1. Create a new branch from `main` for your feature or bugfix.
2. Make your changes.
3. Ensure all tests pass.
4. Commit your changes with a descriptive commit message.
5. Push your branch to your fork.
6. Open a pull request against the `main` branch of the original repository.
7. Clearly describe the problem and solution in your pull request. Include the issue number if applicable.
8. Wait for a review and address any feedback.

[^flutter-get-started]: https://docs.flutter.dev/get-started/install
[^supabase-cli]: https://supabase.com/docs/guides/cli/getting-started
