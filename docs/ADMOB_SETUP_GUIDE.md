# AdMob 광고 설정 가이드

> Streakly 앱에 AdMob 보상형 광고를 연동하기 위한 단계별 실행 가이드.  
> 코드 구조(`AdService`)는 이미 구현 완료. 남은 작업은 실제 ID 교체 및 ATT 처리.

---

## 현재 상태 (2026-06-11 기준)

| 항목 | 상태 | 위치 |
|------|------|------|
| `google_mobile_ads` 패키지 | ✅ 완료 | `pubspec.yaml` |
| `AdService` (보상형 광고) | ✅ 완료 | `lib/services/ad_service.dart` |
| iOS 앱 ID | ❌ 테스트값 | `ios/Runner/Info.plist` |
| iOS 광고 단위 ID | ❌ 테스트값 | `lib/services/ad_service.dart:16` |
| Android 앱 ID | ❌ 확인 필요 | `android/app/src/main/AndroidManifest.xml` |
| Android 광고 단위 ID | ❌ 테스트값 | `lib/services/ad_service.dart:14` |
| ATT 권한 문자열 | ❌ 누락 | `ios/Runner/Info.plist` |
| ATT 팝업 코드 | ❌ 미구현 | 앱 초기화 흐름 |

---

## STEP 1 — AdMob 계정 생성

1. [admob.google.com](https://admob.google.com) 접속
2. Google 계정으로 로그인
3. 국가: **대한민국**, 결제 통화: **KRW** 설정
4. 이용약관 동의 후 계정 생성 완료

---

## STEP 2 — 앱 등록

앱이 아직 스토어에 출시되지 않은 경우:

1. AdMob 콘솔 → **앱** → **앱 추가**
2. "앱이 지원되는 앱 스토어에 등록되어 있나요?" → **아니요** 선택
3. 플랫폼: **iOS** 선택
4. 앱 이름: `Streakly` 입력 → **앱 추가**
5. **앱 ID 복사** — 형식: `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX`

Android도 동일한 과정 반복 (플랫폼만 Android로 변경).

---

## STEP 3 — 광고 단위 생성 (보상형)

현재 코드는 **보상형 광고(Rewarded Ad)** 만 사용.

1. AdMob 콘솔 → 해당 앱 선택 → **광고 단위** → **광고 단위 추가**
2. 광고 형식: **보상형** 선택
3. 광고 단위 이름: `streakly_rewarded`
4. 보상 설정:
   - 보상 이름: `willpower`
   - 보상 수량: `1`
5. **광고 단위 만들기** → **완료**
6. **광고 단위 ID 복사** — 형식: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`

iOS용, Android용 각각 생성 권장.

---

## STEP 4 — Flutter 코드에 실제 ID 적용

`lib/services/ad_service.dart:12-17` 테스트 ID를 교체:

```dart
static String get _rewardedAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // Android 실제 광고 단위 ID
  }
  return 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // iOS 실제 광고 단위 ID
}
```

---

## STEP 5 — iOS Info.plist 설정

`ios/Runner/Info.plist` 에서 두 가지 수정:

### ① GADApplicationIdentifier 교체

```xml
<!-- 현재 테스트값 → STEP 2에서 복사한 실제 iOS 앱 ID로 교체 -->
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
```

### ② NSUserTrackingUsageDescription 추가 (필수)

이 항목이 없으면 App Store 심사에서 **거부**됨.

```xml
<key>NSUserTrackingUsageDescription</key>
<string>더 나은 광고 경험을 위해 사용자 데이터가 사용됩니다.</string>
```

`</dict>` 닫는 태그 바로 위에 삽입.

---

## STEP 6 — ATT 동의 팝업 구현 (iOS 14.5+)

AdMob은 ATT 동의 전까지 광고를 제한함. `app_tracking_transparency` 패키지 필요.

### pubspec.yaml 추가

```yaml
dependencies:
  app_tracking_transparency: ^2.0.6
```

### 앱 초기화 흐름에 추가

ATT 팝업은 첫 실행 직후, 초기 화면이 표시된 다음에 띄우는 것이 권장 패턴.

```dart
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

Future<void> initializeAds() async {
  // iOS: ATT 동의 요청 (Android는 자동으로 건너뜀)
  if (Platform.isIOS) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
  // 동의 여부와 관계없이 AdMob 초기화 진행
  await AdService().initialize();
}
```

---

## STEP 7 — Android AndroidManifest.xml 설정

`android/app/src/main/AndroidManifest.xml` 의 `<application>` 태그 안에 추가:

```xml
<meta-data
  android:name="com.google.android.gms.ads.APPLICATION_ID"
  android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
```

---

## STEP 8 — 출시 전 최종 체크

- [ ] AdMob 콘솔에서 앱이 "준비됨" 상태인지 확인
- [ ] 실제 기기에서 광고가 노출되는지 확인 (시뮬레이터에서는 테스트 광고만 노출)
- [ ] ATT 팝업이 앱 첫 실행 시 정상 표시되는지 확인
- [ ] 테스트 기기에서 실제 광고를 클릭하지 않도록 주의 (계정 정지 위험)

---

## 주의사항

- 개발 중에는 반드시 테스트 ID(`ca-app-pub-3940256099942544/...`) 또는 AdMob 콘솔에 등록된 테스트 기기 사용
- 실제 광고 ID는 앱 심사 제출 직전에 교체
- ATT 거부 유저도 AdMob은 초기화해야 함 (제한된 광고가 표시됨)

---

## 관련 파일

- `lib/services/ad_service.dart` — 보상형 광고 로드/표시 로직
- `ios/Runner/Info.plist` — iOS 앱 ID, ATT 권한 문자열
- `android/app/src/main/AndroidManifest.xml` — Android 앱 ID
- `docs/ADS_MONETIZATION_GUIDE.md` — 광고 수익화 전략 개요
