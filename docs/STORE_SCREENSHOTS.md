# Store screenshots: generation & copy guide

## Positioning context

GRUP competes in the *shared calendar* space (TimeTree, Howbout, Cozi,
FamilyWall). Those apps sell "one calendar for everyone"; none of them lead
with **knowing who's actually coming**. GRUP's screenshots should therefore
tell one story: *plan together → everyone answers → you see who's in*.
RSVPs, recurring events and default answers are the differentiators — a plain
calendar grid screenshot is the one thing we should *not* lead with, because
TimeTree's is prettier and Howbout's is more social.

## Recommended sequence (both stores)

Captions carry ~80% of a screenshot's job; viewers rarely read past the first
three images (and the App Store shows only those in search). Short caption on
top, the screen below, brand background, no device frame.

| # | Screen | Caption (EN) | Why here |
|---|--------|--------------|----------|
| 1 | Event: headcount and who answered what | **See who's coming at a glance** | The differentiator, stated in one glance |
| 2 | A group's day, answer buttons on each event | **Every plan, one tap to answer** | Shows how light the commitment is |
| 3 | The usual-answer sheet | **Always in on Saturdays? Say it once** | Unique feature no competitor shows |
| 4 | Groups list (home) | **Family, friends, team: all in one place** | Breadth, multiple-groups use case |

The captions in every language live in `_demo` in the test, which is the source
of truth. Play forbids "best", "#1", "new", "sale" and calls to action, so keep
them descriptive.

Caption translations should be *localized, not translated* — e.g. the German
"cook for twelve" hook works better as „Bevor du für zwölf kochst" but the
French should pivot to something idiomatic. Keep captions ≤ 6 words where
possible; verbs first.

## Automated raw captures (working today)

`test/store_screenshots/store_screenshots_test.dart` renders real screens with
staged demo data at exact store resolutions, per locale and platform:

```sh
STORE_SCREENSHOTS=true flutter test --tags screenshots --update-goldens
# → test/store_screenshots/raw/<profile>/<locale>/<screen>.png  bare (gitignored)
# → fastlane/metadata/android/<locale>/images/{phone,sevenInch,tenInch}Screenshots/<n>_<screen>.png
# → fastlane/screenshots/<locale>/<device>_<n>_<screen>.png        captioned
```

240 images (6 profiles × 5 locales × 4 screens, bare and captioned) in about
a minute and a half. Review the captioned ones in the diff, commit, and merge:
`store-metadata.yaml` uploads them to both stores. The captioned set is the
store image: the caption on the brand
colour in the top 18% (Play allows 20%), then the screen, laid out at full
device size and scaled down, with rounded corners and no device frame (Play
discourages device imagery). The bare set is for other tools (e.g. ButterKit).
Demo names and captions are per language, in `_demo` in the test; the
translations are drafts to review. No simulators
or backend involved: screens are the "dumb" widgets from `lib/presentation/screens/`
with fake props, so adding one is one entry in the `screens` map.

| Profile | Pixels | Store slot |
|---|---|---|
| `ios-iphone-6.9` | 1320×2868 | iPhone 6.9" (largest; ASC scales it down) |
| `ios-iphone-6.3` | 1206×2622 | iPhone 6.3" (ASC may require it) |
| `ios-ipad-13` | 2064×2752 | iPad 13" (required: the app runs on iPad) |
| `android-phone` | 1440×2560 | Play phone (9:16, ≥1080 px for featuring) |
| `android-tablet-7` | 2048×1152 | Play 7" tablet (must be exactly 16:9) |
| `android-tablet-10` | 2560×1440 | Play 10" tablet (must be exactly 16:9) |

iOS profiles render with `TargetPlatform.iOS` (back chevrons, scroll physics), and
every profile sets the system insets (Dynamic Island, nav bar) so a frame never
covers the app bar. Fonts: Cabin/Sniglet from `assets/google_fonts/`, Roboto and
Material Icons from the Flutter SDK cache, and package fonts (Font Awesome reply
icons) from `FontManifest.json`. Shadows render for real, not as the test's black
outlines.

Known gaps:

1. **Member names aren't localized**: they're a deliberately mixed set.
2. **No colour emoji**: tests can't render them, so the demo data has none.
3. **No status bar** is drawn: the top inset is blank. That's fine under a
   caption or frame. Google wants any status bar clean (no carrier, full icons).
4. **Wide profiles compose the panes by hand** (`TwoPane` in `_screens`), as the
   app lays them out from 840dp: the harness renders screens, not routes.
5. **Store images are written by the test itself**, as RGB PNGs (both stores
   reject an alpha channel, and the engine only encodes RGBA); each one is
   checked to decode back to the same pixels. Renamed or removed screens leave
   their old files behind: delete them by hand, or the stores keep showing them.

## Store rules worth remembering

- **Play** ([preview assets](https://support.google.com/googleplay/android-developer/answer/9866151)):
  2–8 per device type; JPEG or 24-bit PNG without alpha; each side 320–3840 px,
  long side ≤ 2× short side. Featuring needs ≥ 4 at ≥ 1080 px. Taglines optional
  and ≤ 20% of the image; the first three should be mostly UI. No "best", "#1",
  "new", "sale", awards, prices or calls to action ("Download now"). Device
  imagery is discouraged. Alt text ≤ 140 chars per image. Tablets must be 16:9 or
  9:16 (1080–7680 px). Feature graphic 1024×500, centred, no plain white, black
  or dark grey background, no copy of the icon.
- **App Store** ([best practices](https://developer.apple.com/app-store/asset-best-practices/),
  [specs](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications)):
  up to 10 per size, no alpha; the first 3 show in search results. Lead with the
  strongest feature and sequence the images as a story. Captions are short
  phrases that add to the image instead of describing it, localized for every
  language. Keep the focal point centred and inside the template safe area. Use
  no other platforms' logos, prices or URLs, and nothing above a 4+ rating.
  iPhone Duo sizes become required in April 2027 (iOS 27.1 SDK): one more profile.
- Don't put text in the bottom ~15% (store UI overlays it in some placements).
