# Social Login (Apple & Google) 구현 계획

## 현재 상태

Flutter 코드 구현은 **완료**됨. 외부 서비스 설정만 남아 있음.

### 완료된 작업

| 파일 | 내용 |
|------|------|
| `pubspec.yaml` | `sign_in_with_apple ^6.1.3`, `google_sign_in ^6.2.2`, `crypto ^3.0.3` 추가 |
| `ios/Runner/Info.plist` | Google Sign-In용 URL Scheme 슬롯 추가 (`REPLACE_WITH_REVERSED_GOOGLE_CLIENT_ID`) |
| `lib/config/supabase_config.dart` | `googleIosClientId` 상수 추가 (플레이스홀더) |
| `lib/providers/auth_provider.dart` | `signInWithApple()`, `signInWithGoogle()` 메서드 구현 완료 |
| `lib/widgets/social_login_buttons.dart` | `SocialLoginDivider`, `SocialLoginButtons` 위젯 구현 완료 |
| `lib/screens/auth/sign_in_screen.dart` | SignInScreen / SignUpScreen 양쪽에 소셜 버튼 삽입 완료 |

---

## 남은 작업 (외부 서비스 설정)

### 1. Xcode — Sign in with Apple Capability

**위치:** `ios/Runner.xcworkspace` → Runner Target → Signing & Capabilities

1. `open ios/Runner.xcworkspace` 로 Xcode 열기
2. 좌측 네비게이터에서 **Runner** (파란 아이콘) 클릭
3. **TARGETS → Runner** 선택
4. **Signing & Capabilities** 탭 클릭
5. Team 드롭다운에서 Apple Developer 계정 선택
6. `+ Capability` 버튼 클릭 → `sign in` 검색 → **Sign in with Apple** 더블클릭
7. `Runner.entitlements` 파일이 자동 생성되면 완료

> Apple Developer Program 가입(연 $99) 필수

---

### 2. Google Cloud Console — iOS Client ID 발급

**URL:** https://console.cloud.google.com

1. APIs & Services → Credentials 메뉴 이동
2. `+ Create Credentials` → **OAuth 2.0 Client ID** 선택
3. Application Type: **iOS** 선택
4. Bundle ID 입력 (Xcode → Runner → General → Bundle Identifier에서 확인)
5. 발급 완료 후 두 가지 값 메모:
   - **Client ID** → `XXXXXXXXXX-xxxx.apps.googleusercontent.com`
   - **Reversed Client ID** → `com.googleusercontent.apps.XXXXXXXXXX-xxxx`

발급한 값을 코드에 반영:

```dart
// lib/config/supabase_config.dart
static const String googleIosClientId = '여기에_CLIENT_ID_입력';
```

```xml
<!-- ios/Runner/Info.plist -->
<string>REPLACE_WITH_REVERSED_GOOGLE_CLIENT_ID</string>
<!-- 위 줄을 아래로 교체 -->
<string>com.googleusercontent.apps.여기에_REVERSED_CLIENT_ID</string>
```

---

### 3. Supabase 대시보드 — Apple Provider 설정

**URL:** https://supabase.com/dashboard → 프로젝트 → Authentication → Providers → Apple

필요한 값 (모두 Apple Developer 포털에서 발급):

| 항목 | 발급 위치 |
|------|-----------|
| Service ID | developer.apple.com → Identifiers → Services IDs |
| Team ID | developer.apple.com → Membership 페이지 |
| Key ID | developer.apple.com → Keys → 새 키 생성 (Sign in with Apple 체크) |
| Private Key (.p8 파일) | Key 생성 시 1회만 다운로드 가능 |

Apple Developer 포털 발급 순서:
1. **Service ID 등록:** Identifiers → `+` → Services IDs → Bundle ID 기반으로 등록 (예: `com.streakly.app.siwa`)
2. **Key 생성:** Keys → `+` → Sign in with Apple 체크 → Configure → Primary App ID 선택 → 저장 → `.p8` 파일 다운로드

---

### 4. Supabase 대시보드 — Google Provider 설정

**URL:** https://supabase.com/dashboard → 프로젝트 → Authentication → Providers → Google

| 항목 | 값 |
|------|-----|
| Client ID (for iOS) | Google Cloud Console에서 발급한 iOS Client ID |
| Client Secret | Google Cloud Console → 같은 Client ID의 Secret 값 |

---

## 설정 완료 후 동작 확인 순서

1. `flutter pub get` (이미 완료됨, 재확인용)
2. iOS 시뮬레이터 또는 실기기에서 앱 실행
3. 로그인 화면 → **Apple로 계속하기** 탭 → Apple ID 팝업 확인
4. 로그인 화면 → **Google로 계속하기** 탭 → Google 계정 선택 화면 확인
5. 로그인 성공 후 홈 화면 이동 및 기존 게스트 데이터 마이그레이션 확인

> Apple Sign-In은 **실기기**에서만 테스트 가능 (시뮬레이터 불가)  
> Google Sign-In은 시뮬레이터에서도 테스트 가능

---

## 참고 사항

- 소셜 로그인 후 `displayName`은 Apple/Google 프로필에서 자동으로 가져옴 (`full_name` → `name` 순으로 fallback 처리됨)
- Apple은 최초 로그인 시에만 이름/이메일을 제공하며, 이후 로그인 시에는 제공하지 않음 (Supabase가 첫 번째 값을 저장함)
- 동일 이메일로 이미 이메일 계정이 있는 경우 Supabase가 자동으로 계정을 연결함
