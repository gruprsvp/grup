#!/bin/sh

# CI/CD for Flutter
# From https://docs.flutter.dev/deployment/cd#post-clone-script

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd "$CI_PRIMARY_REPOSITORY_PATH" # change working directory to the root of your cloned repo.

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
export PATH="$PATH:$HOME/flutter/bin"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# TestFlight "What to Test" notes: Xcode Cloud picks up ios/TestFlight/WhatToTest.<locale>.txt
# automatically. Source them from the repo's canonical release notes (fastlane metadata).
mkdir -p ios/TestFlight
cp fastlane/metadata/ios/en-GB/release_notes.txt ios/TestFlight/WhatToTest.en-GB.txt
cp fastlane/metadata/ios/en-GB/release_notes.txt ios/TestFlight/WhatToTest.en-US.txt

# No CocoaPods: every iOS plugin is a Swift package. Xcode Cloud archives with
# automatic package resolution off, so the committed
# ios/Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved must match.

exit 0
