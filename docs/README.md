# Development

## :rocket: Release

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
