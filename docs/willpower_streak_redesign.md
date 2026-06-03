# 의지력 & 스트릭 시스템 리디자인 구현 스펙

## 결정 사항 요약

- 홈 화면 StreakCard → **누적 의지력 점수** 표시 (패널티 없음, 항상 증가)
- 챌린지 화면 → **개별 챌린지 연속 스트릭** 더 돋보이게 개선
- 패널티 시스템: **미적용** (추후 재검토 가능)

---

## 1. 의지력(Willpower) 점수

### 정의
모든 챌린지에서 완료한 날의 총합. 한 번 쌓이면 절대 줄지 않음.

### 계산 방식
```dart
// ChallengeProvider에 추가할 게터
int get willpower =>
    _challenges.fold(0, (sum, c) => sum + c.completedDays.length);
```

### 규칙
- 챌린지 1개에서 하루 완료 = +1점
- 챌린지 3개를 동시에 진행하며 모두 완료 = +3점/일
- 서브루틴 있는 챌린지: 모든 서브루틴 완료 시에만 +1점 (기존 완료 조건과 동일)
- 패널티 없음 — 미완료일은 그냥 0점 (감점 없음)

---

## 2. 홈 화면 StreakCard 변경

### 현재
- `challenge.streak` (첫 번째 챌린지의 연속 일수) 표시

### 변경 후
- 상단: **의지력 총점** (크게)
- 하단: 기존 7일 도트 유지 (첫 번째 챌린지 기준)

### 와이어프레임
```
┌─────────────────────────────────┐
│ ⚡  의지력 247                   │
│     누적 달성 점수               │
│                                 │
│  ●  ●  ●  ●  ●  ●  ○           │
│ D1 D2 D3 D4 D5 D6 D7           │
└─────────────────────────────────┘
```

### 수정 파일
`lib/widgets/streak_card.dart`
- `challenge.streak` → `provider.willpower` 로 교체
- 라벨: `s.currentStreak` → "의지력" 또는 `s.willpower` (다국어 대응 필요)

---

## 3. 챌린지 화면 스트릭 뱃지 개선

### 현재
- 작은 초록 칩: `"1일 연속! 🔥"`

### 변경 후
- 칩을 카드형 2분할로 확장:

```
┌─────────────────┐  ┌──────────────────┐
│ 🔥 3일 연속      │  │ ⚡ 의지력 +12    │
│ (주황 테두리)    │  │ (연한 주황 배경)  │
└─────────────────┘  └──────────────────┘
```

### 수정 파일
`lib/screens/challenge/challenge_screen.dart`
- 기존 스트릭 칩 위젯 찾아서 2-slot Row로 교체
- 왼쪽: `challenge.streak`일 연속 🔥
- 오른쪽: 해당 챌린지의 `completedDays.length` (개별 챌린지 누적 점수)

---

## 4. 다국어 문자열 추가 필요

`lib/l10n/app_strings.dart` 에 추가:

| 키 | 한국어 | 영어 |
|----|--------|------|
| `willpower` | 의지력 | Willpower |
| `willpowerScore` | 의지력 {score}점 | {score} Willpower |
| `challengePoints` | +{n}점 | +{n} pts |

---

## 5. 작업 순서 (권장)

1. `ChallengeProvider`에 `willpower` 게터 추가
2. `app_strings.dart`에 다국어 문자열 추가
3. `streak_card.dart` — 홈 화면 StreakCard 수정
4. `challenge_screen.dart` — 챌린지 화면 스트릭 뱃지 개선
5. 앱 실행 후 홈/챌린지 화면 시각 확인

---

## 6. 변경되지 않는 것

- `challenge.streak` 연산 로직 — 그대로 유지
- `completedDays` 데이터 구조 — 그대로 유지
- 배지(Badge) 시스템 — `_maxStreakAcrossAll()` 기준 그대로
- 서브루틴 완료 조건 — 그대로

---

## 참고 파일 위치

| 파일 | 역할 |
|------|------|
| `lib/widgets/streak_card.dart` | 홈 화면 스트릭 카드 UI |
| `lib/screens/challenge/challenge_screen.dart` | 챌린지 상세 화면 |
| `lib/providers/challenge_provider.dart:57` | `totalStreak` → `willpower`로 대체 또는 병행 |
| `lib/l10n/app_strings.dart` | 다국어 문자열 |
| `lib/models/challenge.dart:40` | `streak` getter (변경 없음) |
