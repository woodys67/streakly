# 배지 시스템 구현 계획

> 작성일: 2026-06-01  
> 상태: 기획 확정 → 구현 준비 단계

---

## 목차

1. [개요](#1-개요)
2. [배지 전체 목록 (50개)](#2-배지-전체-목록-50개)
3. [아키텍처 설계](#3-아키텍처-설계)
4. [데이터 모델 (Dart)](#4-데이터-모델-dart)
5. [Supabase 스키마](#5-supabase-스키마)
6. [BadgeEvaluator — 판정 로직](#6-badgeevaluator--판정-로직)
7. [BadgeProvider — 상태 관리](#7-badgeprovider--상태-관리)
8. [UI 컴포넌트](#8-ui-컴포넌트)
9. [기존 코드 연동 포인트](#9-기존-코드-연동-포인트)
10. [단계별 구현 로드맵](#10-단계별-구현-로드맵)
11. [로컬/클라우드 이중 저장 전략](#11-로컬클라우드-이중-저장-전략)

---

## 1. 개요

### 목적
- 핵심 앱 루프(스트릭 유지, 챌린지 완주, 로그 기록)를 배지로 직접 보상
- 초반 진입 장벽을 낮추고, 장기 사용자에게 희귀 보상으로 리텐션 유지
- 팀 챌린지 PRO 기능과 연계해 구독 전환 인센티브 제공

### 핵심 설계 원칙

| 원칙 | 설명 |
|---|---|
| **이벤트 기반 평가** | 체크인, 로그 작성, 챌린지 완료 등 특정 이벤트 발생 시에만 배지 조건 검사 |
| **멱등성 보장** | 같은 배지를 중복 수여하지 않음 (`user_badges` 유니크 제약) |
| **오프라인 우선** | 로컬 저장 후 Supabase 동기화, 게스트 유저도 배지 수집 가능 |
| **논블로킹 UI** | 배지 평가는 백그라운드에서 처리, 완료 후 알림 다이얼로그 표시 |

---

## 2. 배지 전체 목록 (50개)

### 희귀도 정의

| 등급 | 코드 | 배경 | 테두리 |
|---|---|---|---|
| ⬜ Common | `common` | `#E8E8E8` | 없음 |
| 🟦 Rare | `rare` | `#DBEAFE` | `#4A90E2` |
| 🟧 Epic | `epic` | `#FFF3E0` | `#FF8C00` |
| 🟨 Legendary | `legendary` | 금 그라데이션 | `#FFD700` |
| ⬛ Secret | `secret` | `#2A2A2A` | 점선 `#555` |

---

### 🔥 Category 1: 스트릭 (12개)

| ID | 배지 이름 | 영문명 | 아이콘 | 획득 조건 | 등급 |
|---|---|---|---|---|---|
| `streak_001` | 첫 불꽃 | First Spark | 🔥 | 첫 스트릭 1일 달성 | Common |
| `streak_002` | 불씨 | Ember | 🔥🔥 | 스트릭 3일 연속 | Common |
| `streak_003` | 작은 불꽃 | Kindling | 🔥🔥🔥 | 스트릭 7일 연속 | Common |
| `streak_004` | 모닥불 | Campfire | 🪵 | 스트릭 14일 연속 | Rare |
| `streak_005` | 화톳불 | Bonfire | 🔥✨ | 스트릭 21일 연속 | Rare |
| `streak_006` | 용광로 | Furnace | ⚡🔥 | 스트릭 30일 연속 | Epic |
| `streak_007` | 불의 지배자 | Fire Lord | 🌋 | 스트릭 50일 연속 | Epic |
| `streak_008` | 태양 | The Sun | ☀️ | 스트릭 66일 연속 (습관 완전 정착) | Epic |
| `streak_009` | 영원한 불꽃 | Eternal Flame | 🌟🔥 | 스트릭 100일 연속 | Legendary |
| `streak_010` | 불사조 | Phoenix | 🦅🔥 | 스트릭이 끊긴 후 재시작해 이전 최고 기록 경신 | Rare |
| `streak_011` | 부활 | Comeback | ↩️🔥 | 스트릭 0에서 7일 이상 회복 | Common |
| `streak_012` | 올해의 불꽃 | Year of Fire | 📅🔥 | 한 해에 누적 스트릭 300일 이상 | Legendary |

> `streak_008` (66일)은 심리학 연구 기반 "습관 완전 정착" 기준점으로 앱 철학과 직결되는 의미 있는 마일스톤.
> `streak_010` (불사조)는 실패 후 재시작을 보상 — 이탈 방지 핵심 배지.

---

### 🏆 Category 2: 챌린지 완주 (10개)

| ID | 배지 이름 | 영문명 | 아이콘 | 획득 조건 | 등급 |
|---|---|---|---|---|---|
| `complete_001` | 첫 완주 | First Finish | 🎯 | 챌린지 최초 1회 완료 | Common |
| `complete_002` | 세 번의 약속 | Triple Vow | 🏅🏅🏅 | 챌린지 3회 완료 | Common |
| `complete_003` | 10전 10승 | Perfect Ten | 🔟 | 챌린지 10회 완료 | Rare |
| `complete_004` | 챌린지 마스터 | Challenge Master | 🎓 | 챌린지 25회 완료 | Epic |
| `complete_005` | 완벽주의자 | Perfectionist | 💎 | 한 챌린지를 완료율 100%로 완주 | Rare |
| `complete_006` | 두 번의 완벽 | Double Perfect | 💎💎 | 완료율 100% 챌린지 2회 연속 | Epic |
| `complete_007` | 끝까지 | All the Way | 🏁 | 28일 이상 커스텀 챌린지 완료 | Rare |
| `complete_008` | 삼관왕 | Triple Crown | 👑 | 서로 다른 목표명으로 각 1회씩 3회 완료 | Rare |
| `complete_009` | 한 해의 왕 | Champion of the Year | 🏆 | 한 해에 챌린지 12회 완료 | Epic |
| `complete_010` | 전설의 시작 | Legend Begins | ⚜️ | 누적 완료율 80% 이상 유지하며 챌린지 20회 완료 | Legendary |

---

### 📝 Category 3: 기록 습관 (8개)

| ID | 배지 이름 | 영문명 | 아이콘 | 획득 조건 | 등급 |
|---|---|---|---|---|---|
| `log_001` | 첫 기록 | First Entry | ✏️ | 데일리 로그 최초 작성 | Common |
| `log_002` | 일주일 일기 | Week Diary | 📒 | 7일 연속 데일리 로그 작성 | Common |
| `log_003` | 21일 일기 | 21-Day Journal | 📔 | 챌린지 21일 동안 매일 로그 작성 | Rare |
| `log_004` | 소설가 | Novelist | 📖 | 누적 데일리 로그 100개 작성 | Rare |
| `log_005` | 말이 많은 날 | Verbose Day | 💬 | 한 번의 로그에 200자 이상 작성 | Common |
| `log_006` | 돌아보기 | Reflector | 🔍 | 완료된 챌린지 로그를 30일 후 다시 열람 | Secret |
| `log_007` | 연대기 작가 | Chronicler | 📜 | 누적 데일리 로그 500개 작성 | Epic |
| `log_008` | 기억의 수호자 | Memory Keeper | 🗂️ | 1년 이상 기간 동안 로그 기록 지속 | Legendary |

---

### ⏰ Category 4: 시간 & 루틴 패턴 (8개)

| ID | 배지 이름 | 영문명 | 아이콘 | 획득 조건 | 등급 |
|---|---|---|---|---|---|
| `timing_001` | 새벽 전사 | Dawn Warrior | 🌅 | 오전 6시 이전 체크인 7회 | Common |
| `timing_002` | 아침형 인간 | Morning Person | ☀️ | 오전 9시 이전 체크인 21회 연속 | Rare |
| `timing_003` | 야행성 | Night Owl | 🌙 | 자정(00:00) 이후 체크인 5회 | Common |
| `timing_004` | 칼같은 시간 | Clockwork | ⏱️ | 알림 시간 ±15분 이내 체크인 10회 | Rare |
| `timing_005` | 주말 전사 | Weekend Warrior | 🎉 | 토+일 연속 체크인 4주 | Rare |
| `timing_006` | 월화수목금 | Weekday Grind | 💼 | 월~금 체크인 4주 연속 | Rare |
| `timing_007` | 자정의 약속 | Midnight Promise | 🕛 | 23:59 이내 체크인 3회 | Secret |
| `timing_008` | 신년 첫날 | New Year, New Me | 🎆 | 1월 1일 체크인 | Secret |

---

### 🧩 Category 5: 서브루틴 (6개)

| ID | 배지 이름 | 영문명 | 아이콘 | 획득 조건 | 등급 |
|---|---|---|---|---|---|
| `sub_001` | 첫 서브루틴 | Sub Starter | ➕ | 서브루틴 포함 챌린지 최초 생성 | Common |
| `sub_002` | 멀티태스커 | Multitasker | 🔀 | 서브루틴 3개 이상 포함 챌린지 완료 | Rare |
| `sub_003` | 서브루틴 달인 | Subroutine Master | 🎛️ | 서브루틴 5개 이상 + 완료율 90% 이상 완주 | Epic |
| `sub_004` | 동시에 | Parallel Runner | ⚡ | 챌린지 2개 동시 진행 중 둘 다 체크인 7일 | Rare |
| `sub_005` | 모두 완료 | Full Sweep | ✅ | 메인+서브 전부 당일 완료 21회 | Rare |
| `sub_006` | 궁극의 루틴 | Ultimate Routine | 🌐 | 서브루틴 5개 포함 챌린지 100% 완료율로 완주 | Legendary |

---

### 👥 Category 6: 팀 챌린지 (6개) — PRO 전용

| ID | 배지 이름 | 영문명 | 아이콘 | 획득 조건 | 등급 |
|---|---|---|---|---|---|
| `team_001` | 팀 플레이어 | Team Player | 🤝 | 팀 챌린지 최초 참가 | Common |
| `team_002` | 팀장 | Squad Leader | 🎖️ | 팀 챌린지 생성 후 완주까지 이끌기 | Rare |
| `team_003` | 팀 완주 | All for One | 🏆👥 | 팀원 전원 챌린지 100% 완료 | Epic |
| `team_004` | 응원단장 | Biggest Fan | 📣 | 하루 팀원 3명 모두 응원 반응 보내기 7일 | Rare |
| `team_005` | 팀 MVP | Team MVP | ⭐ | 팀 챌린지 종료 시 팀 내 1위 | Rare |
| `team_006` | 전설의 팀 | Legendary Crew | 🌟👥 | 같은 팀원과 3회 이상 팀 챌린지 완주 | Legendary |

> 팀 카테고리 배지는 팀 챌린지 기능(Phase 1 별도 개발) 완료 후 활성화.  
> 그 전까지는 컬렉션 화면에서 잠금 상태로 미리 노출 (진입 장벽 → 기대감 형성).

---

### 등급별 분포

| 등급 | 개수 | 비율 |
|---|---|---|
| ⬜ Common | 14 | 28% |
| 🟦 Rare | 19 | 38% |
| 🟧 Epic | 10 | 20% |
| 🟨 Legendary | 6 | 12% |
| ⬛ Secret | 3 | 6% |

---

## 3. 아키텍처 설계

```
┌────────────────────────────────────────────────────────┐
│                     Flutter UI Layer                   │
│  BadgeUnlockDialog  BadgeCollectionScreen  BadgeChip   │
└──────────────────────────┬─────────────────────────────┘
                           │ notifyListeners
┌──────────────────────────▼─────────────────────────────┐
│                     BadgeProvider                      │
│  - earnedBadges: List<UserBadge>                       │
│  - pendingUnlocks: Queue<BadgeDefinition>              │
│  - checkAndAward(BadgeEvent) → List<BadgeDefinition>   │
└──────────────────────────┬─────────────────────────────┘
                           │
┌──────────────────────────▼─────────────────────────────┐
│                    BadgeEvaluator                      │
│  - evaluate(event, context) → List<BadgeDefinition>    │
│  정적 판정 로직 (Supabase/SharedPreferences 미접촉)     │
└──────────────────────────┬─────────────────────────────┘
                           │ 조건 충족 시
┌──────────────────────────▼─────────────────────────────┐
│                    BadgeRepository                     │
│  - saveLocal(UserBadge)   ← SharedPreferences          │
│  - saveCloud(UserBadge)   ← Supabase user_badges       │
│  - loadAll()              ← 로컬 우선, 클라우드 병합    │
└────────────────────────────────────────────────────────┘
```

### 이벤트 흐름

```
사용자 체크인
    └─ ChallengeProvider.toggleDay()
        └─ BadgeProvider.checkAndAward(CheckInEvent)
            └─ BadgeEvaluator.evaluate()
                └─ 조건 충족된 배지 목록 반환
                    └─ BadgeRepository.save() (로컬 + 클라우드)
                        └─ pendingUnlocks 큐에 추가
                            └─ UI: BadgeUnlockDialog 순차 표시
```

---

## 4. 데이터 모델 (Dart)

### BadgeDefinition — 배지 정의 (정적 데이터)

```dart
// lib/models/badge_definition.dart

enum BadgeCategory { streak, completion, logging, timing, subroutine, team }
enum BadgeRarity   { common, rare, epic, legendary, secret }

class BadgeDefinition {
  final String id;          // 'streak_001'
  final String nameKo;      // '첫 불꽃'
  final String nameEn;      // 'First Spark'
  final String icon;        // '🔥'
  final String descKo;      // '첫 스트릭 1일 달성'
  final String descEn;
  final BadgeCategory category;
  final BadgeRarity rarity;
  final bool isSecret;      // true면 조건 설명 숨김

  const BadgeDefinition({
    required this.id,
    required this.nameKo,
    required this.nameEn,
    required this.icon,
    required this.descKo,
    required this.descEn,
    required this.category,
    required this.rarity,
    this.isSecret = false,
  });
}
```

### UserBadge — 사용자 획득 기록

```dart
// lib/models/user_badge.dart

class UserBadge {
  final String badgeId;
  final DateTime earnedAt;

  const UserBadge({required this.badgeId, required this.earnedAt});

  Map<String, dynamic> toJson() => {
    'badge_id': badgeId,
    'earned_at': earnedAt.toIso8601String(),
  };

  factory UserBadge.fromJson(Map<String, dynamic> j) => UserBadge(
    badgeId: j['badge_id'] as String,
    earnedAt: DateTime.parse(j['earned_at'] as String),
  );
}
```

### BadgeEvent — 평가 트리거 이벤트

```dart
// lib/models/badge_event.dart

enum BadgeEventType {
  checkIn,           // 체크인 완료
  challengeCompleted,// 챌린지 완료
  logWritten,        // 데일리 로그 작성
  logViewed,         // 로그 열람 (돌아보기 Secret 배지용)
  subroutineCreated, // 서브루틴 포함 챌린지 생성
  teamJoined,        // 팀 챌린지 참가
  teamCompleted,     // 팀 챌린지 완료
}

class BadgeEvent {
  final BadgeEventType type;
  final DateTime timestamp;
  final Map<String, dynamic> payload; // 이벤트별 추가 데이터

  const BadgeEvent({
    required this.type,
    required this.timestamp,
    this.payload = const {},
  });
}
```

### BadgeEvaluationContext — 판정에 필요한 전체 상태

```dart
// lib/models/badge_evaluation_context.dart

class BadgeEvaluationContext {
  final List<Challenge> allChallenges;      // 전체 챌린지 이력
  final List<UserBadge> earnedBadges;       // 이미 획득한 배지 (중복 방지)
  final BadgeEvent event;                   // 현재 이벤트

  const BadgeEvaluationContext({
    required this.allChallenges,
    required this.earnedBadges,
    required this.event,
  });
}
```

---

## 5. Supabase 스키마

기존 `supabase_setup.sql`에 아래 내용을 추가합니다.

```sql
-- ────────────────────────────────────────
-- 배지 시스템 테이블
-- ────────────────────────────────────────

-- 사용자 획득 배지 기록
CREATE TABLE IF NOT EXISTS public.user_badges (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  badge_id   text        NOT NULL,          -- 'streak_001' 등 클라이언트 정의 ID
  earned_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, badge_id)                -- 중복 수여 방지
);

-- 대표 배지 설정 (프로필/팀 화면 노출용)
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS featured_badge_id text;

-- RLS
ALTER TABLE public.user_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_badges: 본인만 조회"
  ON public.user_badges FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "user_badges: 본인만 삽입"
  ON public.user_badges FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- 인덱스
CREATE INDEX IF NOT EXISTS idx_user_badges_user
  ON public.user_badges (user_id, earned_at DESC);
```

### 로컬 저장 키 (SharedPreferences)

```
user_badges          → JSON 배열 [{badge_id, earned_at}, ...]
featured_badge_id    → String
```

---

## 6. BadgeEvaluator — 판정 로직

순수 함수 형태로 구현 — 외부 I/O 없이 `BadgeEvaluationContext`만으로 판정.

```dart
// lib/services/badge_evaluator.dart

class BadgeEvaluator {
  static List<BadgeDefinition> evaluate(BadgeEvaluationContext ctx) {
    final earned = <BadgeDefinition>[];

    for (final badge in BadgeCatalog.all) {
      // 이미 획득한 배지 건너뜀
      if (ctx.earnedBadges.any((b) => b.badgeId == badge.id)) continue;

      if (_check(badge, ctx)) {
        earned.add(badge);
      }
    }
    return earned;
  }

  static bool _check(BadgeDefinition badge, BadgeEvaluationContext ctx) {
    final challenges = ctx.allChallenges;
    final event = ctx.event;

    switch (badge.id) {

      // ── 스트릭 ──────────────────────────────────────
      case 'streak_001': // 첫 불꽃 — 스트릭 1일
        return _maxStreakAcrossAll(challenges) >= 1;

      case 'streak_002': // 불씨 — 3일
        return _maxStreakAcrossAll(challenges) >= 3;

      case 'streak_003': // 작은 불꽃 — 7일
        return _maxStreakAcrossAll(challenges) >= 7;

      case 'streak_004': // 모닥불 — 14일
        return _maxStreakAcrossAll(challenges) >= 14;

      case 'streak_005': // 화톳불 — 21일
        return _maxStreakAcrossAll(challenges) >= 21;

      case 'streak_006': // 용광로 — 30일
        return _maxStreakAcrossAll(challenges) >= 30;

      case 'streak_007': // 불의 지배자 — 50일
        return _maxStreakAcrossAll(challenges) >= 50;

      case 'streak_008': // 태양 — 66일
        return _maxStreakAcrossAll(challenges) >= 66;

      case 'streak_009': // 영원한 불꽃 — 100일
        return _maxStreakAcrossAll(challenges) >= 100;

      case 'streak_010': // 불사조 — 이전 최고 기록 경신
        return event.type == BadgeEventType.checkIn &&
               (event.payload['prevBestStreak'] as int? ?? 0) > 0 &&
               _maxStreakAcrossAll(challenges) >
               (event.payload['prevBestStreak'] as int);

      case 'streak_011': // 부활 — 끊긴 후 7일 회복
        return event.type == BadgeEventType.checkIn &&
               (event.payload['streakBrokeRecently'] as bool? ?? false) &&
               _maxStreakAcrossAll(challenges) >= 7;

      case 'streak_012': // 올해의 불꽃 — 한 해 누적 300일
        return _yearlyStreakTotal(challenges, DateTime.now().year) >= 300;

      // ── 완주 ────────────────────────────────────────
      case 'complete_001': // 첫 완주
        return challenges.where((c) => c.isCompleted).length >= 1;

      case 'complete_002': // 세 번의 약속
        return challenges.where((c) => c.isCompleted).length >= 3;

      case 'complete_003': // 10전 10승
        return challenges.where((c) => c.isCompleted).length >= 10;

      case 'complete_004': // 챌린지 마스터
        return challenges.where((c) => c.isCompleted).length >= 25;

      case 'complete_005': // 완벽주의자 — 완료율 100%
        return challenges.any((c) => c.isCompleted && c.successRate == 1.0);

      case 'complete_006': // 두 번의 완벽 — 100% 연속 2회
        return _consecutivePerfect(challenges) >= 2;

      case 'complete_007': // 끝까지 — 28일 이상
        return challenges.any((c) => c.isCompleted && c.targetDays >= 28);

      case 'complete_008': // 삼관왕 — 다른 목표명 3개
        return _distinctCompletedNames(challenges) >= 3;

      case 'complete_009': // 한 해의 왕 — 연간 12회
        return _completedInYear(challenges, DateTime.now().year) >= 12;

      case 'complete_010': // 전설의 시작
        final completed = challenges.where((c) => c.isCompleted).toList();
        if (completed.length < 20) return false;
        final avgRate = completed.fold<double>(
          0, (s, c) => s + c.successRate) / completed.length;
        return avgRate >= 0.8;

      // ── 로그 ────────────────────────────────────────
      case 'log_001': // 첫 기록
        return _totalLogCount(challenges) >= 1;

      case 'log_002': // 일주일 일기 — 7일 연속
        return event.type == BadgeEventType.logWritten &&
               (event.payload['consecutiveLogDays'] as int? ?? 0) >= 7;

      case 'log_003': // 21일 일기
        return event.type == BadgeEventType.logWritten &&
               (event.payload['consecutiveLogDays'] as int? ?? 0) >= 21;

      case 'log_004': // 소설가 — 누적 100개
        return _totalLogCount(challenges) >= 100;

      case 'log_005': // 말이 많은 날 — 200자 이상
        return event.type == BadgeEventType.logWritten &&
               (event.payload['contentLength'] as int? ?? 0) >= 200;

      case 'log_006': // 돌아보기 (Secret)
        return event.type == BadgeEventType.logViewed &&
               (event.payload['daysSinceCompletion'] as int? ?? 0) >= 30;

      case 'log_007': // 연대기 작가 — 누적 500개
        return _totalLogCount(challenges) >= 500;

      case 'log_008': // 기억의 수호자 — 1년 이상 로그
        return _logSpanDays(challenges) >= 365;

      // ── 타이밍 ──────────────────────────────────────
      case 'timing_001': // 새벽 전사 — 6시 이전 7회
        return event.type == BadgeEventType.checkIn &&
               event.timestamp.hour < 6 &&
               (event.payload['earlyCheckinCount'] as int? ?? 0) >= 7;

      case 'timing_002': // 아침형 인간 — 9시 이전 21회 연속
        return event.type == BadgeEventType.checkIn &&
               (event.payload['morningCheckinStreak'] as int? ?? 0) >= 21;

      case 'timing_003': // 야행성 — 자정 이후 5회
        return event.type == BadgeEventType.checkIn &&
               event.timestamp.hour == 0 &&
               (event.payload['lateNightCheckinCount'] as int? ?? 0) >= 5;

      case 'timing_004': // 칼같은 시간 — ±15분 이내 10회
        return event.type == BadgeEventType.checkIn &&
               (event.payload['onTimeCheckinCount'] as int? ?? 0) >= 10;

      case 'timing_005': // 주말 전사 — 4주 연속 토+일
        return event.type == BadgeEventType.checkIn &&
               (event.payload['weekendStreakWeeks'] as int? ?? 0) >= 4;

      case 'timing_006': // 월화수목금 — 4주 연속 평일
        return event.type == BadgeEventType.checkIn &&
               (event.payload['weekdayStreakWeeks'] as int? ?? 0) >= 4;

      case 'timing_007': // 자정의 약속 (Secret) — 23:59 체크인 3회
        return event.type == BadgeEventType.checkIn &&
               event.timestamp.hour == 23 &&
               event.timestamp.minute == 59 &&
               (event.payload['midnightCheckinCount'] as int? ?? 0) >= 3;

      case 'timing_008': // 신년 첫날 (Secret) — 1월 1일
        return event.type == BadgeEventType.checkIn &&
               event.timestamp.month == 1 &&
               event.timestamp.day == 1;

      // ── 서브루틴 ────────────────────────────────────
      case 'sub_001': // 첫 서브루틴
        return event.type == BadgeEventType.subroutineCreated;

      case 'sub_002': // 멀티태스커
        return challenges.any((c) => c.isCompleted && c.subRoutines.length >= 3);

      case 'sub_003': // 서브루틴 달인
        return challenges.any((c) =>
          c.isCompleted &&
          c.subRoutines.length >= 5 &&
          c.successRate >= 0.9);

      case 'sub_004': // 동시에 — 2개 동시 진행 7일
        return event.type == BadgeEventType.checkIn &&
               (event.payload['parallelCheckinDays'] as int? ?? 0) >= 7;

      case 'sub_005': // 모두 완료 — 메인+서브 전부 21회
        return event.type == BadgeEventType.checkIn &&
               (event.payload['fullSweepCount'] as int? ?? 0) >= 21;

      case 'sub_006': // 궁극의 루틴
        return challenges.any((c) =>
          c.isCompleted &&
          c.subRoutines.length >= 5 &&
          c.successRate == 1.0);

      // ── 팀 챌린지 ───────────────────────────────────
      case 'team_001':
        return event.type == BadgeEventType.teamJoined;

      case 'team_002':
        return event.type == BadgeEventType.teamCompleted &&
               (event.payload['wasLeader'] as bool? ?? false);

      case 'team_003':
        return event.type == BadgeEventType.teamCompleted &&
               (event.payload['allMembersCompleted'] as bool? ?? false);

      case 'team_004':
        return event.type == BadgeEventType.checkIn &&
               (event.payload['cheerleaderDays'] as int? ?? 0) >= 7;

      case 'team_005':
        return event.type == BadgeEventType.teamCompleted &&
               (event.payload['teamRank'] as int? ?? 99) == 1;

      case 'team_006':
        return event.type == BadgeEventType.teamCompleted &&
               (event.payload['repeatTeamCompletions'] as int? ?? 0) >= 3;

      default:
        return false;
    }
  }

  // ── 헬퍼 ───────────────────────────────────────────────

  static int _maxStreakAcrossAll(List<Challenge> challenges) =>
    challenges.fold(0, (max, c) => c.streak > max ? c.streak : max);

  static int _yearlyStreakTotal(List<Challenge> challenges, int year) {
    return challenges
      .where((c) => c.startDate.year == year)
      .fold(0, (sum, c) => sum + c.completedDays.length);
  }

  static int _consecutivePerfect(List<Challenge> challenges) {
    final completed = challenges
      .where((c) => c.isCompleted)
      .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    int consecutive = 0, max = 0;
    for (final c in completed) {
      if (c.successRate == 1.0) {
        consecutive++;
        if (consecutive > max) max = consecutive;
      } else {
        consecutive = 0;
      }
    }
    return max;
  }

  static int _distinctCompletedNames(List<Challenge> challenges) =>
    challenges.where((c) => c.isCompleted).map((c) => c.name).toSet().length;

  static int _completedInYear(List<Challenge> challenges, int year) =>
    challenges.where((c) => c.isCompleted && c.startDate.year == year).length;

  static int _totalLogCount(List<Challenge> challenges) =>
    challenges.fold(0, (sum, c) => sum + c.logs.length);

  static int _logSpanDays(List<Challenge> challenges) {
    final allLogs = challenges.expand((c) => c.logs).toList();
    if (allLogs.isEmpty) return 0;
    allLogs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return allLogs.last.timestamp
      .difference(allLogs.first.timestamp).inDays;
  }
}
```

---

## 7. BadgeProvider — 상태 관리

```dart
// lib/providers/badge_provider.dart

class BadgeProvider extends ChangeNotifier {
  List<UserBadge> _earned = [];
  final Queue<BadgeDefinition> _pendingUnlocks = Queue();

  List<UserBadge> get earned => _earned;
  bool get hasPendingUnlock => _pendingUnlocks.isNotEmpty;
  BadgeDefinition? get nextUnlock => _pendingUnlocks.isNotEmpty
    ? _pendingUnlocks.first : null;

  Future<void> load() async {
    _earned = await BadgeRepository.loadAll();
    notifyListeners();
  }

  /// ChallengeProvider에서 이벤트 발생 시 호출
  Future<void> checkAndAward(
    BadgeEvent event,
    List<Challenge> challenges,
  ) async {
    final ctx = BadgeEvaluationContext(
      allChallenges: challenges,
      earnedBadges: _earned,
      event: event,
    );

    final newBadges = BadgeEvaluator.evaluate(ctx);
    if (newBadges.isEmpty) return;

    for (final badge in newBadges) {
      final userBadge = UserBadge(
        badgeId: badge.id,
        earnedAt: DateTime.now(),
      );
      await BadgeRepository.save(userBadge);
      _earned = [..._earned, userBadge];
      _pendingUnlocks.add(badge);
    }

    notifyListeners();
  }

  void consumeNextUnlock() {
    if (_pendingUnlocks.isNotEmpty) {
      _pendingUnlocks.removeFirst();
      notifyListeners();
    }
  }
}
```

### BadgeRepository

```dart
// lib/services/badge_repository.dart

class BadgeRepository {
  static const _localKey = 'user_badges';

  static Future<List<UserBadge>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final local = _loadLocal(prefs);

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.isAnonymous == true) return local;

    try {
      final rows = await Supabase.instance.client
        .from('user_badges')
        .select('badge_id, earned_at')
        .eq('user_id', user.id);
      final cloud = (rows as List)
        .map((r) => UserBadge.fromJson(r as Map<String, dynamic>))
        .toList();
      return _merge(local, cloud);
    } catch (_) {
      return local;
    }
  }

  static Future<void> save(UserBadge badge) async {
    // 로컬 먼저 저장
    final prefs = await SharedPreferences.getInstance();
    final current = _loadLocal(prefs);
    if (current.any((b) => b.badgeId == badge.badgeId)) return;
    current.add(badge);
    await prefs.setString(_localKey,
      jsonEncode(current.map((b) => b.toJson()).toList()));

    // 클라우드 동기화 (로그인 유저만)
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.isAnonymous == true) return;
    try {
      await Supabase.instance.client.from('user_badges').upsert({
        'user_id': user.id,
        'badge_id': badge.badgeId,
        'earned_at': badge.earnedAt.toIso8601String(),
      }, onConflict: 'user_id,badge_id');
    } catch (_) {
      // 클라우드 실패 시 로컬에는 저장돼 있으므로 무시
    }
  }

  static List<UserBadge> _loadLocal(SharedPreferences prefs) {
    final raw = prefs.getString(_localKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
      .map((e) => UserBadge.fromJson(e as Map<String, dynamic>))
      .toList();
  }

  static List<UserBadge> _merge(List<UserBadge> local, List<UserBadge> cloud) {
    final map = <String, UserBadge>{};
    for (final b in [...local, ...cloud]) {
      map[b.badgeId] = b;
    }
    return map.values.toList();
  }
}
```

---

## 8. UI 컴포넌트

### 8.1 BadgeUnlockDialog

```
┌─────────────────────────────────┐
│                                 │
│         🎉 배지 획득!            │
│                                 │
│    ┌─────────────────────┐      │
│    │   ╔═══════════╗    │      │
│    │   ║           ║    │      │  ← 등급별 테두리 색상
│    │   ║    🔥✨   ║    │      │    + 획득 시 골드 펄스 애니메이션
│    │   ║           ║    │      │
│    │   ╚═══════════╝    │      │
│    └─────────────────────┘      │
│                                 │
│        화톳불 / Bonfire          │
│        🟦 Rare                  │
│                                 │
│    스트릭 21일 연속 달성 완료!   │
│                                 │
│  ┌──────────┐   ┌───────────┐   │
│  │ 공유하기 │   │   확인    │   │
│  └──────────┘   └───────────┘   │
│                                 │
└─────────────────────────────────┘
```

- 배지 카드 진입 애니메이션: 아래에서 스케일 업 (`ScaleTransition`)
- 배경 오버레이: 반투명 블러 (`BackdropFilter`)
- 여러 배지 동시 획득 시: 큐를 소비하며 순차 표시
- "공유하기": 배지 이름 + 앱 링크 텍스트 공유 (`Share.share`)

### 8.2 BadgeCollectionScreen — 기록 탭 내 섹션

```
┌─────────────────────────────────┐
│  ←  배지 컬렉션     14 / 50    │
│                                 │
│  카테고리 필터                  │
│  [전체] [스트릭] [완주] [로그]  │
│  [타이밍] [서브루틴] [팀]       │
│                                 │
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐     │
│  │🔥│ │🔥│ │🔥│ │🪵│ │🔥│     │  ← 획득: 풀 컬러
│  │  │ │  │ │  │ │  │ │✨│     │
│  └──┘ └──┘ └──┘ └──┘ └──┘     │
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐     │
│  │░░│ │░░│ │░░│ │???│ │░░│     │  ← 미획득: 흑백
│  │  │ │  │ │  │ │   │ │  │     │  ← Secret: 블러 + ???
│  └──┘ └──┘ └──┘ └──┘ └──┘     │
│                                 │
│  (배지 탭 시 상세 팝업 표시)    │
└─────────────────────────────────┘
```

**배지 그리드 상세:**
- 4열 그리드, 각 셀 72×72px
- 획득 배지 탭 → 이름, 설명, 획득 날짜 보텀시트
- 미획득 탭 → 조건 힌트 (Secret은 "???" 표시)
- 진행 표시 바: "14 / 50 획득"

### 8.3 ProfileBadgeRow — 기록 탭 프로필 영역

```
┌───────────────────────────────────────┐
│  🟠  우디        습관 형성자           │
│                                       │
│  최근 획득 배지                        │
│  [🔥✨ 화톳불]  [🎯 첫 완주]  [📒 ...]│
│                                       │
│  대표 배지: [🔥✨ 화톳불  ✏️ 변경]    │
└───────────────────────────────────────┘
```

- 최근 획득 배지 3개 표시 (획득일 내림차순)
- "대표 배지" 1개 선택 → 팀 챌린지 화면에서 이름 옆 노출

### 8.4 BadgeChip — 팀 화면 인라인 표시

```dart
// 팀원 이름 옆에 작게 표시
Row(children: [
  Text('우디'),
  const SizedBox(width: 4),
  BadgeChip(badgeId: user.featuredBadgeId), // 🔥✨ 16px 아이콘 + 배지명
])
```

---

## 9. 기존 코드 연동 포인트

배지 평가는 다음 4곳에서만 `BadgeProvider.checkAndAward()`를 호출합니다.

### 9.1 체크인 — `challenge_provider.dart` `toggleDay()`

```dart
// ChallengeProvider.toggleDay() 말미에 추가
final event = BadgeEvent(
  type: BadgeEventType.checkIn,
  timestamp: DateTime.now(),
  payload: {
    'prevBestStreak': _prevBestStreak,          // 이전 최고 스트릭
    'streakBrokeRecently': _streakBrokeRecently,
    'earlyCheckinCount': _earlyCheckinCount,
    'morningCheckinStreak': _morningCheckinStreak,
    // ... 기타 타이밍 카운터
  },
);
await badgeProvider.checkAndAward(event, _challenges);
```

### 9.2 챌린지 완료 — `challenge_provider.dart` `markCompleted()`

```dart
final event = BadgeEvent(
  type: BadgeEventType.challengeCompleted,
  timestamp: DateTime.now(),
  payload: {},
);
await badgeProvider.checkAndAward(event, _challenges);
```

### 9.3 로그 작성 — `challenge_provider.dart` `addLog()`

```dart
final event = BadgeEvent(
  type: BadgeEventType.logWritten,
  timestamp: DateTime.now(),
  payload: {
    'contentLength': content.length,
    'consecutiveLogDays': _consecutiveLogDays(challengeId),
  },
);
await badgeProvider.checkAndAward(event, _challenges);
```

### 9.4 완료 챌린지 로그 열람 — `challenge_screen.dart`

```dart
// 완료된 챌린지의 로그 섹션 진입 시
if (challenge.isCompleted) {
  final daysSince = DateTime.now()
    .difference(challenge.startDate.add(
      Duration(days: challenge.targetDays))).inDays;
  final event = BadgeEvent(
    type: BadgeEventType.logViewed,
    timestamp: DateTime.now(),
    payload: {'daysSinceCompletion': daysSince},
  );
  context.read<BadgeProvider>().checkAndAward(event, allChallenges);
}
```

### `main.dart` / `app.dart` Provider 등록

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ChallengeProvider()),
    ChangeNotifierProvider(create: (_) => BadgeProvider()),   // 추가
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => SettingsProvider()),
  ],
)
```

### BadgeUnlockDialog 표시 위치

```dart
// home_screen.dart 또는 app.dart 최상위 Scaffold 위에서 리스닝
Consumer<BadgeProvider>(
  builder: (context, badgeProvider, _) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (badgeProvider.hasPendingUnlock) {
        showDialog(
          context: context,
          builder: (_) => BadgeUnlockDialog(
            badge: badgeProvider.nextUnlock!,
            onDismiss: () => badgeProvider.consumeNextUnlock(),
          ),
        );
      }
    });
    return const SizedBox.shrink();
  },
)
```

---

## 10. 단계별 구현 로드맵

### Phase 1 — 핵심 인프라 + 스트릭/완주 배지 (3주)

| 주차 | 작업 |
|---|---|
| 1주 | `BadgeDefinition`, `UserBadge`, `BadgeEvent` 모델 작성 |
| 1주 | `BadgeCatalog` (50개 정의), `BadgeRepository` (로컬 저장) |
| 2주 | `BadgeEvaluator` 스트릭/완주 카테고리 로직 구현 |
| 2주 | `BadgeProvider` + `ChallengeProvider` 연동 |
| 3주 | `BadgeUnlockDialog` UI + 애니메이션 |
| 3주 | `BadgeCollectionScreen` 기본 그리드 (기록 탭 내 섹션으로) |

**목표**: 앱 설치 → 첫 체크인 → "첫 불꽃" 배지 획득까지 동작

### Phase 2 — 로그/타이밍/서브루틴 배지 + Supabase 동기화 (2주)

| 주차 | 작업 |
|---|---|
| 4주 | `BadgeEvaluator` 로그/타이밍/서브루틴 카테고리 추가 |
| 4주 | 타이밍 카운터 상태 관리 (`SharedPreferences`에 누적값 저장) |
| 5주 | Supabase `user_badges` 테이블 생성 + RLS 적용 |
| 5주 | `BadgeRepository` 클라우드 동기화 구현 |

### Phase 3 — UI 완성 + Secret 배지 + 프로필 연동 (1주)

| 작업 |
|---|
| `ProfileBadgeRow` 컴포넌트 → 기록 탭 프로필 영역에 통합 |
| "대표 배지" 선택 기능 + Supabase `featured_badge_id` 저장 |
| Secret 배지 블러 처리 + "???" UI |
| 배지 상세 보텀시트 (획득 날짜, 설명, 공유) |
| 카테고리 필터 탭 |

### Phase 4 — 팀 배지 활성화 (팀 챌린지 기능 출시 후)

팀 챌린지 구현 완료 시점에 `team_001` ~ `team_006` 배지 활성화.  
그 전까지는 컬렉션 화면에 잠금 상태로 미리 노출.

---

## 11. 로컬/클라우드 이중 저장 전략

기존 챌린지 데이터와 동일한 전략을 적용합니다.

| 상태 | 저장 위치 | 설명 |
|---|---|---|
| 게스트/익명 유저 | SharedPreferences만 | 로그인 시 마이그레이션 |
| 로그인 유저 | SharedPreferences + Supabase | 로컬 우선 저장, 비동기 클라우드 업로드 |
| 오프라인 상태 | SharedPreferences만 | 온라인 복구 시 자동 업로드 |
| 재로그인/기기 변경 | Supabase에서 풀 다운 | 로컬이 비어 있을 때 클라우드 우선 |

### 로그인 시 마이그레이션 (`MigrationService` 확장)

```dart
// migration_service.dart 에 추가
Future<void> migrateLocalBadgesToCloud(String userId) async {
  final local = await BadgeRepository.loadLocalOnly();
  for (final badge in local) {
    await BadgeRepository.saveToCloud(badge, userId);
  }
}
```

---

*관련 문서: [BADGE_SYSTEM_PLAN.md](BADGE_SYSTEM_PLAN.md) | [TEAM_CHALLENGE_PLAN.md](TEAM_CHALLENGE_PLAN.md)*
