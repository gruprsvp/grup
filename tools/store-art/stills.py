"""Store stills, ray-traced in Blender from the harness captures:

- App Store screenshots: iPhone 6.9" (and 6.3", scaled) and iPad 13", in a
  generic device (Apple forbids 3D renders of its own).
- Play screenshots (phone, 10" and 7" tablets) and the feature graphic:
  frameless, as Google recommends no device imagery.
- App Store creative assets (product page header 21:9, search 3:2): not
  uploaded by fastlane, written to build/store-art/ for App Store Connect.

    blender -b -P tools/store-art/stills.py -- [--out DIR] [--lang en ...] [--only JOB ...] [--screen NAME ...]

Reads test/store_screenshots/raw/ (run the harness first). Writes the store
files into fastlane/, or everything under --out for look tests.
"""

import json
import math
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
import art  # noqa: E402

argv = sys.argv[sys.argv.index("--") + 1 :] if "--" in sys.argv else []


def opt(name):
    if name not in argv:
        return []
    i, vals = argv.index(name) + 1, []
    while i < len(argv) and not argv[i].startswith("--"):
        vals.append(argv[i])
        i += 1
    return vals


OUT = Path(opt("--out")[0]) if opt("--out") else None
LANGS = opt("--lang") or ["en", "de", "es", "fr", "it"]
ONLY = set(opt("--only"))
PICK = set(opt("--screen"))
CAPTIONS = json.loads((art.RAW / "captions.json").read_text())
SCREENS = ["event", "group", "usual", "home"]
ANDROID = {"de": "de-DE", "en": "en-GB", "es": "es-ES", "fr": "fr-FR", "it": "it-IT"}
IOS = {"de": "de-DE", "en": "en-GB", "es": "es-ES", "fr": "fr-FR", "it": "it"}
CROPS = art.RAW / ".crops"

# Per screen: the device's tilt (degrees), the widgets that float out of it
# (anchor, lift, scale, offset, rotation; lift and offset as fractions of the
# screen width) and the 3D answer bubble over a yes button (anchor, lift, radius).
POSES = {
    "event": dict(rot=(5, -8, 2), bubble=("member_yes", 0.36, 0.1), callouts=[("headcount", 0.16, 1.06, (-0.02, 0.0), (0, 0, -2)), ("member", 0.26, 1.08, (0.03, 0.0), (2, -2, 2.5))]),
    "group": dict(rot=(5, 8, -2), v=0.8, scale=1.12, bubble=("event2_yes", 0.4, 0.1), callouts=[("event", 0.16, 1.06, (0.02, 0.0), (0, 0, 2)), ("event2", 0.26, 1.08, (-0.02, 0.0), (-2, 2, -2))]),
    "usual": dict(rot=(5, -8, 2), callouts=[("sheet", 0.22, 1.04, (0.0, 0.03), (0, 0, -1.5))]),
    "home": dict(rot=(5, 8, -2), callouts=[("group", 0.26, 1.12, (-0.04, 0.0), (0, 0, 2))]),
}

# Wide canvases: the phone pose's callouts don't suit a two-pane tablet
# screen; these lift the panes' key rows instead, with a gentler tilt.
WIDE = {
    "event": dict(rot=(4, -6, 1), bubble=("member_yes", 0.2, 0.05), callouts=[("headcount", 0.08, 1.05, (-0.01, 0.0), (0, 0, -1.5)), ("member", 0.14, 1.06, (0.015, 0.0), (1, -1, 1.5))]),
    "group": dict(rot=(4, 6, -1), bubble=("event2_yes", 0.2, 0.05), callouts=[("event2", 0.12, 1.05, (0.0, 0.0), (0, 0, -1.5))]),
    # The sheet is at the bottom of the screen: show the device higher.
    "usual": dict(rot=(4, -6, 1), v=0.6, scale=0.84, callouts=[("sheet", 0.12, 1.03, (0.0, 0.01), (0, 0, -1))]),
    "home": dict(rot=(4, 6, -1), callouts=[("group", 0.14, 1.08, (-0.02, 0.0), (0, 0, 1.5))]),
}


def compose(px, profile, lang, name, caption, out, framed, layout, pose):
    """One image of [px]: [caption] where [layout] says, the [profile]
    capture of [name] in a device (or frameless), posed as [pose]."""
    canvas = art.Canvas(*px)
    art.reset(canvas)  # before loading images: it frees them
    CROPS.mkdir(parents=True, exist_ok=True)
    screen = art.Screen(profile, lang, name, trim_top=not framed, crops=CROPS)
    iw, ih = screen.size
    art.studio(canvas, glow=layout["glow"])
    if caption and (h := layout.get("headline")):
        u, v, width, size, align = h
        width *= canvas.w
        size = art.headline_size(CAPTIONS[lang], width, size * canvas.w)
        art.headline(canvas, caption, u, v, width, size, align=align)
    u, v, fit = layout["device"]
    # fit: the screen's width as a canvas-width fraction, or its height as a
    # canvas-height fraction (negative), whichever the layout pins.
    screen_w = (fit * canvas.w if fit > 0 else -fit * canvas.h * iw / ih) * pose.get("scale", 1.0)
    kind = "phone" if ih > iw * 1.6 else "tablet"
    root, screen_h = art.device(screen, screen_w, kind=kind, framed=framed)
    root.location = canvas.at(u, pose.get("v", v) if layout.get("pose_v") else v, 3.0)
    root.rotation_euler = [math.radians(a) for a in pose["rot"]]
    k = screen_w / iw
    for anchor, lift, scale, (dx, dy), rot in pose["callouts"]:
        if anchor in screen.anchors:
            art.callout(root, screen, anchor, CROPS, lift * screen_w, scale, (dx * screen_w, dy * screen_w), rot, radius=0.04 * min(screen_w, screen_h))
    if (spec := pose.get("bubble")) and spec[0] in screen.anchors:
        # Over that yes button, as if just tapped.
        anchor, lift, r = spec
        left, top, w, h = screen.anchors[anchor]
        at = ((left + w / 2) * k - screen_w / 2, screen_h / 2 - (top + h / 2) * k)
        art.bubble(root, at, lift * screen_w, r * screen_w, rotation=(-14, 18, -10))
    for other, eu, ev, efit, erot in layout.get("extra", []):
        side = art.Screen(profile, lang, other, trim_top=not framed, crops=CROPS)
        sw = efit * canvas.w if efit > 0 else -efit * canvas.h * side.size[0] / side.size[1]
        extra, _ = art.device(side, sw, kind=kind, framed=framed)
        extra.location = canvas.at(eu, ev, 1.0)
        extra.rotation_euler = [math.radians(a) for a in erot]
    art.render(out)
    print(f"wrote {out}")


PORTRAIT = dict(glow=(0.5, 0.55), headline=(0.5, 0.05, 0.86, 0.12, "CENTER"), device=(0.5, 0.63, 0.74), pose_v=True)
IPAD = dict(PORTRAIT, headline=(0.5, 0.045, 0.8, 0.085, "CENTER"), device=(0.5, 0.69, 0.74))
TABLET = dict(glow=(0.66, 0.5), headline=(0.05, 0.38, 0.3, 0.06, "LEFT"), device=(0.67, 0.53, 0.56))
SEARCH = dict(glow=(0.68, 0.5), headline=(0.07, 0.36, 0.42, 0.075, "LEFT"), device=(0.72, 0.56, -0.95))
# Product page header: no text (one clear idea), the event phone in the
# safe centre between the group day and the home screen.
HEADER = dict(glow=(0.5, 0.5), device=(0.5, 0.56, -0.95), extra=[("group", 0.25, 0.62, -0.8, (6, 14, 6)), ("home", 0.75, 0.62, -0.8, (6, -14, -6))])
FEATURE = dict(glow=(0.62, 0.5), headline=(0.07, 0.33, 0.36, 0.07, "LEFT"), device=(0.68, 0.6, -1.1))

def build(rel):
    return (OUT or art.ROOT / "build/store-art") / rel


def fastlane(rel):
    return OUT / "fastlane" / rel if OUT else art.ROOT / "fastlane" / rel


def scaled(src, dst, size):
    """[src] resized to [size] as an RGB PNG (ASC/Play scale-down sizes)."""
    dst.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", str(src), "-vf", f"scale={size[0]}:{size[1]}:flags=lanczos", "-pix_fmt", "rgb24", str(dst)], check=True)
    print(f"wrote {dst}")


def screens():
    return [(n, s) for n, s in enumerate(SCREENS, 1) if not PICK or s in PICK]


def ios_iphone(lang):
    for n, s in screens():
        big = fastlane(f"screenshots/{IOS[lang]}/iphone-6.9_{n}_{s}.png")
        compose((1320, 2868), "ios-iphone-6.9", lang, s, CAPTIONS[lang][n - 1], big, True, PORTRAIT, POSES[s])
        scaled(big, fastlane(f"screenshots/{IOS[lang]}/iphone-6.3_{n}_{s}.png"), (1206, 2622))


def ios_ipad(lang):
    for n, s in screens():
        compose((2064, 2752), "ios-ipad-13", lang, s, CAPTIONS[lang][n - 1], fastlane(f"screenshots/{IOS[lang]}/ipad-13_{n}_{s}.png"), True, IPAD, WIDE[s])


def play_phone(lang):
    for n, s in screens():
        compose((1440, 2560), "android-phone", lang, s, CAPTIONS[lang][n - 1], fastlane(f"metadata/android/{ANDROID[lang]}/images/phoneScreenshots/{n}_{s}.png"), False, PORTRAIT, POSES[s])


def play_tablet(lang):
    images = f"metadata/android/{ANDROID[lang]}/images"
    for n, s in screens():
        big = fastlane(f"{images}/tenInchScreenshots/{n}_{s}.png")
        compose((2560, 1440), "android-tablet-10", lang, s, CAPTIONS[lang][n - 1], big, False, TABLET, WIDE[s])
        scaled(big, fastlane(f"{images}/sevenInchScreenshots/{n}_{s}.png"), (2048, 1152))


def feature_graphic(lang):
    # Rendered at 2x and scaled down: small text stays crisp.
    big = build(f"feature-graphic/{lang}@2x.png")
    compose((2048, 1000), "android-phone", lang, "event", CAPTIONS[lang][0], big, False, FEATURE, POSES["event"])
    scaled(big, fastlane(f"metadata/android/{ANDROID[lang]}/images/featureGraphic.png"), (1024, 500))


def ios_creative(lang):
    compose((3840, 1646), "ios-iphone-6.9", lang, "event", None, build(f"app-store/{lang}/header-21x9.png"), True, HEADER, POSES["event"])
    compose((3840, 2560), "ios-iphone-6.9", lang, "event", CAPTIONS[lang][0], build(f"app-store/{lang}/search-3x2.png"), True, SEARCH, POSES["event"])


JOBS = {
    "ios-iphone": ios_iphone,
    "ios-ipad": ios_ipad,
    "play-phone": play_phone,
    "play-tablet": play_tablet,
    "feature-graphic": feature_graphic,
    "ios-creative": ios_creative,
}

if __name__ == "__main__":  # films.py imports the layouts
    for job, run in JOBS.items():
        if ONLY and job not in ONLY:
            continue
        for lang in LANGS:
            run(lang)
