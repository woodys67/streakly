# Streakly 인앱 구독 등록 가이드

> 작성일: 2026-07-01  
> 대상 플랫폼: iOS (App Store Connect) / Android (Google Play Console)  
> 앱 번들 ID: `kr.dotone.streakly`

---

## 목차

1. [상품 ID 및 가격 정책](#1-상품-id-및-가격-정책)
2. [App Store Connect 등록](#2-app-store-connect-등록)
3. [Google Play Console 등록](#3-google-play-console-등록)
4. [코드 연동 확인](#4-코드-연동-확인)
5. [테스트 방법](#5-테스트-방법)
6. [테스트 계정 관리](#6-테스트-계정-관리)
7. [체크리스트](#7-체크리스트)

---

## 1. 상품 ID 및 가격 정책

두 스토어 모두 **동일한 상품 ID**를 사용합니다.

| 플랜 | 상품 ID | 가격 (USD) | 가격 (KRW) |
|------|---------|-----------|-----------|
| 월간 | `kr.dotone.streakly.pro.monthly` | $2.99 | ₩3,900 |
| 연간 | `kr.dotone.streakly.pro.annual`  | $14.99 | ₩19,900 |

> ⚠️ **상품 ID는 한 번 저장 후 변경 불가**입니다. 오타 없이 정확하게 입력하세요.

---

## 2. App Store Connect 등록

### 2-1. 사전 준비

- [ ] Apple Developer Program 활성 상태 ($99/년)
- [ ] App Store Connect → **계약, 세금 및 금융** → 유료 앱 계약 활성화
- [ ] 은행 계좌 및 세금 정보(W-8BEN 등) 등록 완료
- [ ] App Store Connect에 Streakly 앱 등록 완료

### 2-2. 구독 그룹 생성

1. [appstoreconnect.apple.com](https://appstoreconnect.apple.com) 로그인
2. **나의 앱** → **Streakly** 선택
3. 좌측 메뉴 **수익화 → 구독** 클릭
4. **+** 버튼 → **구독 그룹 생성**

| 항목 | 입력값 |
|------|--------|
| 참조 이름 | `Streakly Pro` |

> 구독 그룹 = 같은 카테고리 플랜들의 묶음. 사용자는 한 그룹 내에서 하나의 플랜만 구독 가능합니다.

### 2-3. 월간 구독 상품 추가

구독 그룹 안에서 **+ 구독 추가** 클릭

**기본 정보**

| 항목 | 입력값 |
|------|--------|
| 참조 이름 | `Pro Monthly` |
| 제품 ID | `kr.dotone.streakly.pro.monthly` |
| 구독 기간 | `1개월` |

**현지화 (앱 내 표시 이름)**

| 언어 | 표시 이름 | 설명 |
|------|----------|------|
| 한국어 | `Streakly Pro 월간` | 스트릭 보호, 무제한 챌린지 생성, 즉시 복구 |
| 영어(미국) | `Streakly Pro Monthly` | Protect streaks, unlimited challenges & instant recovery |
| 일본어 | `Streakly Pro 月間` | ストリーク保護、無制限チャレンジ、即時回復 |
| 스페인어 | `Streakly Pro Mensual` | Protege rachas, desafíos ilimitados y recuperación instantánea |

**가격 설정**

- 기준 통화: USD → `$2.99` 선택 (Tier 3)
- 한국 원화 직접 설정 원할 시: KRW → `₩3,900` 수동 지정

### 2-4. 연간 구독 상품 추가

월간과 동일한 방법으로 추가

| 항목 | 입력값 |
|------|--------|
| 참조 이름 | `Pro Annual` |
| 제품 ID | `kr.dotone.streakly.pro.annual` |
| 구독 기간 | `1년` |

| 언어 | 표시 이름 | 설명 |
|------|----------|------|
| 한국어 | `Streakly Pro 연간` | 스트릭 보호, 무제한 챌린지 생성, 즉시 복구 |
| 영어(미국) | `Streakly Pro Annual` | Protect streaks, unlimited challenges & instant recovery |
| 일본어 | `Streakly Pro 年間` | ストリーク保護、無制限チャレンジ、即時回復 |
| 스페인어 | `Streakly Pro Anual` | Protege rachas, desafíos ilimitados y recuperación instantánea |

**가격 설정**

- USD: `$14.99` (Tier 15)
- KRW: `₩19,900`

### 2-5. 심사용 스크린샷 첨부

각 구독 상품 → **심사 정보** 탭

- 구독 화면 스크린샷 1장 업로드 (구독 바텀시트 캡처 권장)
- 리뷰어 메모 (선택): `Test with Sandbox account. No actual charge occurs.`

### 2-6. 상태 확인

저장 후 상태가 **"심사 준비 완료"** 인지 확인합니다.  
앱 심사 제출 시 구독 상품도 함께 심사됩니다.

---

## 3. Google Play Console 등록

### 3-1. 사전 준비

- [ ] Google Play Developer 계정 활성 상태 ($25 일회성)
- [ ] Play Console → **설정 → 결제 프로필** 등록 완료
- [ ] Play Console에 Streakly 앱 등록 완료
- [ ] 앱이 **내부 테스트** 이상 트랙에 APK/AAB 업로드된 상태  
  > ⚠️ 구독 상품은 앱이 한 번이라도 스토어에 업로드되어야 활성화됩니다.

### 3-2. 구독 상품 생성

1. [play.google.com/console](https://play.google.com/console) 로그인
2. **Streakly** 앱 선택
3. 좌측 메뉴 **수익 창출 → 구독** 클릭
4. **구독 만들기** 클릭

### 3-3. 월간 구독 설정

**기본 정보**

| 항목 | 입력값 |
|------|--------|
| 제품 ID | `kr.dotone.streakly.pro.monthly` |
| 이름 | `Streakly Pro 월간` |
| 설명 | `스트릭 보호, 무제한 챌린지 생성, 즉시 복구` |

**기본 플랜 추가**

구독 상품 저장 후 → **기본 플랜 추가** 클릭

| 항목 | 입력값 |
|------|--------|
| 기본 플랜 ID | `monthly-base` |
| 청구 기간 | `월별 (1개월)` |
| 자동 갱신 | 활성화 |

**가격 설정**

기본 플랜 → **가격 설정**

| 통화 | 가격 |
|------|------|
| USD | $2.99 |
| KRW | ₩3,900 |

> **기타 국가 가격**은 "가격 자동 변환" 버튼으로 일괄 설정 가능합니다.

**기본 플랜 활성화**

설정 완료 후 → 기본 플랜 상태를 **활성** 으로 변경

### 3-4. 연간 구독 설정

월간과 동일한 방법으로 추가

| 항목 | 입력값 |
|------|--------|
| 제품 ID | `kr.dotone.streakly.pro.annual` |
| 이름 | `Streakly Pro 연간` |
| 설명 | `스트릭 보호, 무제한 챌린지 생성, 즉시 복구` |

**기본 플랜**

| 항목 | 입력값 |
|------|--------|
| 기본 플랜 ID | `annual-base` |
| 청구 기간 | `연별 (1년)` |
| 자동 갱신 | 활성화 |

**가격**

| 통화 | 가격 |
|------|------|
| USD | $14.99 |
| KRW | ₩19,900 |

### 3-5. 현지화 설정

각 구독 상품 → **언어 추가**

| 언어 | 이름 (월간) | 이름 (연간) |
|------|------------|------------|
| 한국어 (ko) | `Streakly Pro 월간` | `Streakly Pro 연간` |
| 영어 (en-US) | `Streakly Pro Monthly` | `Streakly Pro Annual` |
| 일본어 (ja) | `Streakly Pro 月間` | `Streakly Pro 年間` |
| 스페인어 (es) | `Streakly Pro Mensual` | `Streakly Pro Anual` |

### 3-6. 구독 활성화

구독 상품 → 상태 → **활성** 으로 변경

---

## 4. 코드 연동 확인

`lib/providers/subscription_provider.dart` 상단의 상품 ID 상수를 확인합니다.

```dart
const kProductMonthly = 'kr.dotone.streakly.pro.monthly';
const kProductAnnual  = 'kr.dotone.streakly.pro.annual';
```

스토어에 등록한 상품 ID와 **정확히 일치**해야 합니다.

---

## 5. 테스트 방법

### iOS — 샌드박스 테스터

1. App Store Connect → **사용자 및 접근 → 샌드박스 → 테스터**
2. **+** 버튼 → 테스터 이메일 추가 (실제 Apple ID 아닌 전용 계정 권장)
3. 실기기에서 **설정 → App Store → 샌드박스 계정** 으로 로그인
4. 앱에서 구독 버튼 탭 → 결제 시트에 "환경: 샌드박스" 표시 확인

> 샌드박스 구독 갱신 주기 단축표
>
> | 실제 기간 | 샌드박스 기간 |
> |----------|-------------|
> | 1개월 | 5분 |
> | 1년 | 1시간 |

### Android — 내부 테스터 라이선스

1. Play Console → **설정 → 라이선스 테스터**
2. 테스터 구글 계정 이메일 추가
3. 해당 계정으로 기기에서 구독 시 실제 결제 없이 테스트 가능

> ⚠️ Android IAP 테스트는 **내부 테스트 트랙에 APK가 업로드된 실기기**에서만 동작합니다.  
> 에뮬레이터 및 `flutter run` 디버그 빌드에서는 동작하지 않습니다.

---

## 6. 테스트 계정 관리

앱 내 테스트 계정은 스토어 IAP 없이 항상 Pro 상태로 동작합니다.  
`lib/providers/subscription_provider.dart` 의 `_kTestAccounts` 목록으로 관리합니다.

```dart
const _kTestAccounts = <String>{
  'hwsong67@gmail.com',   // 개발자 계정
  'test@streakly.app',    // QA 테스트 계정
};
```

**계정 추가 방법**: 위 Set에 이메일 추가 후 재빌드  
**특징**: 설정 화면에 "Pro · 테스트 계정" 으로 표시되며 구독 관리 버튼이 숨겨집니다.

---

## 7. 체크리스트

### App Store Connect

- [ ] 유료 앱 계약 활성화 (계약, 세금 및 금융)
- [ ] 구독 그룹 `Streakly Pro` 생성
- [ ] 월간 상품 `kr.dotone.streakly.pro.monthly` 등록
- [ ] 연간 상품 `kr.dotone.streakly.pro.annual` 등록
- [ ] 각 상품 현지화 4개 언어 (ko / en / ja / es) 작성
- [ ] 각 상품 심사용 스크린샷 업로드
- [ ] 두 상품 모두 상태 "심사 준비 완료" 확인
- [ ] 샌드박스 테스터 계정 추가 및 실기기 테스트

### Google Play Console

- [ ] 결제 프로필 등록 완료
- [ ] 내부 테스트 트랙에 APK/AAB 업로드
- [ ] 월간 구독 `kr.dotone.streakly.pro.monthly` 생성 및 활성화
- [ ] 연간 구독 `kr.dotone.streakly.pro.annual` 생성 및 활성화
- [ ] 각 구독 현지화 4개 언어 작성
- [ ] 기본 플랜 상태 "활성" 확인
- [ ] 라이선스 테스터 계정 추가 및 실기기 테스트

### 코드

- [ ] `kProductMonthly` / `kProductAnnual` 상수가 스토어 ID와 일치
- [ ] `_kTestAccounts` 에 필요한 계정 등록
- [ ] iOS: Xcode → Signing & Capabilities → **In-App Purchase** 추가 확인
- [ ] Android: `AndroidManifest.xml` 에 `BILLING` 권한 추가 확인 ✅ (완료)
