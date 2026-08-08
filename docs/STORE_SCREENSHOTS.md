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
three images. Short caption on top, device frame below, brand background.

| # | Screen | Caption (EN) | Why here |
|---|--------|--------------|----------|
| 1 | Event with replies visible | **See who's coming — before you cook for twelve** | The differentiator, stated in one glance |
| 2 | Group calendar | **One calendar for your whole crew** | The category keyword, visualized |
| 3 | RSVP buttons on an event | **One tap to answer. No group-chat archaeology** | Shows how light the commitment is |
| 4 | Recurring event / default answers | **Weekly plans on autopilot — "I'm always in on Tuesdays"** | Unique feature no competitor shows |
| 5 | Groups list (home) | **Family, friends, team, book club — all of them** | Breadth, multiple-groups use case |

Caption translations should be *localized, not translated* — e.g. the German
"cook for twelve" hook works better as „Bevor du für zwölf kochst" but the
French should pivot to something idiomatic. Keep captions ≤ 6 words where
possible; verbs first.

## Automated raw captures (working today)

`test/store_screenshots/store_screenshots_test.dart` renders real screens with
staged demo data at exact store resolutions, per locale:

```sh
STORE_SCREENSHOTS=true flutter test --tags screenshots --update-goldens
# → test/store_screenshots/raw/<profile>/<locale>/<screen>.png
```

Profiles: `appstore-6.7` (1290×2796) and `play-phone` (2160×3840, matches the
current Play assets). Adding a screen = one line in the `screens` map, passing
the "dumb" screen widget from `lib/presentation/screens/` with fake props —
no Redux store or backend needed.

Current limitations (acceptable for drafts, fix before shipping):

1. **Fonts** — Roboto + MaterialIcons load from the Flutter SDK cache, so
   body text and icons are real. The Cabin/Sniglet brand fonts come from
   `google_fonts`, which cannot download inside tests, so the GRUP wordmark
   (and any emoji in demo data) render as tofu. Fix: bundle Cabin, Sniglet
   and NotoColorEmoji under `assets/fonts/` and add them to `_loadRealFonts`
   (google_fonts picks up bundled fonts at runtime too).
2. **Richer screens** — screens showing replies (`group_schedule_details`)
   need a staged `ScheduleInstanceSummary`; build fakes with the selectors'
   types in `selectors/schedules.dart`.
3. **Framing & captions** — raw captures still need device frame + caption +
   background. Do this deterministically with a small compositing script
   (ImageMagick or a Dart script using `package:image`) reading captions from
   a per-locale YAML, writing straight into
   `fastlane/metadata/android/<locale>/images/phoneScreenshots/`. Play then
   syncs from the repo automatically (`sync_image_upload`); for the App Store
   flip `skip_screenshots` in the Fastfile once frames are final.

## Store rules worth remembering

- Play phone screenshots: 2–8 images, each side 320–3840 px. Feature graphic
  (1024×500) is what shows in most promo placements — keep it caption-first too.
- App Store: one 6.7"/6.9" set covers modern iPhones; iPad screenshots only if
  the iPad experience is good (we currently ship 7"/10" tablet shots on Play).
- Don't put text in the bottom ~15% (store UI overlays it in some placements).
