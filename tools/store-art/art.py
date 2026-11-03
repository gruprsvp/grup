"""Building blocks for the store art: a lit studio, a generic device, UI
callouts floating out of its screen, and headlines. Used by stills.py.

Units: the canvas is CANVAS_W units wide at z=0; heights follow the image
aspect. (u, v) are canvas fractions from the top-left corner.
"""

import json
import math
import re
from pathlib import Path

import bmesh
import bpy
import numpy as np
from mathutils import Euler, Vector

ROOT = Path(__file__).resolve().parents[2]
RAW = ROOT / "test/store_screenshots/raw"
FONTS = ROOT / "assets/google_fonts"
HDRI = Path(bpy.utils.system_resource("DATAFILES")) / "studiolights/world/studio.exr"
CANVAS_W = 10.0
LENS = 85.0
SENSOR = 36.0


def srgb(hex_colour, a=1.0):
    c = [int(hex_colour[i : i + 2], 16) / 255 for i in (1, 3, 5)]
    return [(v / 12.92 if v <= 0.04045 else ((v + 0.055) / 1.055) ** 2.4) for v in c] + [a]


BRAND = "#34558B"
ACCENT = "#9BE89A"  # tertiary green, lifted for contrast on the blue


class Canvas:
    def __init__(self, width, height):
        self.px = (width, height)
        self.w = CANVAS_W
        self.h = CANVAS_W * height / width

    def at(self, u, v, z=0.0):
        """World point for canvas fractions (u, v) on the z=0 plane, then raised
        to z along the camera ray so it stays at (u, v) on screen."""
        x, y = (u - 0.5) * self.w, (0.5 - v) * self.h
        k = (self.cam_z - z) / self.cam_z
        return Vector((x * k, y * k, z))


def reset(canvas, samples=384, view="Standard"):
    bpy.ops.wm.read_factory_settings(use_empty=True)
    scene = bpy.context.scene
    scene.render.engine = "CYCLES"
    prefs = bpy.context.preferences.addons["cycles"].preferences
    prefs.compute_device_type = "METAL"
    prefs.refresh_devices()
    for d in prefs.devices:
        d.use = d.type == "METAL"
    scene.cycles.device = "GPU"
    scene.cycles.samples = samples
    scene.cycles.use_denoising = True
    scene.cycles.denoising_input_passes = "RGB_ALBEDO_NORMAL"  # keeps UI text edges
    scene.render.resolution_x, scene.render.resolution_y = canvas.px
    scene.render.resolution_percentage = 100
    scene.render.film_transparent = False
    scene.render.image_settings.file_format = "PNG"
    scene.render.image_settings.color_mode = "RGB"  # both stores reject alpha
    scene.view_settings.view_transform = view
    cam = bpy.data.cameras.new("cam")
    cam.lens, cam.sensor_fit = LENS, "HORIZONTAL"
    cam.sensor_width = cam.sensor_height = SENSOR  # VERTICAL fit reads the height
    if canvas.px[1] > canvas.px[0]:
        cam.sensor_fit = "VERTICAL"
        canvas.cam_z = canvas.h * LENS / SENSOR
    else:
        canvas.cam_z = canvas.w * LENS / SENSOR
    obj = bpy.data.objects.new("cam", cam)
    obj.location = (0, 0, canvas.cam_z)
    scene.collection.objects.link(obj)
    scene.camera = obj
    return scene


def _mat(name):
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    return mat, mat.node_tree.nodes, mat.node_tree.links


def principled(name, base, roughness, metallic=0.0, coat=0.0):
    mat, nodes, _ = _mat(name)
    b = nodes["Principled BSDF"]
    b.inputs["Base Color"].default_value = base
    b.inputs["Roughness"].default_value = roughness
    b.inputs["Metallic"].default_value = metallic
    b.inputs["Coat Weight"].default_value = coat
    return mat


def emission(name, colour):
    mat, nodes, links = _mat(name)
    nodes.clear()
    em = nodes.new("ShaderNodeEmission")
    em.inputs["Color"].default_value = colour
    links.new(em.outputs[0], nodes.new("ShaderNodeOutputMaterial").inputs[0])
    return mat


SCREEN_GLOW = 0.72 # the rest of a lit screen's brightness comes from the lights
SCREEN_DIFFUSE = 0.28 # albedo share: enough to catch the callouts' shadows


def screen_material(name, image, glass=True, crop_top=0.0, movie=None):
    """UI as mostly-emission, plus some diffuse so callouts cast shadows on
    it, under glossy cover glass. [crop_top] hides that fraction of the
    image's top; [movie] = (first scene frame, frame count) plays a video."""
    mat, nodes, links = _mat(name)
    b = nodes["Principled BSDF"]
    b.inputs["Roughness"].default_value = 0.04 if glass else 0.5
    b.inputs["Specular IOR Level"].default_value = 0.3 if glass else 0.1
    b.inputs["Emission Strength"].default_value = SCREEN_GLOW
    tex = nodes.new("ShaderNodeTexImage")
    tex.image, tex.interpolation, tex.extension = image, "Cubic", "EXTEND"
    if movie:
        tex.image_user.frame_start, tex.image_user.frame_duration = movie
        tex.image_user.use_auto_refresh = True
    coords = nodes.new("ShaderNodeTexCoord")
    squash = nodes.new("ShaderNodeMapping")
    squash.inputs["Scale"].default_value = (1, 1 - crop_top, 1)
    links.new(coords.outputs["Generated"], squash.inputs["Vector"])
    links.new(squash.outputs[0], tex.inputs["Vector"])
    links.new(tex.outputs["Color"], b.inputs["Emission Color"])
    dim = nodes.new("ShaderNodeMix")
    dim.data_type = "RGBA"
    dim.blend_type = "MULTIPLY"
    dim.inputs["Factor"].default_value = 1.0
    dim.inputs["B"].default_value = (SCREEN_DIFFUSE,) * 3 + (1,)
    links.new(tex.outputs["Color"], dim.inputs["A"])
    links.new(dim.outputs["Result"], b.inputs["Base Color"])
    return mat


def rounded_rect(name, w, h, r, seg=20):
    pts = []
    corners = ((w / 2 - r, h / 2 - r, 0), (-w / 2 + r, h / 2 - r, 90), (-w / 2 + r, -h / 2 + r, 180), (w / 2 - r, -h / 2 + r, 270))
    for cx, cy, a0 in corners:
        for i in range(seg + 1):
            a = math.radians(a0 + 90 * i / seg)
            pts.append((cx + r * math.cos(a), cy + r * math.sin(a), 0))
    bm = bmesh.new()
    bm.faces.new([bm.verts.new(p) for p in pts])
    mesh = bpy.data.meshes.new(name)
    bm.to_mesh(mesh)
    bm.free()
    obj = bpy.data.objects.new(name, mesh)
    bpy.context.scene.collection.objects.link(obj)
    return obj


def slab(name, w, h, r, depth, materials, bevel=0.05):
    """A rounded slab whose top face is at z=0: material 0 on top, 1 on the
    sides and back."""
    obj = rounded_rect(name, w, h, r, 28)
    sol = obj.modifiers.new("solid", "SOLIDIFY")
    sol.thickness, sol.offset = depth, -1
    sol.material_offset = sol.material_offset_rim = 1
    bev = obj.modifiers.new("bevel", "BEVEL")
    bev.width, bev.segments, bev.limit_method = bevel, 6, "ANGLE"
    bev.harden_normals = True
    for p in obj.data.polygons:
        p.use_smooth = True
    for m in materials:
        obj.data.materials.append(m)
    return obj


def load(path):
    if not path.exists():
        raise SystemExit(f"missing {path}: run the store-screenshot harness first")
    return bpy.data.images.load(str(path))


def crop(image, rect, out_dir, name):
    """rect = [left, top, width, height] in image pixels, saved as its own
    file: Cycles renders file-backed images reliably, generated ones not."""
    w, h = image.size
    left, top, cw, ch = (int(round(v)) for v in rect)
    px = np.empty(w * h * 4, dtype=np.float32)
    image.pixels.foreach_get(px)
    px = px.reshape(h, w, 4)[h - top - ch : h - top, left : left + cw]
    out = bpy.data.images.new(name, cw, ch)
    out.pixels.foreach_set(px.ravel())
    out.filepath_raw = str(out_dir / f"{name}.png")
    out.file_format = "PNG"
    out.save()
    return bpy.data.images.load(out.filepath_raw)


class Screen:
    """A raw capture and the anchors the harness exported for it."""

    def __init__(self, profile, lang, name, trim_top=False, crops=None):
        base = RAW / profile / lang / name
        self.image = load(base.with_suffix(".png"))
        self.anchors = json.loads(base.with_suffix(".json").read_text())
        self.top = self.anchors["top"]
        if trim_top:
            # Frameless: no device, so no status bar; cut the blank inset.
            w, h = self.image.size
            self.image = crop(self.image, [0, self.top, w, h - self.top], crops, f"{profile}-{lang}-{name}")
            for key, rect in self.anchors.items():
                if isinstance(rect, list) and key != "size":
                    self.anchors[key] = [rect[0], rect[1] - self.top, rect[2], rect[3]]
        self.size = self.image.size

    @staticmethod
    def size_of(profile, lang, name):
        return json.loads((RAW / profile / lang / f"{name}.json").read_text())["size"][2:]


class Footage:
    """A screen recording (the harness's STORE_FOOTAGE) as a screen: [top] px
    of status inset hidden, playing from scene frame [start]."""

    def __init__(self, path, top, start):
        self.image = load(path)
        w, h = self.image.size
        self.size = (w, h - top)
        self.crop_top = top / h
        self.movie = (start, self.image.frame_duration)
        self.anchors = {}


def device(screen, screen_w, kind="phone", framed=True):
    """A generic device (uniform bezel, no buttons, camera or notch: nothing
    Apple's or Google's) or, unframed, the bare screen as a thick card.
    Returns (root, screen_h); the screen's centre is the root's origin."""
    iw, ih = screen.size
    screen_h = screen_w * ih / iw
    root = bpy.data.objects.new("device", None)
    bpy.context.scene.collection.objects.link(root)
    unit = screen_w / 7.0
    if framed:
        bezel = (0.17 if kind == "phone" else 0.3) * unit
        radius = (0.95 if kind == "phone" else 0.6) * unit
        body = slab(
            "body",
            screen_w + 2 * bezel,
            screen_h + 2 * bezel,
            radius,
            0.55 * unit,
            [principled("glass", srgb("#08090C"), 0.03, coat=1.0), principled("frame", srgb("#A9B2C3"), 0.22, metallic=1.0)],
            bevel=0.09 * unit,
        )
        body.parent = root
        face = rounded_rect("screen", screen_w, screen_h, max(radius - bezel, 0.05), 28)
        face.location.z = 0.003
    else:
        radius = 0.42 * unit
        face = slab("screen", screen_w, screen_h, radius, 0.12 * unit, [], bevel=0.03 * unit)
    face.data.materials.clear()
    face.data.materials.append(screen_material("screen", screen.image, glass=framed, crop_top=getattr(screen, "crop_top", 0.0), movie=getattr(screen, "movie", None)))
    if not framed:
        face.data.materials.append(principled("edge", srgb("#F4F5FA"), 0.35))
    face.parent = root
    root["screen_w"], root["screen_h"] = screen_w, screen_h
    return root, screen_h


def callout(root, screen, anchor, out_dir, lift, scale=1.0, offset=(0, 0), rotation=(0, 0, 0), radius=0.28, pad=0):
    """The anchored widget, cut from the capture, floating [lift] units above
    its place on the screen, [scale]d and nudged by [offset] (screen units)."""
    iw, ih = screen.size
    left, top, w, h = screen.anchors[anchor]
    left, top, w, h = max(left - pad, 0), max(top - pad, 0), min(w + 2 * pad, iw), h + 2 * pad
    image = crop(screen.image, [left, top, w, h], out_dir, f"{anchor}-{id(root)}")
    k = root["screen_w"] / iw
    cw, ch = w * k * scale, h * k * scale
    card = slab(f"callout-{anchor}", cw, ch, min(radius, ch / 2.05), 0.07, [], bevel=0.02)
    card.data.materials.append(screen_material(anchor, image, glass=False))
    card.data.materials.append(principled("edge", srgb("#F4F5FA"), 0.35))
    card.parent = root
    card.location = (
        (left + w / 2) * k - root["screen_w"] / 2 + offset[0],
        root["screen_h"] / 2 - (top + h / 2) * k + offset[1],
        lift,
    )
    card.rotation_euler = Euler([math.radians(a) for a in rotation])
    return card


def studio(canvas, glow=(0.5, 0.45), key=0.55):
    """Brand-blue backdrop with a soft glow behind the subject, a softbox
    key from the top left, a cool rim and a low fill. HDRI for reflections."""
    world = bpy.data.worlds.new("w")
    world.use_nodes = True
    nodes, links = world.node_tree.nodes, world.node_tree.links
    env = nodes.new("ShaderNodeTexEnvironment")
    env.image = bpy.data.images.load(str(HDRI))
    links.new(env.outputs[0], nodes["Background"].inputs[0])
    nodes["Background"].inputs["Strength"].default_value = 0.3
    bpy.context.scene.world = world

    span = max(canvas.w, canvas.h)
    backdrop = rounded_rect("backdrop", span * 6, span * 6, 1)
    mat, n, l = _mat("backdrop")
    b = n["Principled BSDF"]
    b.inputs["Roughness"].default_value = 0.95
    grad = n.new("ShaderNodeTexGradient")
    grad.gradient_type = "SPHERICAL"
    mapping = n.new("ShaderNodeMapping")
    centre = canvas.at(*glow)
    mapping.inputs["Location"].default_value = (-centre.x / (span * 0.9), -centre.y / (span * 0.9), 0)
    mapping.inputs["Scale"].default_value = (1 / (span * 0.9), 1 / (span * 0.9), 1)
    coords = n.new("ShaderNodeTexCoord")
    ramp = n.new("ShaderNodeValToRGB")
    ramp.color_ramp.interpolation = "EASE"
    ramp.color_ramp.elements[0].color = srgb("#22396A")
    ramp.color_ramp.elements[1].color = srgb("#4C6DAA")
    l.new(coords.outputs["Object"], mapping.inputs["Vector"])
    l.new(mapping.outputs[0], grad.inputs["Vector"])
    l.new(grad.outputs["Fac"], ramp.inputs["Fac"])
    l.new(ramp.outputs["Color"], b.inputs["Base Color"])
    backdrop.data.materials.append(mat)

    s = span / 10
    area("key", 14 * s, 5200 * key * s * s, (-0.7 * canvas.w, 0.8 * canvas.h, 2.2 * span), (-18, -22, 0))
    area("rim", 5 * s, 1800 * key * s * s, (0.9 * canvas.w, 0.3 * canvas.h, 0.6 * span), (-20, 62, 0), (0.82, 0.88, 1.0))
    area("fill", 20 * s, 900 * key * s * s, (0.3 * canvas.w, -1.0 * canvas.h, 1.6 * span), (38, 8, 0))


def area(name, size, energy, location, rotation, colour=(1, 1, 1)):
    light = bpy.data.lights.new(name, "AREA")
    light.size, light.energy, light.color = size, energy, colour
    obj = bpy.data.objects.new(name, light)
    obj.location, obj.rotation_euler = location, Euler([math.radians(a) for a in rotation])
    bpy.context.scene.collection.objects.link(obj)


def balanced(caption, min_chars=18):
    """[caption] without its stars, on two lines of about equal length. It
    splits at a space outside the starred words (a space becomes the break,
    so character indices don't move), unless the text is short."""
    plain, spaces, starred = "", [], False
    for ch in caption:
        if ch == "*":
            starred = not starred
            continue
        if ch == " " and not starred:
            spaces.append(len(plain))
        plain += ch
    if len(plain) < min_chars or not spaces:
        return plain
    i = min(spaces, key=lambda i: abs(len(plain) - 2 * i - 1))
    return plain[:i] + "\n" + plain[i + 1 :]


assert balanced("See *who's coming* at a glance") == "See who's coming\nat a glance"
assert balanced("Every plan, *one tap* to answer") == "Every plan,\none tap to answer"


def headline_size(captions, width, size):
    """One size for a whole set: the largest, up to [size], at which every
    caption's balanced lines fit [width]. Measured on the real fonts."""
    widest = 0.0
    for caption in captions:
        obj = headline(None, caption, 0, 0, 1e6, 1.0)
        bpy.context.view_layer.update()
        widest = max(widest, obj.dimensions.x)
        bpy.data.objects.remove(obj)
    return min(size, width / widest)


def headline(canvas, caption, u, v, width, size, align="CENTER", colour="#FFFFFF", accent=ACCENT, wrap=True):
    """caption with *starred* words in Cabin Bold and the accent colour, the
    rest Cabin Medium. (u, v) is the top of the box."""
    plain = caption.replace("*", "")
    lines = balanced(caption) if wrap else caption.replace("*", "")
    curve = bpy.data.curves.new("headline", "FONT")
    curve.body = lines
    curve.font = bpy.data.fonts.load(str(FONTS / "Cabin-Medium.ttf"))
    curve.font_bold = bpy.data.fonts.load(str(FONTS / "Cabin-Bold.ttf"))
    curve.size, curve.space_line = size, 0.9
    curve.align_x, curve.align_y = align, "TOP"
    curve.text_boxes[0].width = width
    curve.text_boxes[0].x = -width / 2 if align == "CENTER" else 0
    obj = bpy.data.objects.new("headline", curve)
    obj.data.materials.append(emission("ink", srgb(colour)))
    obj.data.materials.append(emission("accent", srgb(accent)))
    i = 0
    for part in re.split(r"(\*[^*]+\*)", caption):
        starred = part.startswith("*")
        for _ in part.strip("*"):  # same length as the body: the split replaced a space
            curve.body_format[i].use_bold = starred
            curve.body_format[i].material_index = int(starred)
            i += 1
    bpy.context.scene.collection.objects.link(obj)
    if canvas:
        obj.location = canvas.at(u, v, 0.02)
    return obj


def render(path):
    path.parent.mkdir(parents=True, exist_ok=True)
    bpy.context.scene.render.filepath = str(path)
    bpy.ops.render.render(write_still=True)
    head = path.read_bytes()[:26]
    w, h = int.from_bytes(head[16:20], "big"), int.from_bytes(head[20:24], "big")
    want = (bpy.context.scene.render.resolution_x, bpy.context.scene.render.resolution_y)
    assert (w, h) == want and head[25] == 2, f"{path}: {w}x{h}, PNG colour type {head[25]}"


# The app's own reply icon (font_awesome_flutter, SIL OFL / CC BY 4.0).
FA_SOLID = Path.home() / ".pub-cache/hosted/pub.dev/font_awesome_flutter-11.0.0/lib/fonts/Font-Awesome-7-Free-Solid-900.otf"
THUMBS_UP = ""


def bubble(root, at, lift, radius, rotation=(0, 0, 0), colour="#2E7D32", glyph=THUMBS_UP):
    """A glossy 3D answer button floating in front of the screen: a domed
    disc with the app's thumbs-up extruded on it. [at] is in screen units
    from the screen centre."""
    disc = slab("bubble", 2 * radius, 2 * radius, radius * 0.999, radius * 0.5, [], bevel=radius * 0.22)
    disc.data.materials.append(principled("bubble", srgb(colour), 0.18, coat=1.0))
    disc.data.materials.append(principled("bubble-side", srgb(colour), 0.25, coat=1.0))
    disc.parent = root
    disc.location = (at[0], at[1], lift)
    disc.rotation_euler = Euler([math.radians(a) for a in rotation])
    curve = bpy.data.curves.new("glyph", "FONT")
    curve.body = glyph
    curve.font = bpy.data.fonts.load(str(FA_SOLID))
    curve.size, curve.align_x, curve.align_y = radius * 1.05, "CENTER", "CENTER"
    curve.extrude, curve.bevel_depth = radius * 0.07, radius * 0.02
    icon = bpy.data.objects.new("glyph", curve)
    icon.data.materials.append(principled("glyph", srgb("#FFFFFF"), 0.3))
    icon.parent = disc
    icon.location = (0, radius * 0.02, radius * 0.09)
    bpy.context.scene.collection.objects.link(icon)
    return disc
