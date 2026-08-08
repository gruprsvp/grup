# Store metadata as code

`fastlane/metadata/` is the **source of truth for both store listings**. Edit the
files here, merge to `main`, and `.github/workflows/store-metadata.yaml` pushes
them to the stores (`fastlane android sync_metadata` / `fastlane ios sync_metadata`).
Don't edit listings in the Play Console / App Store Connect UI — the next sync
will overwrite them.

## Layout

```
metadata/
  android/<locale>/            # Play Store (supply layout)
    title.txt                  # ≤ 30 chars
    short_description.txt      # ≤ 80 chars
    full_description.txt       # ≤ 4000 chars
    changelogs/default.txt     # ≤ 500 chars — "What's new" for the NEXT release
    images/                    # en-GB only for now; synced by checksum
  ios/<locale>/                # App Store (deliver layout)
    name.txt                   # ≤ 30 chars
    subtitle.txt               # ≤ 30 chars
    description.txt            # ≤ 4000 chars
    keywords.txt               # ≤ 100 chars, comma-separated, no spaces needed
    release_notes.txt          # "What's New" for the editable (upcoming) version
    promotional_text.txt       # ≤ 170 chars, updatable without review
    marketing_url.txt / support_url.txt / privacy_url.txt
```

Locale names differ per store: Play uses `en-GB`, `de-DE`, `it-IT`, … while the
App Store side must use deliver's names (`it`, not `it-IT` — deliver errors out
listing the valid names if you get one wrong). The app itself ships
en/de/es/fr/it (`lib/l10n/`) — keep listing locales in step.

**No emoji in App Store text** — the ASC API rejects them in `description` (and
friends) with "invalid characters". Play descriptions may use emoji, so the
`android/` and `ios/` copies of the same text intentionally differ there.

## Release notes flow

`android/<locale>/changelogs/default.txt` is the canonical user-facing note for
the next release. It is:

1. prepended to the GitHub draft-release body (`build.yaml`),
2. attached to every Play upload (`whatsNewDirectory`, assembled per locale),
3. mirrored manually into `ios/<locale>/release_notes.txt` (App Store "What's
   New" + TestFlight "What to Test", generated in `ios/ci_scripts/ci_post_clone.sh`).

Update both when preparing a release; keep it short, human, and user-facing —
commit-level detail already lands in the generated GitHub notes.

## Screenshots

Play images live in the repo and sync by checksum. App Store screenshots are
still managed in App Store Connect directly (`skip_screenshots: true`).

## Secrets (GitHub Actions)

- `SERVICE_ACCOUNT_JSON` — Play service account (also used for build uploads).
- `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_CONTENT` — App Store Connect API key
  (team key, App Manager role; `ASC_KEY_CONTENT` is the raw `.p8` contents).

## Running locally

```sh
bundle install
SUPPLY_JSON_KEY=path/to/service-account.json bundle exec fastlane android sync_metadata
ASC_KEY_ID=… ASC_ISSUER_ID=… ASC_KEY_CONTENT="$(cat AuthKey_….p8)" bundle exec fastlane ios sync_metadata
```
