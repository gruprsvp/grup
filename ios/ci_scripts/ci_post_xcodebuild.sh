#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd "$CI_PRIMARY_REPOSITORY_PATH" # change working directory to the root of your cloned repo.

# Make Flutter and Dart available in the PATH (it was already installed in the ci_post_clone.sh script)
export PATH="$PATH:$HOME/flutter/bin"

# We need a common release name for Sentry.
# This command gets the version from the pubspec.yaml file - without the +1 part.
# SENTRY_DIST below will be the CI_BUILD_NUMBER.
# This grep command is different from the one in GitHub Actions because here we are on macOS.
SENTRY_RELEASE="is.giorgio.app.parousia@$(grep '^version:' pubspec.yaml | awk -F'[ +]' '{print $2}')+${CI_BUILD_NUMBER}"
export SENTRY_RELEASE

# https://docs.sentry.io/platforms/flutter/configuration/options/#dist
# The dist parameter is used to separate different versions of the app in Sentry.
export SENTRY_DIST="$CI_BUILD_NUMBER"

# Run Sentry Dart plugin to upload source maps and debug symbols to Sentry.
dart run sentry_dart_plugin

exit 0
