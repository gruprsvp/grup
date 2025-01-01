#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd "$CI_PRIMARY_REPOSITORY_PATH" # change working directory to the root of your cloned repo.

# Make Flutter and Dart available in the PATH (it was already installed in the ci_post_clone.sh script)
export PATH="$PATH:$HOME/flutter/bin"

# Run Sentry Dart plugin to upload source maps and debug symbols to Sentry.
dart run sentry_dart_plugin

exit 0

