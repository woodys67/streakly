#!/usr/bin/env python3
"""
Streakly Badge PNG Generator — 50 custom badge images
"""
import os, math
from PIL import Image, ImageDraw

CANVAS = 400
C = CANVAS // 2  # 200
R_OUT = 178
R_IN  = 158

OUT_DIR = "/Users/hyoungwoosong/MyProject/streakly/assets/images/badges"
os.makedirs(OUT_DIR, exist_ok=True)

COLORS = {
    'common':    {'rim': (148, 150, 162), 'bg': ( 88,  90, 102), 'ic': (228, 230, 244)},
    'rare':      {'rim': ( 62, 118, 215), 'bg': ( 35,  75, 162), 'ic': (205, 225, 255)},
    'epic':      {'rim': (215, 100,  22), 'bg': (148,  55,   5), 'ic': (255, 215, 175)},
    'legendary': {'rim': (225, 178,  42), 'bg': (162, 112,  10), 'ic': (255, 240, 172)},
    'secret':    {'rim': ( 68,  72,  88), 'bg': ( 28,  30,  42), 'ic': (145, 148, 170)},
}

def new_badge(rarity):
    img = Image.new('RGBA', (CANVAS, CANVAS), (0, 0, 0, 0))
    d   = ImageDraw.Draw(img)
    col = COLORS[rarity]
    d.ellipse([C-R_OUT, C-R_OUT, C+R_OUT, C+R_OUT], fill=col['rim'])
    d.ellipse([C-R_IN,  C-R_IN,  C+R_IN,  C+R_IN],  fill=col['bg'])
    return img, d, col['ic']

def save_badge(img, bid):
    out = img.resize((200, 200), Image.LANCZOS)
    out.save(f"{OUT_DIR}/{bid}.png")
    print(f"  ✓ {bid}")

# ── Helpers ───────────────────────────────────────────────────

def poly(d, pts, color):
    d.polygon(pts, fill=color)

def rect(d, x, y, w, h, color):
    d.rectangle([x, y, x+w, y+h], fill=color)

def rrect(d, x, y, w, h, r, color):
    d.rounded_rectangle([x, y, x+w, y+h], radius=r, fill=color)

def circle(d, cx, cy, r, color):
    d.ellipse([cx-r, cy-r, cx+r, cy+r], fill=color)

def ring(d, cx, cy, r, color, width=12):
    d.ellipse([cx-r, cy-r, cx+r, cy+r], outline=color, width=width)

def ln(d, x1, y1, x2, y2, color, width=10):
    d.line([(x1, y1), (x2, y2)], fill=color, width=width)

def hi(color, amt=55):
    r, g, b = color
    return (min(r+amt, 255), min(g+amt, 255), min(b+amt, 255))

def dk(color, amt=70):
    r, g, b = color
    return (max(r-amt, 0), max(g-amt, 0), max(b-amt, 0))

def flame(d, cx, cy, h, w, color):
    hw = w / 2
    poly(d, [
        (cx,           cy - h),
        (cx + hw*.55,  cy - h*.48),
        (cx + hw*.85,  cy - h*.08),
        (cx + hw*.62,  cy + h*.36),
        (cx,           cy + h*.50),
        (cx - hw*.62,  cy + h*.36),
        (cx - hw*.85,  cy - h*.08),
        (cx - hw*.55,  cy - h*.48),
    ], color)
    poly(d, [
        (cx,           cy - h*.44),
        (cx + hw*.30,  cy - h*.04),
        (cx,           cy + h*.26),
        (cx - hw*.30,  cy - h*.04),
    ], hi(color, 55))

def star_pts(cx, cy, r_out, r_in, n):
    pts = []
    for i in range(n * 2):
        angle = math.pi * i / n - math.pi / 2
        r = r_out if i % 2 == 0 else r_in
        pts.append((cx + r*math.cos(angle), cy + r*math.sin(angle)))
    return pts

# ── STREAK (12) ───────────────────────────────────────────────

def streak_001():
    """첫 불꽃 · common · tiny single flame"""
    img, d, ic = new_badge('common')
    flame(d, C, C+8, 72, 50, ic)
    save_badge(img, 'streak_001')

def streak_002():
    """불씨 · common · three ember sparks"""
    img, d, ic = new_badge('common')
    circle(d, C,     C-30, 18, hi(ic, 55))
    circle(d, C-26,  C+20, 13, ic)
    circle(d, C+26,  C+20, 13, ic)
    save_badge(img, 'streak_002')

def streak_003():
    """작은 불꽃 · common · medium flame"""
    img, d, ic = new_badge('common')
    flame(d, C, C+5, 88, 62, ic)
    save_badge(img, 'streak_003')

def streak_004():
    """모닥불 · rare · logs + flame"""
    img, d, ic = new_badge('rare')
    poly(d, [(C-62, C+48), (C+62, C+12), (C+58, C+30), (C-58, C+65)], ic)
    poly(d, [(C+62, C+48), (C-62, C+12), (C-58, C+30), (C+58, C+65)], ic)
    flame(d, C, C-12, 62, 42, ic)
    save_badge(img, 'streak_004')

def streak_005():
    """화톳불 · rare · big flame + sparks"""
    img, d, ic = new_badge('rare')
    flame(d, C, C+5, 102, 70, ic)
    for ang, dist, sz in [(25, 88, 9), (155, 88, 9), (15, 108, 7), (165, 108, 7)]:
        a = math.radians(ang - 90)
        circle(d, int(C + dist*math.cos(a)), int(C + dist*math.sin(a)), sz, hi(ic, 50))
    save_badge(img, 'streak_005')

def streak_006():
    """용광로 · epic · furnace/forge"""
    img, d, ic = new_badge('epic')
    rrect(d, C-52, C-30, 104, 78, 10, ic)
    d.ellipse([C-28, C-5, C+28, C+52], fill=dk(ic, 90))
    flame(d, C, C+12, 38, 26, hi(ic, 60))
    rect(d, C-12, C-50, 24, 24, ic)
    rect(d, C-22, C-58, 16, 12, ic)
    rect(d, C+6,  C-58, 16, 12, ic)
    save_badge(img, 'streak_006')

def streak_007():
    """불의 지배자 · epic · volcano"""
    img, d, ic = new_badge('epic')
    poly(d, [(C, C-72), (C+80, C+65), (C-80, C+65)], ic)
    poly(d, [(C, C-32), (C+30, C+15), (C-30, C+15)], dk(ic, 85))
    flame(d, C, C-92, 52, 36, hi(ic, 60))
    save_badge(img, 'streak_007')

def streak_008():
    """태양 · epic · sun with 8 rays"""
    img, d, ic = new_badge('epic')
    for i in range(8):
        angle = math.pi * 2 * i / 8
        d.line([(C + 50*math.cos(angle), C + 50*math.sin(angle)),
                (C + 90*math.cos(angle), C + 90*math.sin(angle))],
               fill=hi(ic, 30), width=13)
    circle(d, C, C, 42, ic)
    save_badge(img, 'streak_008')

def streak_009():
    """영원한 불꽃 · legendary · 6-point star"""
    img, d, ic = new_badge('legendary')
    poly(d, star_pts(C, C, 90, 42, 6), ic)
    circle(d, C, C, 20, hi(ic, 45))
    save_badge(img, 'streak_009')

def streak_010():
    """불사조 · rare · phoenix wings rising"""
    img, d, ic = new_badge('rare')
    poly(d, [(C, C+12), (C-30, C-18), (C-65, C-42), (C-72, C-8), (C-52, C+22), (C-24, C+36)], ic)
    poly(d, [(C, C+12), (C+30, C-18), (C+65, C-42), (C+72, C-8), (C+52, C+22), (C+24, C+36)], ic)
    circle(d, C, C-12, 22, ic)
    for dx in [-12, 0, 12]:
        poly(d, [(C+dx, C+36), (C+dx-7, C+82), (C+dx+7, C+82)], hi(ic, 45))
    save_badge(img, 'streak_010')

def streak_011():
    """부활 · common · comeback arrow (U + up arrow)"""
    img, d, ic = new_badge('common')
    d.arc([C-52, C-5, C+52, C+78], start=180, end=0, fill=ic, width=14)
    rect(d, C+38, C-75, 14, 80, ic)
    poly(d, [(C+45, C-90), (C+22, C-65), (C+68, C-65)], ic)
    save_badge(img, 'streak_011')

def streak_012():
    """올해의 불꽃 · legendary · calendar + flame"""
    img, d, ic = new_badge('legendary')
    rrect(d, C-55, C-15, 110, 80, 10, ic)
    rrect(d, C-55, C-15, 110, 28, 10, dk(ic, 65))
    for row in range(2):
        for col in range(4):
            circle(d, C-38+col*26, C+26+row*22, 5, dk(ic, 65))
    flame(d, C, C-48, 50, 34, hi(ic, 55))
    save_badge(img, 'streak_012')

# ── COMPLETION (10) ───────────────────────────────────────────

def complete_001():
    """첫 완주 · common · bullseye"""
    img, d, ic = new_badge('common')
    for r_val, fill in [(72, dk(ic,65)), (52, ic), (30, dk(ic,65)), (12, ic)]:
        circle(d, C, C, r_val, fill)
    save_badge(img, 'complete_001')

def complete_002():
    """세 번의 약속 · common · three dots"""
    img, d, ic = new_badge('common')
    for cx in [C-50, C, C+50]:
        circle(d, cx, C, 24, ic)
    save_badge(img, 'complete_002')

def complete_003():
    """10전 10승 · rare · "10" numeral"""
    img, d, ic = new_badge('rare')
    rect(d, C-32, C-48, 14, 96, ic)
    poly(d, [(C-32, C-48), (C-10, C-62), (C-10, C-48)], ic)
    ring(d, C+24, C, 32, ic, width=14)
    save_badge(img, 'complete_003')

def complete_004():
    """챌린지 마스터 · epic · graduation cap"""
    img, d, ic = new_badge('epic')
    poly(d, [(C, C-62), (C+58, C-16), (C, C+28), (C-58, C-16)], ic)
    poly(d, [(C, C-62), (C+58, C-16), (C+8, C-20), (C-8, C-48)], dk(ic, 60))
    rect(d, C-24, C+24, 48, 14, ic)
    rect(d, C+35, C-22, 6, 58, ic)
    circle(d, C+38, C+38, 9, ic)
    save_badge(img, 'complete_004')

def complete_005():
    """완벽주의자 · rare · gem diamond"""
    img, d, ic = new_badge('rare')
    poly(d, [(C, C-72), (C+54, C-15), (C+38, C+65), (C-38, C+65), (C-54, C-15)], ic)
    poly(d, [(C, C-72), (C+54, C-15), (C, C-10)], hi(ic, 48))
    poly(d, [(C, C-10), (C-54, C-15), (C-38, C+65), (C+38, C+65), (C+54, C-15)], dk(ic, 30))
    save_badge(img, 'complete_005')

def complete_006():
    """두 번의 완벽 · epic · two diamonds"""
    img, d, ic = new_badge('epic')
    for ox in [-42, 42]:
        poly(d, [(C+ox, C-52), (C+ox+32, C-10), (C+ox+22, C+52), (C+ox-22, C+52), (C+ox-32, C-10)], ic)
        poly(d, [(C+ox, C-52), (C+ox+32, C-10), (C+ox, C-12)], hi(ic, 45))
    save_badge(img, 'complete_006')

def complete_007():
    """끝까지 · rare · checkered flag"""
    img, d, ic = new_badge('rare')
    rect(d, C-48, C-80, 10, 130, ic)
    sq = 28
    for row in range(3):
        for col in range(4):
            fill = ic if (row+col) % 2 == 0 else dk(ic, 72)
            rect(d, C-38+col*sq, C-80+row*sq, sq, sq, fill)
    save_badge(img, 'complete_007')

def complete_008():
    """삼관왕 · rare · crown"""
    img, d, ic = new_badge('rare')
    rect(d, C-60, C+12, 120, 38, ic)
    poly(d, [(C-60, C+12), (C-38, C+12), (C-48, C-38)], ic)
    poly(d, [(C-15, C+12), (C+15, C+12), (C, C-60)],    ic)
    poly(d, [(C+38, C+12), (C+60, C+12), (C+48, C-38)], ic)
    for cx in [C-40, C, C+40]:
        circle(d, cx, C+28, 8, hi(ic, 50))
    save_badge(img, 'complete_008')

def complete_009():
    """한 해의 왕 · epic · trophy"""
    img, d, ic = new_badge('epic')
    poly(d, [(C-48, C-62), (C+48, C-62), (C+34, C+10), (C-34, C+10)], ic)
    rect(d, C-10, C+10, 20, 26, ic)
    rect(d, C-38, C+36, 76, 16, ic)
    d.arc([C-68, C-54, C-40, C+4],  start=270, end=90,  fill=ic, width=12)
    d.arc([C+40, C-54, C+68, C+4],  start=90,  end=270, fill=ic, width=12)
    poly(d, star_pts(C, C-28, 22, 9, 5), hi(ic, 55))
    save_badge(img, 'complete_009')

def complete_010():
    """전설의 시작 · legendary · shield + star"""
    img, d, ic = new_badge('legendary')
    poly(d, [(C, C+80), (C-65, C+28), (C-65, C-48), (C, C-64), (C+65, C-48), (C+65, C+28)], ic)
    poly(d, [(C, C+55), (C-44, C+18), (C-44, C-28), (C, C-44), (C+44, C-28), (C+44, C+18)], dk(ic, 62))
    poly(d, star_pts(C, C, 28, 11, 5), ic)
    save_badge(img, 'complete_010')

# ── LOGGING (8) ───────────────────────────────────────────────

def log_001():
    """첫 기록 · common · diagonal pencil"""
    img, d, ic = new_badge('common')
    poly(d, [(C+18, C-72), (C+48, C-42), (C-18, C+65), (C-48, C+35)], ic)
    poly(d, [(C-18, C+65), (C+18, C+88), (C-48, C+35)], dk(ic, 65))
    poly(d, [(C+18, C-72), (C+48, C-42), (C+40, C-56), (C+10, C-86)], hi(ic, 48))
    save_badge(img, 'log_001')

def log_002():
    """일주일 일기 · common · notebook"""
    img, d, ic = new_badge('common')
    rrect(d, C-50, C-62, 100, 124, 8, ic)
    rect(d, C-50, C-62, 18, 124, dk(ic, 72))
    for y in [C-32, C-12, C+8, C+28]:
        rect(d, C-24, y, 62, 8, dk(ic, 72))
    save_badge(img, 'log_002')

def log_003():
    """21일 일기 · rare · book + bookmark"""
    img, d, ic = new_badge('rare')
    rrect(d, C-48, C-60, 96, 120, 8, ic)
    rect(d, C-48, C-60, 16, 120, dk(ic, 72))
    for y in [C-32, C-12, C+8, C+28]:
        rect(d, C-24, y, 60, 8, dk(ic, 72))
    poly(d, [(C+22, C-60), (C+44, C-60), (C+44, C-30), (C+33, C-44), (C+22, C-30)], hi(ic, 55))
    save_badge(img, 'log_003')

def log_004():
    """소설가 · rare · open book"""
    img, d, ic = new_badge('rare')
    rrect(d, C-74, C-52, 70, 108, 8, ic)
    rrect(d, C+ 4, C-52, 70, 108, 8, ic)
    for y in [C-30, C-10, C+10, C+30]:
        rect(d, C-64, y, 50, 8, dk(ic, 65))
        rect(d, C+14, y, 50, 8, dk(ic, 65))
    rect(d, C-5, C-55, 10, 114, dk(ic, 65))
    save_badge(img, 'log_004')

def log_005():
    """말이 많은 날 · common · speech bubble"""
    img, d, ic = new_badge('common')
    rrect(d, C-65, C-52, 130, 80, 20, ic)
    poly(d, [(C-30, C+28), (C-52, C+68), (C+6, C+28)], ic)
    for cx in [C-28, C, C+28]:
        circle(d, cx, C-10, 10, dk(ic, 75))
    save_badge(img, 'log_005')

def log_006():
    """돌아보기 · secret · magnifying glass"""
    img, d, ic = new_badge('secret')
    ring(d, C-14, C-14, 52, ic, width=14)
    poly(d, [(C+24, C+22), (C+34, C+12), (C+72, C+58), (C+62, C+68)], ic)
    save_badge(img, 'log_006')

def log_007():
    """연대기 작가 · epic · scroll"""
    img, d, ic = new_badge('epic')
    rrect(d, C-52, C-48, 104, 96, 22, ic)
    d.ellipse([C-52, C-64, C+52, C-32], fill=dk(ic, 68))
    d.ellipse([C-40, C-58, C+40, C-38], fill=ic)
    d.ellipse([C-52, C+32, C+52, C+64], fill=dk(ic, 68))
    d.ellipse([C-40, C+38, C+40, C+58], fill=ic)
    for y in [C-24, C-6, C+12, C+30]:
        rect(d, C-34, y, 68, 7, dk(ic, 68))
    save_badge(img, 'log_007')

def log_008():
    """기억의 수호자 · legendary · folder"""
    img, d, ic = new_badge('legendary')
    rrect(d, C-62, C-50, 60, 28, 8, ic)
    rrect(d, C-62, C-34, 124, 90, 8, ic)
    for y in [C-12, C+10, C+32]:
        rect(d, C-44, y, 80, 8, dk(ic, 65))
    save_badge(img, 'log_008')

# ── TIMING (8) ────────────────────────────────────────────────

def timing_001():
    """새벽 전사 · common · sunrise"""
    img, d, ic = new_badge('common')
    rect(d, C-72, C+22, 144, 10, ic)
    d.pieslice([C-48, C-30, C+48, C+66], start=180, end=360, fill=ic)
    for ang in [-70, -35, 0, 35, 70]:
        a = math.radians(ang - 90)
        d.line([(C+55*math.cos(a), C+22+55*math.sin(a)),
                (C+92*math.cos(a), C+22+92*math.sin(a))],
               fill=ic, width=10)
    save_badge(img, 'timing_001')

def timing_002():
    """아침형 인간 · rare · full sun with 12 rays"""
    img, d, ic = new_badge('rare')
    for i in range(12):
        angle = math.pi * 2 * i / 12
        d.line([(C+50*math.cos(angle), C+50*math.sin(angle)),
                (C+90*math.cos(angle), C+90*math.sin(angle))],
               fill=ic, width=10)
    circle(d, C, C, 42, ic)
    save_badge(img, 'timing_002')

def timing_003():
    """야행성 · common · crescent moon"""
    img, d, ic = new_badge('common')
    circle(d, C, C, 70, ic)
    bg = COLORS['common']['bg']
    circle(d, C+28, C-15, 62, bg)
    save_badge(img, 'timing_003')

def timing_004():
    """칼같은 시간 · rare · stopwatch"""
    img, d, ic = new_badge('rare')
    ring(d, C, C+10, 65, ic, width=12)
    rect(d, C-12, C-55, 24, 18, ic)
    rect(d, C-24, C-64, 18, 14, ic)
    rect(d, C+6,  C-64, 18, 14, ic)
    ln(d, C, C+10, C, C-32, ic, width=13)
    ln(d, C, C+10, C+38, C+10, ic, width=10)
    circle(d, C, C+10, 9, ic)
    save_badge(img, 'timing_004')

def timing_005():
    """주말 전사 · rare · 8-point starburst"""
    img, d, ic = new_badge('rare')
    poly(d, star_pts(C, C, 88, 36, 8), ic)
    circle(d, C, C, 22, hi(ic, 48))
    save_badge(img, 'timing_005')

def timing_006():
    """월화수목금 · rare · briefcase"""
    img, d, ic = new_badge('rare')
    rrect(d, C-60, C-28, 120, 86, 10, ic)
    d.arc([C-26, C-54, C+26, C-14], start=180, end=0, fill=ic, width=13)
    rect(d, C-60, C+8, 120, 10, dk(ic, 65))
    rrect(d, C-13, C+3, 26, 20, 4, dk(ic, 65))
    save_badge(img, 'timing_006')

def timing_007():
    """자정의 약속 · secret · clock at midnight"""
    img, d, ic = new_badge('secret')
    ring(d, C, C, 72, ic, width=12)
    for i in range(4):
        angle = math.pi/2 * i - math.pi/2
        d.line([(C+58*math.cos(angle), C+58*math.sin(angle)),
                (C+72*math.cos(angle), C+72*math.sin(angle))],
               fill=ic, width=10)
    ln(d, C, C, C, C-52, ic, width=14)
    ln(d, C, C, C, C-44, ic, width=10)
    circle(d, C, C, 9, ic)
    save_badge(img, 'timing_007')

def timing_008():
    """신년 첫날 · secret · fireworks"""
    img, d, ic = new_badge('secret')
    bursts = [(C, C-22, 8, 54), (C-52, C+32, 6, 36), (C+52, C+32, 6, 36)]
    for bx, by, n, size in bursts:
        for i in range(n):
            angle = math.pi * 2 * i / n
            d.line([(bx+9*math.cos(angle), by+9*math.sin(angle)),
                    (bx+size*math.cos(angle), by+size*math.sin(angle))],
                   fill=ic, width=8)
        circle(d, bx, by, 9, ic)
    save_badge(img, 'timing_008')

# ── SUBROUTINE (6) ────────────────────────────────────────────

def sub_001():
    """첫 서브루틴 · common · plus sign"""
    img, d, ic = new_badge('common')
    rect(d, C-14, C-68, 28, 136, ic)
    rect(d, C-68, C-14, 136, 28, ic)
    save_badge(img, 'sub_001')

def sub_002():
    """멀티태스커 · rare · three right arrows"""
    img, d, ic = new_badge('rare')
    for dy in [-38, 0, 38]:
        rect(d, C-58, C+dy-7, 88, 14, ic)
        poly(d, [(C+30, C+dy-22), (C+62, C+dy), (C+30, C+dy+22)], ic)
    save_badge(img, 'sub_002')

def sub_003():
    """서브루틴 달인 · epic · three control knobs"""
    img, d, ic = new_badge('epic')
    positions = [(C-55, C-12), (C, C+24), (C+55, C-12)]
    angles    = [math.radians(-55), math.radians(10), math.radians(65)]
    for (cx, cy), ang in zip(positions, angles):
        ring(d, cx, cy, 36, ic, width=10)
        ln(d, cx, cy, int(cx+22*math.cos(ang)), int(cy+22*math.sin(ang)), ic, width=10)
        circle(d, cx, cy, 9, ic)
    save_badge(img, 'sub_003')

def sub_004():
    """동시에 · rare · two lightning bolts"""
    img, d, ic = new_badge('rare')
    for ox in [-32, 32]:
        poly(d, [
            (C+ox+8,  C-72),
            (C+ox-14, C-6),
            (C+ox+6,  C-6),
            (C+ox-8,  C+72),
            (C+ox+20, C+6),
            (C+ox+0,  C+6),
        ], ic)
    save_badge(img, 'sub_004')

def sub_005():
    """모두 완료 · rare · bold checkmark"""
    img, d, ic = new_badge('rare')
    d.line([(C-72, C+5), (C-24, C+52), (C+72, C-55)], fill=ic, width=24)
    save_badge(img, 'sub_005')

def sub_006():
    """궁극의 루틴 · legendary · globe"""
    img, d, ic = new_badge('legendary')
    ring(d, C, C, 72, ic, width=12)
    ln(d, C, C-72, C, C+72, ic, width=8)
    ln(d, C-72, C, C+72, C, ic, width=8)
    d.arc([C-50, C-36, C+50, C+4],  start=0,   end=180, fill=ic, width=8)
    d.arc([C-50, C-4,  C+50, C+36], start=180, end=360, fill=ic, width=8)
    save_badge(img, 'sub_006')

# ── TEAM (6) ──────────────────────────────────────────────────

def team_001():
    """팀 플레이어 · common · two person silhouettes"""
    img, d, ic = new_badge('common')
    circle(d, C-38, C-38, 22, ic)
    rrect(d, C-60, C-4, 44, 56, 12, ic)
    circle(d, C+38, C-38, 22, ic)
    rrect(d, C+16, C-4, 44, 56, 12, ic)
    rect(d, C-15, C+10, 30, 12, ic)
    save_badge(img, 'team_001')

def team_002():
    """팀장 · rare · three chevrons"""
    img, d, ic = new_badge('rare')
    for offset in [0, 30, 58]:
        y = C - 42 + offset
        poly(d, [
            (C-68, y+24), (C, y-22), (C+68, y+24),
            (C+68, y+40), (C, y-6),  (C-68, y+40),
        ], ic)
    save_badge(img, 'team_002')

def team_003():
    """팀 완주 · epic · trophy + three stars"""
    img, d, ic = new_badge('epic')
    poly(d, [(C-44, C-52), (C+44, C-52), (C+32, C+10), (C-32, C+10)], ic)
    rect(d, C-9,  C+10, 18, 24, ic)
    rect(d, C-36, C+34, 72, 15, ic)
    d.arc([C-64, C-45, C-38, C+5],  start=270, end=90,  fill=ic, width=12)
    d.arc([C+38, C-45, C+64, C+5],  start=90,  end=270, fill=ic, width=12)
    for bx in [C-30, C, C+30]:
        poly(d, star_pts(bx, C-68, 12, 5, 5), hi(ic, 55))
    save_badge(img, 'team_003')

def team_004():
    """응원단장 · rare · megaphone"""
    img, d, ic = new_badge('rare')
    poly(d, [(C-65, C-24), (C-65, C+24), (C+24, C+50), (C+24, C-50)], ic)
    for radius in [34, 55, 76]:
        d.arc([C+24-radius//2, C-radius//2, C+24+radius//2, C+radius//2],
              start=300, end=60, fill=ic, width=9)
    rect(d, C-74, C-10, 22, 20, dk(ic, 62))
    save_badge(img, 'team_004')

def team_005():
    """팀 MVP · rare · 5-point star"""
    img, d, ic = new_badge('rare')
    poly(d, star_pts(C, C, 88, 36, 5), ic)
    save_badge(img, 'team_005')

def team_006():
    """전설의 팀 · legendary · three stars"""
    img, d, ic = new_badge('legendary')
    poly(d, star_pts(C-55, C+18, 32, 13, 5), ic)
    poly(d, star_pts(C,    C-15, 54, 22, 5), hi(ic, 42))
    poly(d, star_pts(C+55, C+18, 32, 13, 5), ic)
    save_badge(img, 'team_006')

# ── Main ──────────────────────────────────────────────────────

if __name__ == '__main__':
    print("Generating Streakly badge PNGs...\n")

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
    print(f"\nDone! {count} badges saved to:\n  {OUT_DIR}")
