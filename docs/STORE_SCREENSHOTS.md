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
three images (and the App Store shows only those in search). One headline per
image on top, the screen below, brand-blue studio, the key widgets lifted out
of the screen towards the viewer.

| # | Screen | Caption (EN) | Why here |
|---|--------|--------------|----------|
| 1 | Event: headcount and who answered what | **See *who's coming* at a glance** | The differentiator, stated in one glance |
| 2 | A group's day, answer buttons on each event | **Every plan, *one tap* to answer** | Shows how light the commitment is |
| 3 | The usual-answer sheet | **Always in on Saturdays? *Say it once*** | Unique feature no competitor shows |
| 4 | Groups list (home) | **Family, friends, team: *all in one place*** | Breadth, multiple-groups use case |

The captions in every language live in `_demo` in the test, which is the source
of truth; `*stars*` mark the accent words (Cabin Bold, light green; the rest
Cabin Medium). Play forbids "best", "#1", "new", "sale" and calls to action, so
keep them descriptive.

Caption translations should be *localized, not translated* — e.g. the German
"cook for twelve" hook works better as „Bevor du für zwölf kochst" but the
French should pivot to something idiomatic. Keep captions ≤ 6 words where
possible; verbs first.

## Pipeline

Two steps, no simulators or backend: the Flutter harness renders the real
screens (the "dumb" widgets from `lib/presentation/screens/` with demo props),
then Blender (Cycles, ray-traced on the GPU) stages them.

```sh
# 1. Captures: bare screens, where their key widgets sit, and the captions
STORE_SCREENSHOTS=true flutter test --tags screenshots --update-goldens
# → test/store_screenshots/raw/<profile>/<lang>/<screen>.{png,json}, raw/captions.json (gitignored)

# 2. Stills (~95 renders, ~40 min on an M4 Pro): writes fastlane/ and build/store-art/
blender -b -P tools/store-art/stills.py -- [--only JOB ...] [--lang en ...] [--screen event ...] [--out DIR]

# App Store previews (in-app footage, ~4 min) and bare Android footage for the promo
STORE_PREVIEWS=true flutter test --tags screenshots --plain-name previews
STORE_FOOTAGE=true flutter test --tags screenshots --plain-name previews

# 3. Films (frames are resumable): Play promo and App Store header loop
blender -b -P tools/store-art/films.py -- promo  [--lang en]
blender -b -P tools/store-art/films.py -- header [--lang en]
```

| Output | Size | Where | Uploaded by |
|---|---|---|---|
| App Store screenshots, iPhone 6.9″ / 6.3″ (scaled) | 1320×2868 / 1206×2622 | `fastlane/screenshots/<locale>/iphone-*` | `store-metadata.yaml` |
| App Store screenshots, iPad 13″ | 2064×2752 | `fastlane/screenshots/<locale>/ipad-13_*` | `store-metadata.yaml` |
| Play phone / 10″ / 7″ (scaled) screenshots | 1440×2560 / 2560×1440 / 2048×1152 | `fastlane/metadata/android/<locale>/images/` | `store-metadata.yaml` |
| Play feature graphic | 1024×500 (rendered 2×) | same, `featureGraphic.png` | `store-metadata.yaml` |
| App Store creative assets: header, search | 3840×1646, 3840×2560 | `build/store-art/app-store/<lang>/` | you, App Store Connect |
| App Store app previews (iPhone, iPad) | 886×1920, 1200×1600, 19.3 s | `build/store-art/app-previews/<locale>/` | you, App Store Connect (fastlane can't) |
| App Store header video (looping) | 3840×1646, 8 s | `build/store-art/app-store/<lang>-header.mp4` | you, App Store Connect |
| Play promo video | 1920×1080, ~23 s | `build/store-art/play-promo/<lang>-promo.mp4` | you, YouTube (ads off), then its URL in `fastlane/metadata/android/<locale>/video.txt` |

Art direction (`tools/store-art/art.py`):

- **App Store: a generic device.** Uniform bezel, no buttons, camera,
  notch or island: Apple forbids 3D renders of its products and any generic
  device showing their details. iOS captures get a clean 9:41 status bar
  (`IosStatusBar` in `test/store_screenshots/staging.dart`), as Apple asks.
- **Play: frameless.** Google "highly recommends" no device imagery in
  screenshots and the feature graphic; the screen floats as a thick card,
  without its blank status inset.
- **Colour is calibrated**: the Standard view transform, a screen that is 72%
  emission and 28% lit diffuse (so callouts cast real shadows on it), lights
  tuned so a lit screen white renders as the capture's (`#F9F9FF` → `F8FAFF`).
  Check by sampling a pixel after changing lights or materials.
- **Callouts and the answer bubble** float over the anchors the harness exports
  (`_anchors` in the test): rename a widget and its anchor goes with it.
- **Avatars** are drawn in code (`drawAvatars` in `staging.dart`) and served to
  the screens' `NetworkImage`s from the image cache: no photos to license.
- **App previews** are the real app being played (taps on answer buttons
  update the screens), every frame piped to ffmpeg, with caption cards and touch
  hotspots as overlays and dissolves between scenes: Apple allows only in-app
  footage. H.264 High 4.0 at a constant 11 Mbps with a silent stereo track.

Known gaps:

1. **Member names aren't localized**: they're a deliberately mixed set.
2. **No colour emoji**: tests can't render them, so the demo data has none.
3. **Wide profiles compose the panes by hand** (`TwoPane` in `_screens`), as the
   app lays them out from 840dp: the harness renders screens, not routes.
4. **Renamed or removed screens leave their old files behind** in fastlane/:
   delete them by hand, or the stores keep showing them.
5. **Films are English only** by default (`--lang` renders others; each takes
   about an hour of GPU time).

## Store rules worth remembering

Checked on the primary pages on 2026-11-03.

- **Play** ([preview assets](https://support.google.com/googleplay/android-developer/answer/9866151)):
  2–8 per device type; JPEG or 24-bit PNG without alpha; each side 320–3840 px,
  long side ≤ 2× short side. Recommendation surfaces *require* ≥ 4 screenshots
  at ≥ 1080 px. Taglines optional and ≤ 20% of the image; the first three should
  be mostly UI. No "best", "#1", "new", "sale", awards, prices or calls to action
  ("Download now"). Device imagery is "highly recommended" against, in screenshots
  and the feature graphic (it's a rule only on Wear OS). Alt text ≤ 140 chars per
  image. Tablets must be 16:9 or 9:16 (1080–7680 px). Feature graphic 1024×500,
  focal point centred and key elements out of the cutoff zones, no plain white,
  black or dark grey background, no copy of the icon; the promo video's play
  button sits on top of it.
- **Play promo video**: one public or unlisted YouTube URL, ads off, not
  age-restricted, embeddable; it may autoplay muted for 30 s, so show the real
  app within 10 s and keep ≥ 80% real UI. Portrait or landscape, no black bars.
- **App Store screenshots** ([best practices](https://developer.apple.com/app-store/asset-best-practices/),
  [specs](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications),
  [2.3.3](https://developer.apple.com/help/app-review/guideline-reference/2-3-3-screenshots)):
  up to 10 per size, no alpha; the first 3 show in search results. More than
  half must show the app in use; overlays mustn't crowd it out. Lead with the
  strongest feature and sequence the images as a story. Captions are short
  phrases that add to the image, localized for every language. No other
  platforms' logos, prices, URLs or Apple badges, and nothing above a 4+ rating.
  iPhone Duo sizes become required in April 2027 (iOS 27.1 SDK): one more profile.
- **Apple devices** ([marketing guidelines](https://developer.apple.com/app-store/marketing/guidelines/)):
  "rendering in 3D or creating any simulation of an Apple product" isn't
  permitted, nor tilting, shadows or reflections on Apple's bezels. Generic
  devices are fine without Apple's details (Home button, sensor housing, switch,
  volume controls). Status bars show full signal, Wi-Fi and battery.
- **App previews** ([app previews](https://developer.apple.com/app-store/app-previews/),
  [specs](https://developer.apple.com/help/app-store-connect/reference/app-information/app-preview-specifications)):
  up to 3 per size and language, 15–30 s, ≤ 30 fps, H.264 High 4.0 at 10–12 Mbps
  (or ProRes 422 HQ), stereo AAC. 886×1920 for every iPhone, 1200×1600 for iPad
  13″. Only footage of the app: no device, people or hands; captions, touch
  hotspots and dissolves are fine. They autoplay muted before the screenshots;
  the poster frame defaults to 5 s.
- **Creative assets** (iOS 27, [specs](https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications)):
  product page header 21:9 3840×1646, search 3:2 (1920×1280–3840×2560), image or
  looping muted 5–30 s video at 30/60 fps. They may go beyond the app in use but
  must relate to it; one clear idea, focal point centred.
- **Featuring** is editorial on both stores. Apple takes nominations in App
  Store Connect (Featuring → Nominations), at least 3 weeks ahead.
- Don't put text in the bottom ~15% (store UI overlays it in some placements).
