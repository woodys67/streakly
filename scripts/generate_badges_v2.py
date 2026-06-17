#!/usr/bin/env python3
"""
Streakly Badge Generator v2
Flat outline-circle style based on provided reference images.
Output: assets/images/badges_v2/{badge_id}.png (200×200, RGBA)
"""

import os, math
from PIL import Image, ImageDraw, ImageFont

CANVAS = 400
C = CANVAS // 2   # 200 — center

OR  = 176   # outer ring radius
RW  = 28    # ring border width  →  inner content radius = OR-RW = 148
SW  = 14    # standard stroke
SW2 = 10    # thin stroke
WHITE = (255, 255, 255)

GRAY   = (108, 110, 122)
BLUE   = (55,  125, 240)
ORANGE = (238,  90,   0)
YELLOW = (218, 158,  12)
DARK   = (50,   52,  65)

FONT_PATH = "/System/Library/Fonts/Helvetica.ttc"

OUT_DIR = "/Users/hyoungwoosong/MyProject/streakly/assets/images/badges_v2"
os.makedirs(OUT_DIR, exist_ok=True)

# ── Base Badges ───────────────────────────────────────────────

def badge(ring_color):
    img = Image.new('RGBA', (CANVAS, CANVAS), (0, 0, 0, 0))
    d   = ImageDraw.Draw(img)
    d.ellipse([C-OR, C-OR, C+OR, C+OR], fill=ring_color)
    d.ellipse([C-(OR-RW), C-(OR-RW), C+(OR-RW), C+(OR-RW)], fill=WHITE)
    return img, d

def solid_badge(bg_color):
    img = Image.new('RGBA', (CANVAS, CANVAS), (0, 0, 0, 0))
    d   = ImageDraw.Draw(img)
    d.ellipse([C-OR, C-OR, C+OR, C+OR], fill=bg_color)
    return img, d

def save(img, bid):
    img.resize((200, 200), Image.LANCZOS).save(f"{OUT_DIR}/{bid}.png")
    print(f"  ✓ {bid}")

# ── Drawing Helpers ───────────────────────────────────────────

def ln(d, x1, y1, x2, y2, color, w=SW):
    d.line([(x1,y1),(x2,y2)], fill=color, width=w)

def arc(d, cx, cy, rx, ry, start, end, color, w=SW):
    d.arc([cx-rx, cy-ry, cx+rx, cy+ry], start=start, end=end, fill=color, width=w)

def ell(d, cx, cy, r, color):
    d.ellipse([cx-r, cy-r, cx+r, cy+r], fill=color)

def oring(d, cx, cy, r, color, w=SW):
    d.ellipse([cx-r, cy-r, cx+r, cy+r], fill=None, outline=color, width=w)

def poly(d, pts, color):
    d.polygon(pts, fill=color)

def opolygon(d, pts, color, w=SW):
    d.polygon(pts, fill=None, outline=color, width=w)

def rect(d, x, y, w, h, color):
    d.rectangle([x, y, x+w, y+h], fill=color)

def orect(d, x, y, w, h, color, sw=SW):
    d.rectangle([x, y, x+w, y+h], fill=None, outline=color, width=sw)

def rr(d, x, y, w, h, r, color):
    d.rounded_rectangle([x, y, x+w, y+h], radius=r, fill=color)

def orr(d, x, y, w, h, r, color, sw=SW):
    d.rounded_rectangle([x, y, x+w, y+h], radius=r, fill=None, outline=color, width=sw)

def star_pts(cx, cy, ro, ri, n):
    pts = []
    for i in range(n * 2):
        a = math.pi * i / n - math.pi / 2
        r = ro if i % 2 == 0 else ri
        pts.append((cx + r*math.cos(a), cy + r*math.sin(a)))
    return pts

def flame_pts(cx, cy, h, w):
    hw = w / 2
    return [
        (cx,           cy - h),
        (cx + hw*.55,  cy - h*.5),
        (cx + hw*.85,  cy - h*.1),
        (cx + hw*.62,  cy + h*.35),
        (cx,           cy + h*.5),
        (cx - hw*.62,  cy + h*.35),
        (cx - hw*.85,  cy - h*.1),
        (cx - hw*.55,  cy - h*.5),
    ]

def text(d, cx, cy, txt, color, size):
    try:
        font = ImageFont.truetype(FONT_PATH, size)
    except Exception:
        font = ImageFont.load_default()
    d.text((cx, cy), txt, fill=color, font=font, anchor="mm")

# ── STREAK (12) ───────────────────────────────────────────────

def streak_001():
    """Small outline flame · gray ring"""
    img, d = badge(GRAY)
    opolygon(d, flame_pts(C, C+5, 72, 52), GRAY, SW)
    save(img, 'streak_001')

def streak_002():
    """Single outline flame · blue ring"""
    img, d = badge(BLUE)
    opolygon(d, flame_pts(C, C+5, 85, 60), BLUE, SW)
    save(img, 'streak_002')

def streak_003():
    """Double outline flame · blue ring"""
    img, d = badge(BLUE)
    opolygon(d, flame_pts(C-20, C+10, 78, 48), BLUE, SW)
    opolygon(d, flame_pts(C+20,  C+2, 88, 48), BLUE, SW)
    save(img, 'streak_003')

def streak_004():
    """Campfire (logs + flame) · blue ring"""
    img, d = badge(BLUE)
    # Two crossed logs
    ln(d, C-62, C+55, C+62, C+18, BLUE, SW+6)
    ln(d, C+62, C+55, C-62, C+18, BLUE, SW+6)
    # Flame above
    opolygon(d, flame_pts(C, C-10, 65, 46), BLUE, SW)
    save(img, 'streak_004')

def streak_005():
    """Bonfire (triple flames + ember base) · orange ring"""
    img, d = badge(ORANGE)
    # Ember/rock base arc
    arc(d, C, C+60, 68, 26, 0, 180, ORANGE, SW)
    # Three flame outlines
    opolygon(d, flame_pts(C,    C-10, 88, 54), ORANGE, SW)
    opolygon(d, flame_pts(C-42, C+15, 60, 38), ORANGE, SW-2)
    opolygon(d, flame_pts(C+42, C+15, 60, 38), ORANGE, SW-2)
    save(img, 'streak_005')

def streak_006():
    """Furnace (arch opening + flame inside) · orange ring"""
    img, d = badge(ORANGE)
    # Body: rectangle with arch
    ln(d, C-65, C+62, C-65, C-12, ORANGE, SW+2)
    ln(d, C+65, C+62, C+65, C-12, ORANGE, SW+2)
    ln(d, C-65, C+62, C+65, C+62, ORANGE, SW+2)
    arc(d, C, C-12, 65, 58, 180, 360, ORANGE, SW+2)
    # Chimney
    ln(d, C-14, C-70, C-14, C-68, ORANGE, SW+2)
    ln(d, C+14, C-70, C+14, C-68, ORANGE, SW+2)
    ln(d, C-14, C-70, C+14, C-70, ORANGE, SW+2)
    ln(d, C-14, C-12, C-14, C-68, ORANGE, SW+2)
    ln(d, C+14, C-12, C+14, C-68, ORANGE, SW+2)
    # Flame inside
    opolygon(d, flame_pts(C, C+30, 36, 26), ORANGE, SW-3)
    save(img, 'streak_006')

def streak_007():
    """Volcano · orange ring"""
    img, d = badge(ORANGE)
    opolygon(d, [(C, C-62), (C+82, C+68), (C-82, C+68)], ORANGE, SW+2)
    # Eruption at top
    opolygon(d, flame_pts(C,   C-80, 26, 18), ORANGE, SW-2)
    opolygon(d, flame_pts(C-20, C-68, 20, 14), ORANGE, SW-3)
    opolygon(d, flame_pts(C+20, C-68, 20, 14), ORANGE, SW-3)
    save(img, 'streak_007')

def streak_008():
    """Sun (circle + 8 rays) · orange ring"""
    img, d = badge(ORANGE)
    oring(d, C, C, 38, ORANGE, SW+2)
    for i in range(8):
        a = math.pi * 2 * i / 8
        x1, y1 = C+50*math.cos(a), C+50*math.sin(a)
        x2, y2 = C+80*math.cos(a), C+80*math.sin(a)
        ln(d, int(x1), int(y1), int(x2), int(y2), ORANGE, SW)
    save(img, 'streak_008')

def streak_009():
    """6-point Star of David outline · yellow ring"""
    img, d = badge(YELLOW)
    # Up-pointing triangle
    opolygon(d, [(C, C-80), (C+70, C+40), (C-70, C+40)], YELLOW, SW+2)
    # Down-pointing triangle
    opolygon(d, [(C, C+80), (C+70, C-40), (C-70, C-40)], YELLOW, SW+2)
    save(img, 'streak_009')

def streak_010():
    """Phoenix wing · orange ring"""
    img, d = badge(ORANGE)
    # Main wing body (large curve)
    arc(d, C-10, C+15, 95, 75, 195, 355, ORANGE, SW+2)
    arc(d, C+5,  C-22, 85, 60, 210, 360, ORANGE, SW)
    # Wing feather tips (3 curved lines at top of wing)
    for dx, cx2, cy2 in [(-38, C-38, C-72), (-10, C-8, C-82), (18, C+20, C-72)]:
        arc(d, C+dx-5, C-60, 22, 30, 240, 360, ORANGE, SW-3)
    # Connect tips
    ln(d, C-56, C-52, C+18, C-86, ORANGE, SW-2)
    save(img, 'streak_010')

def streak_011():
    """U-turn comeback arrow · gray ring"""
    img, d = badge(GRAY)
    # Semicircle bottom
    arc(d, C, C-5, 58, 58, 0, 180, GRAY, SW+2)
    # Left leg going down
    ln(d, C-58, C-5, C-58, C+58, GRAY, SW+2)
    # Right leg going up
    ln(d, C+58, C-5, C+58, C-72, GRAY, SW+2)
    # Arrowhead
    poly(d, [(C+58, C-90), (C+36, C-68), (C+80, C-68)], GRAY)
    save(img, 'streak_011')

def streak_012():
    """Calendar + flame · blue ring"""
    img, d = badge(BLUE)
    # Calendar outline
    orr(d, C-60, C-30, 120, 92, 8, BLUE, SW)
    # Top bar line
    ln(d, C-60, C-5, C+60, C-5, BLUE, SW)
    # Ring hangers
    ln(d, C-24, C-46, C-24, C-26, BLUE, SW+3)
    ln(d, C+24, C-46, C+24, C-26, BLUE, SW+3)
    # Date dots
    for row in range(2):
        for col in range(4):
            ell(d, C-38+col*26, C+14+row*22, 5, BLUE)
    # Small flame right side
    opolygon(d, flame_pts(C+28, C+10, 38, 27), BLUE, SW-3)
    save(img, 'streak_012')

# ── COMPLETION (10) ───────────────────────────────────────────

def complete_001():
    """Bullseye + dart · gray outer + blue inner rings + orange arrow"""
    img, d = badge(GRAY)
    # Concentric target rings (blue)
    for r in [88, 64, 40]:
        oring(d, C, C, r, BLUE, SW)
    # Bullseye center filled
    ell(d, C, C, 16, BLUE)
    # Orange dart arrow (diagonal from top-right)
    poly(d, [(C+62, C-62), (C+78, C-48), (C-8, C+32), (C-24, C+18)], ORANGE)
    ell(d, C+70, C-55, 9, ORANGE)  # arrow tip
    save(img, 'complete_001')

def complete_002():
    """Three dots (2 gray + 1 orange) · blue ring"""
    img, d = badge(BLUE)
    for i, col in enumerate([GRAY, GRAY, ORANGE]):
        ell(d, C-52+i*52, C, 22, col)
    save(img, 'complete_002')

def complete_003():
    """"10" numeral · yellow ring"""
    img, d = badge(YELLOW)
    text(d, C, C+6, "10", GRAY, 110)
    save(img, 'complete_003')

def complete_004():
    """Graduation cap (filled blue) · gray ring"""
    img, d = badge(GRAY)
    # Cap top (flat diamond)
    poly(d, [(C, C-50), (C+65, C-10), (C, C+30), (C-65, C-10)], BLUE)
    # Under band
    rect(d, C-28, C+26, 56, 16, BLUE)
    # Tassel
    ln(d, C+65, C-10, C+65, C+32, BLUE, SW)
    ell(d, C+65, C+38, 10, BLUE)
    save(img, 'complete_004')

def complete_005():
    """Diamond gem outline · yellow ring"""
    img, d = badge(YELLOW)
    # Outer diamond shape
    pts = [(C, C-78), (C+55, C-18), (C+40, C+65), (C-40, C+65), (C-55, C-18)]
    opolygon(d, pts, YELLOW, SW+2)
    # Facet lines
    ln(d, C-55, C-18, C+55, C-18, YELLOW, SW-2)   # horizontal facet
    ln(d, C, C-78,    C-55, C-18, YELLOW, SW-2)
    ln(d, C, C-78,    C+55, C-18, YELLOW, SW-2)
    ln(d, C-55, C-18, C-40, C+65, YELLOW, SW-2)
    ln(d, C+55, C-18, C+40, C+65, YELLOW, SW-2)
    ln(d, C-55, C-18, C, C+12,    YELLOW, SW-2)
    ln(d, C+55, C-18, C, C+12,    YELLOW, SW-2)
    ln(d, C, C+12,    C-40, C+65, YELLOW, SW-2)
    ln(d, C, C+12,    C+40, C+65, YELLOW, SW-2)
    save(img, 'complete_005')

def complete_006():
    """Two diamonds · yellow ring"""
    img, d = badge(YELLOW)
    for ox in [-38, 38]:
        pts = [(C+ox, C-52), (C+ox+33, C-8), (C+ox+22, C+52), (C+ox-22, C+52), (C+ox-33, C-8)]
        opolygon(d, pts, YELLOW, SW)
        ln(d, C+ox-33, C-8, C+ox+33, C-8, YELLOW, SW-3)
        ln(d, C+ox, C-52, C+ox, C-8,      YELLOW, SW-3)
    save(img, 'complete_006')

def complete_007():
    """Checkered flag · blue ring"""
    img, d = badge(BLUE)
    # Pole
    ln(d, C-50, C-78, C-50, C+60, GRAY, SW+2)
    # Flag body: 4×3 checkerboard
    sq = 28
    for row in range(3):
        for col in range(4):
            fill = GRAY if (row+col) % 2 == 0 else WHITE
            rect(d, C-50+col*sq, C-78+row*sq, sq, sq, fill)
    # Flag outline
    orect(d, C-50, C-78, 4*sq, 3*sq, BLUE, SW-3)
    save(img, 'complete_007')

def complete_008():
    """Crown outline · yellow ring"""
    img, d = badge(YELLOW)
    # Crown base
    orect(d, C-62, C+18, 124, 36, YELLOW, SW+2)
    # Three peaks
    opolygon(d, [(C-62, C+18), (C-45, C+18), (C-52, C-40)], YELLOW, SW+2)
    opolygon(d, [(C-16, C+18), (C+16, C+18), (C, C-62)],    YELLOW, SW+2)
    opolygon(d, [(C+45, C+18), (C+62, C+18), (C+52, C-40)], YELLOW, SW+2)
    # Crown dots
    for cx2 in [C-40, C, C+40]:
        oring(d, cx2, C+32, 7, YELLOW, SW-3)
    save(img, 'complete_008')

def complete_009():
    """Trophy (filled orange) · orange ring"""
    img, d = badge(ORANGE)
    # Cup body
    poly(d, [(C-50, C-62), (C+50, C-62), (C+36, C+8), (C-36, C+8)], ORANGE)
    # Handles
    arc(d, C-72, C-52, 28, 45, 270, 90, ORANGE, SW+2)
    arc(d, C+72, C-52, 28, 45,  90, 270, ORANGE, SW+2)
    # Stem + base
    rect(d, C-10, C+8,  20, 26, ORANGE)
    rect(d, C-38, C+34, 76, 16, ORANGE)
    save(img, 'complete_009')

def complete_010():
    """Shield (blue outer + gray inner) · blue ring"""
    img, d = badge(BLUE)
    # Outer shield (blue)
    poly(d, [(C, C+80), (C-68, C+28), (C-68, C-48), (C, C-68), (C+68, C-48), (C+68, C+28)], BLUE)
    # Inner shield (gray, slightly smaller)
    poly(d, [(C, C+55), (C-46, C+18), (C-46, C-30), (C, C-46), (C+46, C-30), (C+46, C+18)], GRAY)
    save(img, 'complete_010')

# ── LOGGING (8) ───────────────────────────────────────────────

def log_001():
    """Pencil (white on dark solid bg) · solid dark"""
    img, d = solid_badge(DARK)
    ic = (200, 202, 215)
    # Diagonal pencil body
    poly(d, [(C+16, C-72), (C+46, C-42), (C-16, C+65), (C-46, C+35)], ic)
    # Tip (darker)
    poly(d, [(C-16, C+65), (C+16, C+88), (C-46, C+35)], (140, 142, 155))
    # Eraser top (lighter)
    poly(d, [(C+16, C-72), (C+46, C-42), (C+38, C-56), (C+8, C-86)], (230, 232, 242))
    save(img, 'log_001')

def log_002():
    """Notebook (filled blue) · blue ring"""
    img, d = badge(BLUE)
    rr(d, C-50, C-62, 100, 124, 8, BLUE)
    # Spine
    rect(d, C-50, C-62, 18, 124, (30, 90, 180))
    # Lines
    for y in [C-28, C-6, C+16, C+38]:
        rect(d, C-24, y, 62, 9, (30, 90, 180))
    save(img, 'log_002')

def log_003():
    """Book with bookmark (filled orange) · orange ring"""
    img, d = badge(ORANGE)
    rr(d, C-48, C-60, 96, 120, 8, ORANGE)
    # Spine
    rect(d, C-48, C-60, 16, 120, (160, 55, 0))
    # Lines
    for y in [C-28, C-6, C+16, C+38]:
        rect(d, C-24, y, 62, 9, (160, 55, 0))
    # Bookmark triangle
    poly(d, [(C+22, C-60), (C+44, C-60), (C+44, C-28), (C+33, C-42), (C+22, C-28)], (255, 200, 50))
    save(img, 'log_003')

def log_004():
    """Open book (outline gray) · gray ring"""
    img, d = badge(GRAY)
    # Left page
    opolygon(d, [(C-72, C-52), (C-2, C-52), (C-2, C+55), (C-72, C+55)], GRAY, SW)
    # Right page
    opolygon(d, [(C+2,  C-52), (C+72, C-52), (C+72, C+55), (C+2,  C+55)], GRAY, SW)
    # Spine
    arc(d, C, C, 5, 55, 0, 180, GRAY, SW)
    # Lines left page
    for y in [C-24, C-4, C+16, C+36]:
        ln(d, C-62, y, C-12, y, GRAY, SW-3)
    # Lines right page
    for y in [C-24, C-4, C+16, C+36]:
        ln(d, C+12, y, C+62, y, GRAY, SW-3)
    save(img, 'log_004')

def log_005():
    """Speech bubble + three dots · dark ring"""
    img, d = badge(DARK)
    # Bubble body
    orr(d, C-65, C-50, 130, 82, 22, DARK, SW+2)
    # Tail
    opolygon(d, [(C-28, C+32), (C-52, C+68), (C+5, C+32)], DARK, SW)
    # Three dots inside
    for cx2 in [C-28, C, C+28]:
        ell(d, cx2, C-8, 10, DARK)
    save(img, 'log_005')

def log_006():
    """Magnifying glass (outline blue) · blue ring"""
    img, d = badge(BLUE)
    oring(d, C-15, C-15, 52, BLUE, SW+2)
    poly(d, [(C+22, C+22), (C+32, C+12), (C+72, C+58), (C+62, C+68)], BLUE)
    save(img, 'log_006')

def log_007():
    """Scroll (filled orange) · orange ring"""
    img, d = badge(ORANGE)
    dk_o = (168, 58, 0)
    # Scroll body
    rr(d, C-52, C-45, 104, 90, 20, ORANGE)
    # Top rolled edge
    d.ellipse([C-52, C-60, C+52, C-30], fill=dk_o)
    d.ellipse([C-38, C-55, C+38, C-35], fill=ORANGE)
    # Bottom rolled edge
    d.ellipse([C-52, C+30, C+52, C+60], fill=dk_o)
    d.ellipse([C-38, C+35, C+38, C+55], fill=ORANGE)
    # Text lines
    for y in [C-20, C-2, C+16, C+34]:
        rect(d, C-34, y, 68, 8, dk_o)
    save(img, 'log_007')

def log_008():
    """Folder (filled beige/gray) · gray ring"""
    img, d = badge(GRAY)
    tab_c = (175, 165, 148)
    body_c = (200, 192, 176)
    # Folder tab (rounded)
    rr(d, C-62, C-52, 62, 26, 8, tab_c)
    # Folder body
    rr(d, C-62, C-34, 124, 88, 8, body_c)
    # Divider line
    ln(d, C-62, C-34, C+62, C-34, tab_c, SW-3)
    # Lines inside
    for y in [C-10, C+10, C+30]:
        ln(d, C-44, y, C+44, y, tab_c, SW-3)
    save(img, 'log_008')

# ── TIMING (8) ────────────────────────────────────────────────

def timing_001():
    """Sunrise (outline yellow) · yellow ring"""
    img, d = badge(YELLOW)
    # Horizon lines
    ln(d, C-80, C+25, C-28, C+25, YELLOW, SW)
    ln(d, C+28, C+25, C+80, C+25, YELLOW, SW)
    # Rising sun semicircle
    arc(d, C, C+25, 52, 52, 180, 360, YELLOW, SW+2)
    # Rays above
    for ang in [-65, -35, 0, 35, 65]:
        a = math.radians(ang - 90)
        x1, y1 = C+60*math.cos(a), C+25+60*math.sin(a)
        x2, y2 = C+88*math.cos(a), C+25+88*math.sin(a)
        ln(d, int(x1), int(y1), int(x2), int(y2), YELLOW, SW)
    save(img, 'timing_001')

def timing_002():
    """Full sun (circle + 8 rays) · orange ring"""
    img, d = badge(ORANGE)
    # 8 rays first
    for i in range(8):
        a = math.pi * 2 * i / 8
        x1, y1 = C+48*math.cos(a), C+48*math.sin(a)
        x2, y2 = C+82*math.cos(a), C+82*math.sin(a)
        ln(d, int(x1), int(y1), int(x2), int(y2), ORANGE, SW)
    oring(d, C, C, 38, ORANGE, SW+3)
    save(img, 'timing_002')

def timing_003():
    """Crescent moon · solid dark"""
    img, d = solid_badge(DARK)
    ic = (180, 182, 200)
    ell(d, C, C, 68, ic)
    bg = tuple(max(c-15, 0) for c in DARK)
    ell(d, C+26, C-14, 60, DARK)
    save(img, 'timing_003')

def timing_004():
    """Stopwatch · blue ring"""
    img, d = badge(BLUE)
    # Clock face
    oring(d, C, C+10, 65, BLUE, SW+2)
    # Crown
    rr(d, C-14, C-56, 28, 18, 4, BLUE)
    # Button knobs
    rr(d, C-26, C-65, 16, 14, 3, BLUE)
    rr(d, C+10, C-65, 16, 14, 3, BLUE)
    # Hour hand (12 o'clock)
    ln(d, C, C+10, C, C-38, BLUE, SW+3)
    # Minute hand (slight right — ~15 past)
    ln(d, C, C+10, C+34, C+10, BLUE, SW)
    ell(d, C, C+10, 8, BLUE)
    save(img, 'timing_004')

def timing_005():
    """8-point star burst · yellow ring"""
    img, d = badge(YELLOW)
    opolygon(d, star_pts(C, C, 88, 34, 8), YELLOW, SW+2)
    save(img, 'timing_005')

def timing_006():
    """Briefcase (outline gray) · gray ring"""
    img, d = badge(GRAY)
    # Case body
    orr(d, C-60, C-28, 120, 86, 10, GRAY, SW+2)
    # Handle
    arc(d, C, C-32, 28, 28, 180, 360, GRAY, SW+2)
    # Middle strap
    ln(d, C-60, C+8, C+60, C+8, GRAY, SW)
    # Clasp
    orr(d, C-14, C+2, 28, 18, 4, GRAY, SW-2)
    save(img, 'timing_006')

def timing_007():
    """Clock face with "23:59" · solid dark"""
    img, d = solid_badge(DARK)
    ic = (175, 178, 198)
    oring(d, C, C, 75, ic, SW+2)
    # Tick marks at 4 cardinal positions
    for i in range(4):
        a = math.pi/2 * i - math.pi/2
        x1, y1 = C+60*math.cos(a), C+60*math.sin(a)
        x2, y2 = C+75*math.cos(a), C+75*math.sin(a)
        ln(d, int(x1), int(y1), int(x2), int(y2), ic, SW)
    # "23:59" text
    text(d, C, C+8, "23:59", ic, 52)
    save(img, 'timing_007')

def timing_008():
    """Fireworks · orange ring"""
    img, d = badge(ORANGE)
    bursts = [(C, C-20, 10, 55), (C-48, C+32, 7, 36), (C+48, C+32, 7, 36)]
    for bx, by, n, size in bursts:
        for i in range(n):
            a = math.pi * 2 * i / n
            x1, y1 = bx + 10*math.cos(a), by + 10*math.sin(a)
            x2, y2 = bx + size*math.cos(a), by + size*math.sin(a)
            ln(d, int(x1), int(y1), int(x2), int(y2), ORANGE, SW-2)
        ell(d, bx, by, 9, ORANGE)
    # Small stars around main burst
    for ang in [30, 80, 130, 210, 290]:
        a = math.radians(ang)
        sx, sy = C + 70*math.cos(a), C-20 + 70*math.sin(a)
        poly(d, star_pts(int(sx), int(sy), 9, 4, 4), ORANGE)
    save(img, 'timing_008')

# ── SUBROUTINE (6) ────────────────────────────────────────────

def sub_001():
    """Plus sign (filled orange) · orange ring"""
    img, d = badge(ORANGE)
    rect(d, C-14, C-72, 28, 144, ORANGE)
    rect(d, C-72, C-14, 144, 28, ORANGE)
    save(img, 'sub_001')

def sub_002():
    """Three upward arrows (filled blue) · blue ring"""
    img, d = badge(BLUE)
    for ox in [-42, 0, 42]:
        ln(d, C+ox, C+62, C+ox, C-28, BLUE, SW+4)
        poly(d, [(C+ox, C-52), (C+ox-18, C-25), (C+ox+18, C-25)], BLUE)
    save(img, 'sub_002')

def sub_003():
    """Three gears (outline gray) · gray ring"""
    img, d = badge(GRAY)
    positions = [(C-42, C+22), (C+42, C+22), (C, C-28)]
    for (gx, gy) in positions:
        # Gear outer ring
        oring(d, gx, gy, 32, GRAY, SW)
        # Gear teeth (8 small bumps approximated as dots)
        for i in range(8):
            a = math.pi * 2 * i / 8
            tx, ty = int(gx + 36*math.cos(a)), int(gy + 36*math.sin(a))
            ell(d, tx, ty, 6, GRAY)
        # Inner circle
        oring(d, gx, gy, 14, GRAY, SW-3)
    save(img, 'sub_003')

def sub_004():
    """Two lightning bolts (filled orange) · orange ring"""
    img, d = badge(ORANGE)
    for ox in [-30, 30]:
        poly(d, [
            (C+ox+8,  C-72),
            (C+ox-14,  C-4),
            (C+ox+6,   C-4),
            (C+ox-8,  C+72),
            (C+ox+20,  C+4),
            (C+ox+0,   C+4),
        ], ORANGE)
    save(img, 'sub_004')

def sub_005():
    """Checkmark (filled yellow) · yellow ring"""
    img, d = badge(YELLOW)
    d.line([(C-72, C+8), (C-22, C+55), (C+72, C-55)], fill=YELLOW, width=26)
    save(img, 'sub_005')

def sub_006():
    """Globe (outline blue) · blue ring"""
    img, d = badge(BLUE)
    oring(d, C, C, 75, BLUE, SW+2)
    # Vertical axis
    ln(d, C, C-75, C, C+75, BLUE, SW)
    # Equator
    ln(d, C-75, C, C+75, C, BLUE, SW)
    # Latitude ellipses (approximate with arcs)
    arc(d, C, C-28, 68, 28, 0, 180, BLUE, SW)
    arc(d, C, C-28, 68, 28, 180, 360, BLUE, SW)
    arc(d, C, C+28, 68, 28, 0, 180, BLUE, SW)
    arc(d, C, C+28, 68, 28, 180, 360, BLUE, SW)
    save(img, 'sub_006')

# ── TEAM (6) ──────────────────────────────────────────────────

def team_001():
    """Two person silhouettes (outline gray) · gray ring"""
    img, d = badge(GRAY)
    for ox in [-38, 38]:
        # Head
        oring(d, C+ox, C-38, 22, GRAY, SW)
        # Body
        arc(d, C+ox, C+20, 32, 35, 180, 360, GRAY, SW)
        ln(d, C+ox-32, C+20, C+ox-32, C+60, GRAY, SW)
        ln(d, C+ox+32, C+20, C+ox+32, C+60, GRAY, SW)
        ln(d, C+ox-32, C+60, C+ox+32, C+60, GRAY, SW)
    save(img, 'team_001')

def team_002():
    """Two chevrons upward (filled orange) · orange ring"""
    img, d = badge(ORANGE)
    for cy2 in [C+25, C-12]:
        poly(d, [
            (C-72, cy2+28), (C, cy2-28), (C+72, cy2+28),
            (C+72, cy2+48), (C, cy2-8),  (C-72, cy2+48),
        ], ORANGE)
    save(img, 'team_002')

def team_003():
    """Trophy + three stars (outline yellow) · yellow ring"""
    img, d = badge(YELLOW)
    # Trophy cup
    opolygon(d, [(C-44, C-35), (C+44, C-35), (C+32, C+20), (C-32, C+20)], YELLOW, SW)
    arc(d, C-65, C-28, 25, 40, 270, 90, YELLOW, SW)
    arc(d, C+65, C-28, 25, 40,  90, 270, YELLOW, SW)
    ln(d, C-10, C+20, C-10, C+42, YELLOW, SW)
    ln(d, C+10, C+20, C+10, C+42, YELLOW, SW)
    ln(d, C-32, C+42, C+32, C+42, YELLOW, SW)
    # Three stars above
    for bx, size in [(C-30, 15), (C, 20), (C+30, 15)]:
        opolygon(d, star_pts(bx, C-58, size, size//2, 5), YELLOW, SW-3)
    save(img, 'team_003')

def team_004():
    """Megaphone + sound waves (outline blue) · blue ring"""
    img, d = badge(BLUE)
    # Megaphone body
    opolygon(d, [(C-65, C-22), (C-65, C+22), (C+22, C+50), (C+22, C-50)], BLUE, SW)
    # Handle grip
    rect(d, C-78, C-12, 20, 24, BLUE)
    # Sound waves (3 arcs)
    for r in [32, 52, 72]:
        arc(d, C+22, C, r, r, 300, 60, BLUE, SW)
    save(img, 'team_004')

def team_005():
    """5-point star (filled yellow) · yellow ring"""
    img, d = badge(YELLOW)
    poly(d, star_pts(C, C, 90, 36, 5), YELLOW)
    save(img, 'team_005')

def team_006():
    """Three stars — 1 large center + 2 small (outline gray) · gray ring"""
    img, d = badge(GRAY)
    # Large center star
    opolygon(d, star_pts(C, C-8, 52, 22, 5), GRAY, SW)
    # Two small side stars
    opolygon(d, star_pts(C-58, C+28, 28, 11, 5), GRAY, SW-2)
    opolygon(d, star_pts(C+58, C+28, 28, 11, 5), GRAY, SW-2)
    save(img, 'team_006')

# ── Run All ───────────────────────────────────────────────────

if __name__ == '__main__':
    print("Generating Streakly badges v2...\n")

    print("[ Streak ]")
    streak_001(); streak_002(); streak_003(); streak_004()
    streak_005(); streak_006(); streak_007(); streak_008()
    streak_009(); streak_010(); streak_011(); streak_012()

    print("\n[ Completion ]")
    complete_001(); complete_002(); complete_003(); complete_004()
    complete_005(); complete_006(); complete_007(); complete_008()
    complete_009(); complete_010()

    print("\n[ Logging ]")
    log_001(); log_002(); log_003(); log_004()
    log_005(); log_006(); log_007(); log_008()

    print("\n[ Timing ]")
    timing_001(); timing_002(); timing_003(); timing_004()
    timing_005(); timing_006(); timing_007(); timing_008()

    print("\n[ Subroutine ]")
    sub_001(); sub_002(); sub_003(); sub_004()
    sub_005(); sub_006()

    print("\n[ Team ]")
    team_001(); team_002(); team_003(); team_004()
    team_005(); team_006()

    count = len([f for f in os.listdir(OUT_DIR) if f.endswith('.png')])
    print(f"\nDone! {count} badges → {OUT_DIR}")
