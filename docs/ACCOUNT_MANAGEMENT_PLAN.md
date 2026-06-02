# 계정 관리 시스템 도입 계획

> 팀 챌린지 모드 출시를 대비한 계정 관리 시스템 도입 계획서.  
> 현재 앱은 모든 데이터를 로컬(`SharedPreferences`)에만 저장하며 실제 인증 체계가 없음.

---

## 1. 현황 분석

### 현재 구조의 한계

| 항목 | 현재 | 팀 챌린지 출시 시 필요 |
|---|---|---|
| 데이터 저장 | 기기 로컬 (`SharedPreferences`) | 서버 DB (유저별 격리) |
| 인증 | 없음 (`signOut` = 로컬 데이터 삭제) | 실제 토큰 기반 인증 |
| 사용자 식별 | 로컬 이름 문자열만 존재 | 서버에서 발급된 고유 ID |
| 챌린지 데이터 | JSON → SharedPreferences | 클라우드 DB (팀원 공유 가능) |
| 팀 기능 | 불가 | 서버 없이는 구현 불가 |

### 지금 도입해야 하는 이유

나중에 도입하면 발생하는 문제:
- **기존 유저 데이터 마이그레이션 복잡도** 급증 (로컬 → 클라우드 전환 로직)
- **게스트 → 계정 전환** 처리 시 중복 데이터 정합성 문제
- 앱 출시 후 유저가 쌓인 상태에서 스키마 변경 리스크
- 구독 결제 시스템은 계정 없이는 연동 불가

---

## 2. 아키텍처 결정

### 2.1 백엔드 스택 추천: Supabase

| 항목 | Supabase | Firebase |
|---|---|---|
| DB | PostgreSQL (관계형) | Firestore (NoSQL) |
| 인증 | 이메일, 소셜, 익명 모두 지원 | 동일 |
| 실시간 | Row-level 구독 지원 | Firestore 실시간 |
| 팀 기능 | 관계형 DB → 팀/멤버/챌린지 조인 용이 | 컬렉션 구조로 복잡해짐 |
| Flutter SDK | `supabase_flutter` | `firebase_flutter` |
| 비용 | 무료 500MB / 5만 MAU | 무료 1GB / Spark 플랜 제한 |
| 오픈소스 | O (자체 호스팅 가능) | X |

**추천: Supabase** — 팀 챌린지의 관계형 데이터(팀, 멤버, 참여 챌린지)에 PostgreSQL이 더 자연스럽고, 향후 자체 서버 이전도 가능.

### 2.2 인증 방식

| 방식 | 우선순위 | 이유 |
|---|---|---|
| 이메일 + 비밀번호 | 필수 | 기본 |
| Apple 로그인 | 필수 | iOS App Store 심사 요구사항 |
| Google 로그인 | 권장 | 전환율 향상 |
| 익명(게스트) | 권장 | 가입 마찰 최소화 |

### 2.3 게스트 모드 전략

가입 없이도 앱을 사용할 수 있도록 **게스트 모드 유지**.  
팀 챌린지 구독 시도 시점에 계정 가입 유도.

```
앱 최초 실행
    ↓
게스트로 시작 (로컬 저장, 익명 세션)
    ↓
"팀 챌린지 구독" 탭 시
    ↓
계정 가입 유도 → 가입 완료 시 로컬 데이터 클라우드 마이그레이션
```

---

## 3. DB 스키마 설계

```sql
-- 유저
create table users (
  id uuid primary key default gen_random_uuid(),
  email text unique,
  display_name text not null default 'Streakly User',
  language text not null default 'English',
  notifications_enabled boolean not null default true,
  dark_mode boolean not null default false,
  is_pro boolean not null default false,
  created_at timestamptz not null default now()
);

-- 챌린지
create table challenges (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references users(id) on delete cascade,
  name text not null,
  target_days integer not null,
  start_date date not null,
  completed_days integer[] not null default '{}',
  reminder_time text not null default '',
  repeat_days integer[] not null default '{}',
  notes text not null default '',
  is_completed boolean not null default false,
  created_at timestamptz not null default now()
);

-- 서브 루틴
create table sub_routines (
  id uuid primary key default gen_random_uuid(),
  challenge_id uuid not null references challenges(id) on delete cascade,
  name text not null,
  alert_time text not null default '',
  alert_enabled boolean not null default false,
  sort_order integer not null default 0
);

-- 서브 루틴 완료 기록
create table sub_routine_completions (
  challenge_id uuid not null references challenges(id) on delete cascade,
  sub_routine_id uuid not null references sub_routines(id) on delete cascade,
  day_number integer not null,
  primary key (challenge_id, sub_routine_id, day_number)
);

-- 데일리 로그
create table daily_logs (
  id uuid primary key default gen_random_uuid(),
  challenge_id uuid not null references challenges(id) on delete cascade,
  day_number integer not null,
  content text not null,
  created_at timestamptz not null default now()
);

-- (팀 챌린지 대비 — 향후 확장)
-- create table teams ( ... );
-- create table team_members ( ... );
-- create table team_challenges ( ... );
```

---

## 4. Flutter 구현 작업 목록

### Phase 1 — 기반 인프라 (필수)

#### 4.1 패키지 추가 (`pubspec.yaml`)

```yaml
dependencies:
  supabase_flutter: ^2.x
  flutter_secure_storage: ^9.x   # 토큰 안전 저장
  sign_in_with_apple: ^6.x       # Apple 로그인
  google_sign_in: ^6.x           # Google 로그인
```

#### 4.2 `AuthProvider` 신규 생성
`lib/providers/auth_provider.dart`

- [ ] Supabase 클라이언트 초기화
- [ ] 인증 상태 스트림 구독 (`onAuthStateChange`)
- [ ] `signUpWithEmail(email, password, displayName)`
- [ ] `signInWithEmail(email, password)`
- [ ] `signInWithGoogle()`
- [ ] `signInWithApple()`
- [ ] `signInAnonymously()` — 게스트 모드
- [ ] `signOut()`
- [ ] `isGuest` getter (익명 세션 여부)
- [ ] `currentUser` getter

#### 4.3 `SettingsProvider` 수정
`lib/providers/settings_provider.dart`

- [ ] `signOut()` → Supabase 세션 종료로 교체
- [ ] `loadSettings()` → 로그인 상태면 서버에서, 게스트면 로컬에서 로드
- [ ] `saveSettings()` → 로그인 상태면 서버에도 반영

#### 4.4 `ChallengeProvider` 수정
`lib/providers/challenge_provider.dart`

- [ ] 로컬(`SharedPreferences`) → Supabase DB로 읽기/쓰기 전환
- [ ] 게스트 상태에서는 현재와 동일하게 로컬 저장 유지
- [ ] `syncLocalToCloud()` — 게스트 데이터를 계정 가입 시 마이그레이션

---

### Phase 2 — 인증 화면

#### 4.5 회원가입 화면
`lib/screens/auth/sign_up_screen.dart`

- [ ] 이메일 입력
- [ ] 비밀번호 입력 (확인 포함)
- [ ] 닉네임 입력
- [ ] Apple / Google 소셜 로그인 버튼
- [ ] 이미 계정이 있다면 → 로그인 화면 이동

#### 4.6 로그인 화면
`lib/screens/auth/sign_in_screen.dart`

- [ ] 이메일 + 비밀번호
- [ ] Apple / Google 소셜 로그인
- [ ] 비밀번호 찾기 링크
- [ ] 계정 없음 → 회원가입 화면 이동

#### 4.7 비밀번호 재설정 화면
`lib/screens/auth/forgot_password_screen.dart`

- [ ] 이메일 입력 → Supabase `resetPasswordForEmail()` 호출

#### 4.8 앱 시작 라우팅 수정
`lib/app.dart`

- [ ] `AuthProvider` 상태에 따라 초기 화면 분기
  - 비로그인 → 온보딩(or 게스트 시작) 화면
  - 로그인 → 홈 화면

---

### Phase 3 — 설정 화면 연동

#### 4.9 설정 화면 (`settings_screen.dart`) 수정

- [ ] 프로필 카드에 이메일 주소 표시
- [ ] "팀 챌린지 구독" 탭 시 비로그인이면 → 로그인/가입 화면 유도
- [ ] 로그아웃 → `AuthProvider.signOut()` 연결
- [ ] 로그인/비로그인 상태에 따라 UI 분기 (게스트면 "로그인" 버튼 노출)

---

### Phase 4 — 데이터 마이그레이션

#### 4.10 로컬 → 클라우드 마이그레이션 로직

게스트 상태에서 쌓인 챌린지 데이터를 계정 가입 완료 시 서버로 업로드.

- [ ] `MigrationService` 클래스 작성
  - SharedPreferences에서 로컬 데이터 읽기
  - Supabase에 `user_id` 붙여 INSERT
  - 성공 후 로컬 데이터 삭제
- [ ] 마이그레이션 실패 시 롤백 처리
- [ ] 이미 클라우드 데이터가 있는 기기에서 재로그인 시 중복 방지

---

## 5. 보안 고려사항

| 항목 | 처리 방법 |
|---|---|
| 토큰 저장 | `flutter_secure_storage` 사용 (Keychain/Keystore) |
| Row Level Security | Supabase RLS 정책으로 유저 데이터 격리 (`user_id = auth.uid()`) |
| 비밀번호 정책 | 최소 8자, Supabase에서 서버 측 처리 |
| 소셜 토큰 | Apple/Google SDK에서 처리, 앱에 저장 안 함 |

---

## 6. 단계별 일정 제안

| Phase | 작업 | 예상 기간 |
|---|---|---|
| Phase 1 | 인프라 (AuthProvider, 패키지, DB 설계) | 1주 |
| Phase 2 | 인증 화면 3종 (회원가입, 로그인, 비번 찾기) | 1주 |
| Phase 3 | 설정 화면 연동 + 라우팅 | 3일 |
| Phase 4 | 데이터 마이그레이션 | 3일 |
| 테스트 | 인증 흐름 전체, 마이그레이션, RLS 검증 | 1주 |
| **합계** | | **약 4~5주** |

---

## 7. 완료 기준 (Definition of Done)

- [ ] 신규 유저가 게스트로 앱 사용 후 회원가입 시 기존 챌린지 데이터가 보존됨
- [ ] 이메일, Apple, Google 로그인 세 가지 모두 동작
- [ ] 로그아웃 후 재로그인 시 서버 데이터 정상 복원
- [ ] 다른 기기에서 동일 계정 로그인 시 챌린지 동기화
- [ ] Supabase RLS로 타 유저 데이터 접근 불가 확인
- [ ] 게스트 상태에서 기존 기능 전부 정상 동작 (기존 유저 영향 없음)

---

## 참고 파일

| 파일 | 역할 |
|---|---|
| `lib/providers/settings_provider.dart` | signOut, resetApp 수정 대상 |
| `lib/providers/challenge_provider.dart` | 로컬 → 클라우드 전환 대상 |
| `lib/screens/settings/settings_screen.dart` | 설정 UI 연동 대상 |
| `lib/app.dart` | 인증 상태 기반 라우팅 추가 |
| `docs/MULTI_CHALLENGE_PLAN.md` | 팀 챌린지 기획 (이 시스템이 전제 조건) |
