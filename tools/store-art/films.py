"""Store films, ray-traced in Blender:

- promo: the Play promo video (16:9, 1920×1080, ~24 s, upload to YouTube).
  A frameless screen (Google recommends no device imagery) playing the
  harness's Android footage, each scene's caption beside it, the answer
  bubble popping as replies come in, and the wordmark at the end.
- header: the App Store product page header video (21:9, 3840×1646, 8 s,
  muted, looping): the device trio with its callouts floating, built to
  loop without a seam.

    blender -b -P tools/store-art/films.py -- promo|header [--lang en] [--out DIR] [--frames A B]

Needs test/store_screenshots/raw/ (and, for promo, build/store-art/footage/,
from STORE_FOOTAGE=true flutter test --tags screenshots --plain-name previews).
Frames go to DIR/<film>-<lang>/ as PNGs, then ffmpeg makes the .mp4.
"""

import math
import subprocess
import sys
from pathlib import Path

import bpy

sys.path.insert(0, str(Path(__file__).parent))
import art  # noqa: E402
import stills  # noqa: E402  (layouts and poses; its CLI does nothing without --only)

argv = sys.argv[sys.argv.index("--") + 1 :]
FILM = argv[0]
LANG = stills.opt("--lang")[0] if stills.opt("--lang") else "en"
OUT = Path(stills.opt("--out")[0]) if stills.opt("--out") else art.ROOT / "build/store-art"
FRAMES = [int(v) for v in stills.opt("--frames")]
FPS = 30
TITLE = (art.ROOT / f"fastlane/metadata/android/{stills.ANDROID[LANG]}/title.txt").read_text().split(":", 1)[1].strip()


def fader(obj):
    """Swaps [obj]'s emission materials for ones with a keyframable
    opacity; returns the mix nodes (0 hidden, 1 shown)."""
    mixes = []
    for slot in obj.material_slots:
        mat = slot.material.copy()
        nodes, links = mat.node_tree.nodes, mat.node_tree.links
        out = nodes["Material Output"]
        shader = out.inputs[0].links[0].from_node
        mix = nodes.new("ShaderNodeMixShader")
        links.new(nodes.new("ShaderNodeBsdfTransparent").outputs[0], mix.inputs[1])
        links.new(shader.outputs[0], mix.inputs[2])
        links.new(mix.outputs[0], out.inputs[0])
        slot.material = mat
        mixes.append(mix)
    return mixes


def keys(target, path, frames_values, index=-1):
    for frame, value in frames_values:
        setattr(target, path, value) if index < 0 else getattr(target, path).__setitem__(index, value)
        target.keyframe_insert(path, frame=frame, index=index)


def fade(mixes, frames_values):
    for mix in mixes:
        for frame, value in frames_values:
            mix.inputs[0].default_value = value
            mix.inputs[0].keyframe_insert("default_value", frame=frame)


def setup(px, frames):
    canvas = art.Canvas(*px)
    scene = art.reset(canvas, samples=48)
    scene.cycles.adaptive_threshold = 0.02
    scene.cycles.denoising_use_gpu = True  # mostly emissive scenes: few samples, denoised
    scene.render.fps = FPS
    scene.frame_start, scene.frame_end = 1, frames
    scene.render.use_persistent_data = True  # the scene barely changes between frames
    return canvas, scene


def promo():
    # Footage scenes as the harness joins them: 6, 5, 5.5 and 4 s with 0.4 s
    # dissolves. The film opens 0.5 s before the footage and ends on the logo.
    lead, scenes, dissolve = 0.5, [6, 5, 5.5, 4], 0.4
    starts = [sum(scenes[:i]) - dissolve * i for i in range(len(scenes))]
    footage_end = lead + starts[-1] + scenes[-1]
    total = footage_end + 3.5
    f = lambda t: round(t * FPS) + 1  # noqa: E731  (seconds -> frame)
    canvas, scene = setup((1920, 1080), f(total))
    art.studio(canvas, glow=(0.62, 0.5))
    screen = art.Footage(OUT / f"footage/{LANG}/android.mp4", top=60, start=f(lead))
    root, screen_h = art.device(screen, 0.86 * canvas.h * screen.size[0] / screen.size[1], framed=False)
    # Gently turns and drifts towards the viewer while the scenes play.
    keys(root, "location", [(1, canvas.at(0.68, 0.53, 2.2)), (f(footage_end), canvas.at(0.66, 0.52, 3.4))])
    keys(root, "rotation_euler", [(1, (math.radians(6), math.radians(-14), math.radians(3))), (f(footage_end), (math.radians(4), math.radians(8), math.radians(-2)))])

    # The bubble over Chloé's yes button pops as she answers (1.6 s in).
    sw = root["screen_w"]
    bubble = art.bubble(root, (0.33 * sw, -0.12 * screen_h), 0.36 * sw, 0.09 * sw, rotation=(-14, 18, -10))
    pop = lead + 1.6
    keys(bubble, "scale", [(1, (0.001,) * 3), (f(pop - 0.05), (0.001,) * 3), (f(pop + 0.18), (1.12,) * 3), (f(pop + 0.32), (1,) * 3), (f(lead + starts[1] - 0.2), (1,) * 3), (f(lead + starts[1] + 0.1), (0.001,) * 3)])

    # Each scene's caption on the left, fading with the scene.
    width = canvas.w * 0.34
    size = art.headline_size(stills.CAPTIONS[LANG], width, canvas.w * 0.05)
    for i, caption in enumerate(stills.CAPTIONS[LANG]):
        text = art.headline(canvas, caption, 0.07, 0.4, width, size, align="LEFT")
        t0, t1 = lead + starts[i] + 0.3, lead + starts[i] + scenes[i] - 0.3
        fade(fader(text), [(1, 0), (f(t0), 0), (f(t0 + 0.4), 1), (f(t1 - 0.3), 1), (f(t1), 0)])

    # Outro: the screen sinks away, the wordmark and the listing's subtitle.
    keys(root, "location", [(f(footage_end + 0.6), canvas.at(0.66, 1.6, -1.0))])
    mark = art.headline(canvas, "GRUP", 0.5, 0.36, canvas.w, canvas.w * 0.11)
    mark.data.font = bpy.data.fonts.load(str(art.FONTS / "Sniglet-Regular.ttf"))
    sub = art.headline(canvas, TITLE, 0.5, 0.58, canvas.w * 0.7, canvas.w * 0.032, colour="#DCE4F2", wrap=False)
    for obj in (mark, sub):
        fade(fader(obj), [(1, 0), (f(footage_end + 0.4), 0), (f(footage_end + 1.0), 1)])
    return scene, f"promo-{LANG}"


def header():
    """Seamless loop: everything moves on sines of the loop's period."""
    frames = 8 * FPS
    canvas, scene = setup((3840, 1646), frames)
    layout = stills.HEADER
    art.studio(canvas, glow=layout["glow"])
    period = f"2 * pi * frame / {frames}"
    objects = []
    for name, u, v, fit, rot in [("event", *layout["device"], stills.POSES["event"]["rot"])] + layout["extra"]:
        screen = art.Screen("ios-iphone-6.9", LANG, name)
        sw = -fit * canvas.h * screen.size[0] / screen.size[1]
        root, screen_h = art.device(screen, sw)
        root.location = canvas.at(u, v, 3.0 if name == "event" else 1.0)
        root.rotation_euler = [math.radians(a) for a in rot]
        objects.append(root)
        if name == "event":
            pose = stills.POSES["event"]
            for anchor, lift, scale, (dx, dy), crot in pose["callouts"]:
                art.callout(root, screen, anchor, stills.CROPS, lift * sw, scale, (dx * sw, dy * sw), crot, radius=0.04 * sw)
            anchor, lift, r = pose["bubble"]
            left, top, w, h = screen.anchors[anchor]
            k = sw / screen.size[0]
            art.bubble(root, ((left + w / 2) * k - sw / 2, screen_h / 2 - (top + h / 2) * k), lift * sw, r * sw, rotation=(-14, 18, -10))
    # Bob each device and its callouts out of phase; sway the camera.
    for i, obj in enumerate([o for o in bpy.data.objects if o.name.startswith(("device", "callout", "bubble"))]):
        base = obj.location.z
        d = obj.driver_add("location", 2).driver
        d.expression = f"{base} + {0.08 if obj.parent else 0.15} * sin({period} + {i * 1.3})"
        spin = obj.driver_add("rotation_euler", 2).driver
        spin.expression = f"{obj.rotation_euler.z} + 0.02 * sin({period} + {i * 0.7})"
    cam = scene.camera
    cx = cam.location.x
    cam.driver_add("location", 0).driver.expression = f"{cx} + 0.25 * sin({period})"
    return scene, f"header-{LANG}"


scene, name = {"promo": promo, "header": header}[FILM]()
frames_dir = OUT / ".frames" / name
frames_dir.mkdir(parents=True, exist_ok=True)
first, last = (FRAMES + [scene.frame_start, scene.frame_end])[:2] if FRAMES else (scene.frame_start, scene.frame_end)
for frame in range(first, last + 1):
    path = frames_dir / f"{frame:04d}.png"
    if path.exists():  # resumable: a stopped render picks up where it was
        continue
    scene.frame_set(frame)
    art.render(path)
if not FRAMES:
    out = OUT / ("play-promo" if FILM == "promo" else "app-store") / f"{LANG}-{FILM}.mp4"
    out.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-framerate", str(FPS), "-i", str(frames_dir / "%04d.png"), "-c:v", "libx264", "-preset", "slow", "-crf", "14", "-pix_fmt", "yuv420p", "-movflags", "+faststart", str(out)], check=True)
    print(f"wrote {out}")
