# 출시 준비 체크리스트

> 작성일: 2026-06-02  
> 최종 업데이트: 2026-06-25  
> 분석 기준: 싱글 챌린지 모드 현재 구현 상태  
> 전체 완성도: **약 95%** (출시 전 필수·권장 항목 전부 완료)

---

## 요약

| 구분 | 항목 수 | 상태 |
|---|---|---|
| 🔴 출시 전 필수 수정 | 4개 | ✅ 전부 완료 |
| 🟡 출시 전 권장 수정 | 2개 | ✅ 전부 완료 |
| 🟢 출시 후 개선 | 4개 | 미착수 |

---

## 🔴 출시 전 필수 수정

---

### [P1-1] 알림 기능 구현

**현황**: UI만 존재, 실제 알림 미작동  
**예상 작업량**: 대 (반나절~1일)

#### 문제점
- `pubspec.yaml`에 `flutter_local_notifications` 패키지 없음
- AppBar 알림 아이콘 버튼이 빈 함수 (`onPressed: () {}`)
- 설정 화면 알림 토글은 저장만 되고 실제 스케줄링 없음
- 챌린지 생성 시 입력한 `reminderTime`이 알림으로 연결되지 않음

#### 수정 위치

```
pubspec.yaml                           ← 패키지 추가
lib/services/notification_service.dart ← 신규 생성 필요
lib/providers/challenge_provider.dart  ← addChallenge(), toggleTodayComplete() 연동
lib/screens/home/home_screen.dart      ← AppBar 알림 아이콘 (line 33)
lib/screens/settings/settings_screen.dart ← 알림 토글 연동
```

#### 구현 명세

```yaml
# pubspec.yaml 추가
dependencies:
  flutter_local_notifications: ^18.0.0
  timezone: ^0.9.4
```

```dart
// lib/services/notification_service.dart — 신규 생성
class NotificationService {
  // 초기화 (main.dart에서 호출)
  static Future<void> init() async { ... }

  // 챌린지 알림 등록
  // reminderTime: "07:30 AM" 형식 → TimeOfDay로 파싱
  // repeatDays: [0,1,2,3,4] → 요일별 반복
  static Future<void> scheduleChallenge(Challenge c) async { ... }

  // 챌린지 알림 취소
  static Future<void> cancelChallenge(String challengeId) async { ... }

  // 알림 전체 취소 (앱 리셋 시)
  static Future<void> cancelAll() async { ... }
}
```

**연동 포인트**:
- `addChallenge()` 완료 후 → `NotificationService.scheduleChallenge()`
- `deleteChallenge()` 후 → `NotificationService.cancelChallenge()`
- `toggleNotifications()` → false 시 `cancelAll()`, true 시 전체 재등록
- `settings_screen.dart:32` 알림 아이콘 → 알림 목록 화면 또는 설정 탭으로 이동

---

### [P1-2] 완료된 챌린지 상세 화면 연결

**현황**: `>` 아이콘이 있으나 탭해도 아무 반응 없음  
**예상 작업량**: 소 (1~2시간)

#### 문제점

```dart
// lib/screens/records/records_screen.dart:369
// _CompletedChallengeCard에 onTap이 없어 chevron이 장식에 불과
const Icon(Icons.chevron_right, color: AppColors.textSecondary),
```

#### 수정 방법 (2가지 옵션)

**옵션 A (권장)**: 완료 챌린지 전용 상세 화면 신규 생성
```
lib/screens/records/completed_challenge_detail_screen.dart ← 신규 생성
```
표시 내용: 챌린지명, 기간, 완료율, 21일 달력 그리드(읽기 전용), 데일리 로그 목록

**옵션 B (빠른 수정)**: 기존 `ChallengeScreen`을 읽기 전용 모드로 재활용
```dart
// _CompletedChallengeCard를 GestureDetector로 감싸고
// ChallengeScreen(readOnly: true)로 push
```

#### 수정 위치
```
lib/screens/records/records_screen.dart
  └─ _CompletedChallengeCard (line 311~377)
     └─ Container를 GestureDetector/InkWell로 감싸 onTap 추가
```

---

### [P1-3] 하드코딩 한국어 텍스트 다국어 처리

**현황**: 9개 언어 지원 앱인데 일부 UI 문자열이 한국어로 하드코딩  
**예상 작업량**: 소 (1~2시간)

#### 수정 대상 목록

| 파일 | 라인 | 하드코딩 텍스트 | 처리 방법 |
|---|---|---|---|
| `settings_screen.dart` | 290 | `'로그인 / 회원가입'` | `AppStrings`에 키 추가 |
| `settings_screen.dart` | 368 | `'프로필 이미지 선택'` | `AppStrings`에 키 추가 |
| `settings_screen.dart` | 541 | `'팀 챌린지를 이용하려면\n계정이 필요합니다.'` | `AppStrings`에 키 추가 |
| `settings_screen.dart` | 565 | `'회원가입하기'` | `AppStrings`에 키 추가 (signUp 키 재사용 가능) |
| `settings_screen.dart` | 581 | `'이미 계정이 있어요'` | `AppStrings`에 키 추가 |
| `auth_provider.dart` | 81 | Supabase 대시보드 안내 메시지 노출 | 사용자 친화적 메시지로 교체 |
| `auth_provider.dart` | 116 | `'이메일 인증이 필요합니다...'` | `AppStrings`에 키 추가 |

#### `app_strings.dart`에 추가할 키 (예시)

```dart
String get loginOrSignUp => _s(
  en: 'Log in / Sign up', ko: '로그인 / 회원가입',
  ja: 'ログイン / 新規登録', zhCN: '登录 / 注册', zhTW: '登入 / 註冊',
  es: 'Iniciar sesión / Registrarse', de: 'Anmelden / Registrieren',
  pt: 'Entrar / Registrar', ru: 'Войти / Зарегистрироваться',
);

String get selectProfileImage => _s(
  en: 'Select Profile Image', ko: '프로필 이미지 선택',
  ja: 'プロフィール画像を選択', zhCN: '选择头像', zhTW: '選擇頭像',
  es: 'Seleccionar imagen de perfil', de: 'Profilbild auswählen',
  pt: 'Selecionar imagem de perfil', ru: 'Выбрать фото профиля',
);

String get teamChallengeLoginRequired => _s(
  en: 'An account is required to use Team Challenge.',
  ko: '팀 챌린지를 이용하려면 계정이 필요합니다.',
  ja: 'チームチャレンジを使用するにはアカウントが必要です。',
  zhCN: '使用团队挑战需要账户。', zhTW: '使用團隊挑戰需要帳戶。',
  es: 'Se requiere una cuenta para usar el Desafío en equipo.',
  de: 'Für Team Challenge ist ein Konto erforderlich.',
  pt: 'É necessária uma conta para usar o Desafio em equipe.',
  ru: 'Для использования командного вызова необходима учётная запись.',
);

String get signUpAction => _s(
  en: 'Sign Up', ko: '회원가입하기',
  ja: '新規登録する', zhCN: '注册', zhTW: '註冊',
  es: 'Registrarse', de: 'Registrieren',
  pt: 'Cadastrar', ru: 'Зарегистрироваться',
);

String get alreadyHaveAccount => _s(
  en: 'I already have an account', ko: '이미 계정이 있어요',
  ja: 'すでにアカウントがあります', zhCN: '我已有账户', zhTW: '我已有帳戶',
  es: 'Ya tengo una cuenta', de: 'Ich habe bereits ein Konto',
  pt: 'Já tenho uma conta', ru: 'У меня уже есть аккаунт',
);

String get emailVerificationRequired => _s(
  en: 'Email verification required. Please check your inbox.',
  ko: '이메일 인증이 필요합니다. 받은 편지함을 확인해주세요.',
  ja: 'メール認証が必要です。受信トレイを確認してください。',
  zhCN: '需要验证邮箱，请查看收件箱。', zhTW: '需要驗證信箱，請查看收件箱。',
  es: 'Se requiere verificación de correo. Comprueba tu bandeja de entrada.',
  de: 'E-Mail-Verifizierung erforderlich. Bitte prüfe deinen Posteingang.',
  pt: 'Verificação de e-mail necessária. Verifique sua caixa de entrada.',
  ru: 'Необходимо подтверждение email. Проверьте почту.',
);
```

---

### [P1-4] 다크모드 미작동

**현황**: 설정 토글은 있으나 앱 테마에 실제로 적용되지 않음  
**예상 작업량**: 소 (1시간)

#### 문제점

```dart
// lib/app.dart:31 — darkTheme 없음, settings.darkMode 미사용
return MaterialApp(
  title: 'Streakly',
  theme: AppTheme.lightTheme,   // lightTheme만 적용
  // darkTheme 없음 → 토글해도 아무 변화 없음
  home: const _AppInitializer(),
);
```

#### 수정 방법

```dart
// lib/theme/app_theme.dart — darkTheme 추가
class AppTheme {
  static ThemeData get lightTheme { ... }  // 기존 유지

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF242424),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // ... 나머지 다크 테마
    );
  }
}

// lib/app.dart — darkTheme + themeMode 적용
return MaterialApp(
  title: 'Streakly',
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
  home: const _AppInitializer(),
);
```

---

## 🟡 출시 전 권장 수정

---

### [P2-1] getBadgesEarned() 임시 로직 개선

**현황**: 홈 화면에 표시되는 "배지" 수가 임시 계산 로직  
**예상 작업량**: 소 (30분)

#### 문제점

```dart
// lib/providers/challenge_provider.dart:416~424
int getBadgesEarned() {
  int badges = 0;
  for (final challenge in _challenges) {
    if (challenge.completedDays.length >= 7) badges++;   // 임시
    if (challenge.completedDays.length >= 14) badges++;  // 임시
    if (challenge.isCompleted) badges++;                 // 임시
  }
  return badges;
}
```

#### 수정 방법
배지 시스템 구현 전까지는 완료된 챌린지 수만 표시하거나,  
홈 화면의 배지 카드 자체를 "총 완료" 카드로 명칭을 교체합니다.

```dart
// 임시 수정안: 완료 챌린지 수로 단순화
int getBadgesEarned() => completedChallenges.length;
```

---

### [P2-2] 에러 메시지 사용자 친화적 처리

**현황**: Supabase 내부 에러 메시지가 그대로 사용자에게 노출될 수 있음  
**예상 작업량**: 소 (1시간)

#### 문제점

```dart
// lib/providers/auth_provider.dart:87
_error = _parseAuthError(e.message);  // Supabase 원문 메시지 노출 가능

// 예: "User already registered" 같은 영어 원문이
// 한국어 앱 사용자에게 표시될 수 있음
```

#### 수정 방법

```dart
// auth_provider.dart의 _parseAuthError()를 다국어 에러 메시지로 확장
String _parseAuthError(String raw, String language) {
  if (raw.contains('Invalid login credentials')) {
    return AppStrings.of(language).invalidCredentials;
  }
  if (raw.contains('User already registered')) {
    return AppStrings.of(language).userAlreadyExists;
  }
  if (raw.contains('Password should be')) {
    return AppStrings.of(language).passwordTooShort;
  }
  return AppStrings.of(language).unknownError;
}
```

---

## 🟢 출시 후 개선 (Backlog)

---

### [POST-1] 배지 시스템 구현

**기획 문서**: `docs/BADGE_IMPLEMENTATION_PLAN.md`  
**예상 작업량**: 총 6주 (4 Phase)

Phase 1 (3주): 핵심 인프라, 스트릭/완주 배지  
Phase 2 (2주): 로그/타이밍/서브루틴 + Supabase 동기화  
Phase 3 (1주): UI 완성, Secret 배지, 프로필 연동  
Phase 4: 팀 챌린지 출시 후 팀 배지 활성화

---

### [POST-2] 팀 챌린지 (PRO 기능)

**기획 문서**: `docs/TEAM_CHALLENGE_PLAN.md`  
**예상 작업량**: 약 18주 (4 Phase)

Phase 1 (8주): 팀 CRUD, 초대, 기본 UI  
Phase 2 (4주): 실시간 동기화, 응원 반응, 리더보드  
Phase 3 (4주): RevenueCat 결제 연동, PRO 게이트  
Phase 4 (2주): 베타 테스트, 스토어 심사

---

### [POST-3] 구독 결제 시스템 (RevenueCat)

**현황**: 설정 화면의 "팀 챌린지 구독" 버튼이 바텀시트만 표시  
**의존성**: 팀 챌린지 기능 완성 후 연동

```
추가 필요 패키지: purchases_flutter (RevenueCat SDK)
수정 파일: lib/services/subscription_service.dart (신규)
           lib/screens/settings/settings_screen.dart
           lib/providers/auth_provider.dart (isPro 상태 관리)
```

---

### [POST-4] 온보딩 화면 개선

**현황**: `LandingScreen`이 온보딩 역할을 하고 있으나 최소한의 UI  
**개선 방향**: 앱의 핵심 가치(21일 법칙, 스트릭)를 3~4 슬라이드로 소개하는 온보딩 플로우 추가

```
lib/screens/onboarding/onboarding_screen.dart (신규)
- 슬라이드 1: "21일의 법칙" 소개
- 슬라이드 2: 스트릭 시각화 설명
- 슬라이드 3: 팀 챌린지 예고 (Coming Soon)
- 슬라이드 4: 시작하기 (게스트 / 회원가입)
```

---

## 작업 순서 권장

```
┌─────────────────────────────────────────────────────┐
│  소프트 론칭 전 완료 목표                            │
│                                                     │
│  Day 1   [P1-4] 다크모드 수정 (1h)                  │
│          [P1-3] 하드코딩 텍스트 (2h)                │
│          [P2-1] getBadgesEarned 단순화 (30m)        │
│                                                     │
│  Day 2   [P1-2] 완료 챌린지 상세 화면 (2h)          │
│          [P2-2] 에러 메시지 처리 (1h)               │
│                                                     │
│  Day 3~4 [P1-1] 알림 기능 구현 (1~2일)              │
│                                                     │
│  ────────────────────── 소프트 론칭 ────────────── │
│                                                     │
│  Month 2 [POST-1] 배지 시스템 Phase 1~3             │
│  Month 3 [POST-3] RevenueCat 연동                   │
│  Month 4+ [POST-2] 팀 챌린지 Phase 1~4              │
└─────────────────────────────────────────────────────┘
```

---

## 체크리스트

### 출시 전 필수

- [x] **[P1-1]** `flutter_local_notifications` 추가 및 알림 서비스 구현
- [x] **[P1-1]** 챌린지 생성 시 알림 자동 등록
- [x] **[P1-1]** 챌린지 삭제 시 알림 취소
- [x] **[P1-1]** 알림 설정 토글 실제 연동
- [x] **[P1-2]** 완료 챌린지 카드에 `onTap` 추가
- [x] **[P1-2]** 완료 챌린지 상세 화면 구현 (`completed_challenge_detail_screen.dart`)
- [x] **[P1-3]** `settings_screen.dart` 하드코딩 5개 항목 다국어 처리
- [x] **[P1-3]** `auth_provider.dart` 에러 메시지 다국어 처리
- [x] **[P1-4]** `AppTheme.darkTheme` 정의
- [x] **[P1-4]** `app.dart`에 `darkTheme` + `themeMode` 적용

### 출시 전 권장

- [x] **[P2-1]** `getBadgesEarned()` dead code 제거 (BadgeProvider로 대체)
- [x] **[P2-2]** Supabase 에러 원문 노출 차단 및 다국어 에러 메시지 처리 (5개 키 추가)

### 출시 후 (Backlog)

- [ ] **[POST-1]** 배지 시스템 Phase 1 착수
- [ ] **[POST-1]** 배지 시스템 Phase 2
- [ ] **[POST-1]** 배지 시스템 Phase 3
- [ ] **[POST-2]** 팀 챌린지 Phase 1 착수
- [ ] **[POST-3]** RevenueCat 구독 결제 연동
- [ ] **[POST-4]** 온보딩 화면 개선

---

*관련 문서: [BADGE_IMPLEMENTATION_PLAN.md](BADGE_IMPLEMENTATION_PLAN.md) | [TEAM_CHALLENGE_PLAN.md](TEAM_CHALLENGE_PLAN.md) | [BADGE_SYSTEM_PLAN.md](BADGE_SYSTEM_PLAN.md)*
