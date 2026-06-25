# 스토어 심사 컴플라이언스

> 작성일: 2026-06-18  
> 분석 도구: store-validator agent  
> 상태: **제출 불가 — Critical 4개 미해결**

---

## 요약

| 구분 | 항목 수 | 상태 |
|---|---|---|
| 🔴 Critical (즉시 반려 확정) | 4개 | 미해결 |
| 🟡 Warning (반려 가능성 높음) | 5개 | 일부 해결 |
| 🟢 Passed | 9개 | — |

---

## 🔴 Critical — 제출 전 반드시 해결

---

### [C-1] ATT 프레임워크 미적용 (iOS 즉시 반려)

**근거**: Apple Guideline 5.1.2  
**영향**: iOS 14.5+ 전 기기에서 바이너리 분석 단계에 자동 반려

`google_mobile_ads`가 IDFA(광고 식별자)를 사용하므로 ATT 동의를 반드시 받아야 합니다.

**누락된 항목 3가지:**

| 항목 | 위치 | 상태 |
|---|---|---|
| `NSUserTrackingUsageDescription` | `ios/Runner/Info.plist` | 누락 |
| `app_tracking_transparency` 패키지 | `pubspec.yaml` | 누락 |
| `requestTrackingAuthorization()` 호출 | `lib/services/ad_service.dart` | 누락 |

**수정 방법:**

```yaml
# pubspec.yaml — dependencies에 추가
app_tracking_transparency: ^3.0.6
```

```xml
<!-- ios/Runner/Info.plist — <dict> 안에 추가 -->
<key>NSUserTrackingUsageDescription</key>
<string>This identifier is used to show you personalized ads and measure ad performance.</string>
```

```dart
// lib/services/ad_service.dart — initialize() 수정
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

Future<void> initialize() async {
  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
  await MobileAds.instance.initialize();
  loadRewardedAd();
}
```

---

### [C-2] AdMob 전체가 테스트 ID (AdMob 정책 위반)

**근거**: Google AdMob Program Policies, Apple 광고 콘텐츠 정책  
**영향**: 리뷰어에게 빈 광고 또는 테스트 광고 노출 → Google Play 기술 검토에서 플래그

**교체 필요한 위치 4곳:**

| 파일 | 현재 값 | 교체 필요 |
|---|---|---|
| `ios/Runner/Info.plist:86` | `ca-app-pub-3940256099942544~1458002511` | 실제 iOS App ID |
| `android/app/src/main/AndroidManifest.xml:43` | `ca-app-pub-3940256099942544~3347511713` | 실제 Android App ID |
| `lib/services/ad_service.dart:14-16` | 테스트 Rewarded Ad Unit ID | 실제 광고 단위 ID |
| `lib/widgets/native_ad_card.dart:19-21` | 테스트 Native Ad Unit ID | 실제 광고 단위 ID |

**수정 방법:**  
AdMob 콘솔(admob.google.com)에서 앱을 등록하고 실제 App ID와 광고 단위 ID를 발급받아 위 4곳에 교체합니다.

---

### [C-3] 구독이 Mock 구현 — 실제 결제 미연동 (Apple 3.1.1 위반)

**근거**: Apple Guideline 3.1.1, Google Play Billing Policy  
**영향**: 리뷰어가 구독 버튼을 누르면 결제창 없이 즉시 PRO 전환됨 → 즉시 반려

**문제 위치:**

| 파일 | 라인 | 내용 |
|---|---|---|
| `lib/providers/subscription_provider.dart:21-28` | — | `subscribe()`가 SharedPreferences에만 저장, 결제 없음 |
| `lib/l10n/app_strings.dart:56` | — | `pauseTicketBuy` = `"Buy (₩1,900)"` 하드코딩 가격 노출 |

**선택지:**

**옵션 A — 구독 UI 숨기기 (권장, 빠른 출시):**  
구독 바텀시트 진입점을 모두 숨기고 PRO 기능을 전체 무료 개방. 다음 업데이트에서 실제 IAP 연동.

**옵션 B — 실제 IAP 구현:**  
1. `pubspec.yaml`에 `in_app_purchase: ^3.x` 추가
2. App Store Connect에 자동 갱신 구독 상품 등록
3. Google Play Console에 구독 상품 등록
4. `subscription_provider.dart`의 `subscribe()`를 실제 `InAppPurchase.instance.buyNonConsumable()` 호출로 교체
5. 하드코딩 가격(`₩1,900`) 제거 → `ProductDetails.price`로 런타임 조회

---

### [C-4] Google 로그인 URL Scheme 플레이스홀더 (Apple 2.1 위반)

**근거**: Apple Guideline 2.1 (앱 완성도)  
**영향**: Google 로그인 시 OAuth 리다이렉트 실패 → 핵심 기능 비작동으로 반려

**문제 위치:**

```xml
<!-- ios/Runner/Info.plist:80 -->
<string>REPLACE_WITH_REVERSED_GOOGLE_CLIENT_ID</string>
```

`ios/Runner/GoogleService-Info.plist`도 존재하지 않음.

**수정 방법:**

1. Google Cloud Console에서 iOS용 `GoogleService-Info.plist` 다운로드
2. `ios/Runner/` 폴더에 파일 추가 (Xcode에서 타겟에 포함)
3. `Info.plist`의 URL Scheme 교체:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- GoogleService-Info.plist의 REVERSED_CLIENT_ID 값 -->
      <string>com.googleusercontent.apps.YOUR_CLIENT_ID_HERE</string>
    </array>
  </dict>
</array>
```

---

## 🟡 Warning — 출시 전 해결 권장

---

### [W-1] Android 릴리즈 빌드에 디버그 키스토어 사용

**근거**: Google Play 업로드 정책  
**영향**: 디버그 키스토어로 서명된 AAB는 Play Console 업로드 단계에서 거부됨 (심사 전)

**문제 위치:** `android/app/build.gradle.kts:38-39`
```kotlin
signingConfig = signingConfigs.getByName("debug")  // ← 릴리즈에 debug 서명
```

**수정 방법:** 프로덕션 키스토어를 생성하고 `key.properties` 파일로 관리. 키스토어 파일과 비밀번호는 절대 git에 커밋하지 말 것.

---

### [W-2] Android AD_ID 권한 누락

**근거**: Google Play 광고 ID 정책 (Android 13+)  
**영향**: 맞춤 광고 작동 안 함, 데이터 보안 섹션 선언과 불일치

**수정 방법:** `android/app/src/main/AndroidManifest.xml`의 `<application>` 태그 앞에 추가:
```xml
<uses-permission android:name="com.google.android.gms.ads.AD_ID"/>
```

---

### [W-3] GDPR/UMP 동의 화면 미구현

**근거**: AdMob EU 동의 요구사항  
**영향**: AdMob 계정 수준 정책 위반 → 광고 송출 정지 가능 (심사 통과 후라도)

**수정 방법:** `google_mobile_ads` 패키지의 UMP API로 광고 초기화 전 동의 수집:
```dart
ConsentInformation.instance.requestConsentInfoUpdate(params, () async {
  if (await ConsentInformation.instance.isConsentFormAvailable()) {
    await ConsentForm.loadAndShowConsentFormIfRequired((error) {
      MobileAds.instance.initialize();
    });
  }
}, (error) => debugPrint('UMP error: $error'));
```

---

### [W-4] `ITSAppUsesNonExemptEncryption` 누락

**근거**: Apple 수출 규정 준수  
**영향**: App Store Connect 업로드마다 수동 답변 필요, CI/CD 파이프라인 차단

**수정 방법:** `ios/Runner/Info.plist`에 추가:
```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```
(Streakly는 HTTPS만 사용하며 독자 암호화 없으므로 `false`가 올바름)

---

### [W-5] Android 메인 매니페스트에 INTERNET 권한 누락 ✅ 해결됨

**근거**: Android 네트워크 정책  
**영향**: 릴리즈 빌드에서 네트워크 요청 실패 가능 (라이브러리 전이 의존으로 대부분 작동하지만 명시 필요)

**수정 방법:** `android/app/src/main/AndroidManifest.xml`에 추가:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## 🟢 Passed — 정상 확인

| 항목 | 확인 내용 |
|---|---|
| 계정 삭제 기능 | `auth_provider.dart:260` — Supabase RPC `delete_user` + CASCADE 삭제 구현 |
| Apple Sign-In 엔타이틀먼트 | `ios/Runner/Runner.entitlements`에 올바르게 선언 |
| 개인정보처리방침 / 이용약관 | 설정 화면에 링크 존재, 로케일별 URL 분기 |
| Android targetSdkVersion | 36 (Flutter 3.41.2 기본값) — Google Play 최소 요구사항 34 충족 |
| Android minSdkVersion | 24 — 현재 요구사항 충족 |
| 외부 결제 우회 없음 | Mock 구독이 외부 결제를 수집하지 않음 |
| 부적절 콘텐츠 없음 | 전체 코드베이스 검사 통과 |
| 알림 권한 처리 | `flutter_local_notifications` 런타임 요청 정상 |
| Sign in with Apple | Supabase nonce 검증 포함 정상 구현 |

---

## 제출 전 체크리스트

### Critical — 이 항목 없으면 제출하지 말 것

- [ ] `app_tracking_transparency: ^3.0.6` pubspec.yaml에 추가
- [ ] `NSUserTrackingUsageDescription` Info.plist에 추가
- [ ] `ad_service.dart`에서 MobileAds 초기화 전 ATT 요청 구현
- [ ] AdMob 실제 App ID 교체 (Info.plist, AndroidManifest.xml)
- [ ] AdMob 실제 광고 단위 ID 교체 (ad_service.dart, native_ad_card.dart)
- [ ] 구독 UI 숨기기 **또는** 실제 IAP 구현
- [ ] `GoogleService-Info.plist` ios/Runner에 추가
- [ ] Info.plist URL Scheme 플레이스홀더 실제 Reversed Client ID로 교체

### Warning — 출시 전 해결 권장

- [ ] 프로덕션 키스토어 생성 및 릴리즈 서명 설정
- [ ] `AD_ID` 권한 AndroidManifest.xml에 추가
- [ ] UMP 동의 플로우 구현 (AdMob GDPR)
- [ ] `ITSAppUsesNonExemptEncryption = false` Info.plist에 추가
- [ ] `INTERNET` 권한 메인 AndroidManifest.xml에 명시

### 제출 직전 확인

- [ ] `https://woodys67.github.io/streakly/privacy_policy.html` — 200 응답 확인
- [ ] `https://woodys67.github.io/streakly/terms_of_service.html` — 200 응답 확인
- [ ] TestFlight 또는 Internal Testing으로 최종 기능 검증

---

*관련 문서: [LAUNCH_READINESS.md](LAUNCH_READINESS.md) | [ADMOB_SETUP_GUIDE.md](ADMOB_SETUP_GUIDE.md)*
