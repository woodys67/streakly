# Claude Code로 서버 관리하기

> 비개발자를 위한 Supabase 서버 관리 가이드.  
> "서버 관리"의 대부분은 Claude Code에게 맡기고, 사람이 해야 할 일은 최소화합니다.

---

## Claude Code가 할 수 있는 것 vs 사람이 해야 하는 것

| 작업 | Claude Code | 사람 |
|---|---|---|
| DB 테이블 생성/수정 | ✅ SQL 작성 | 대시보드에 붙여넣기 |
| 보안 정책(RLS) 설정 | ✅ 정책 작성 | 대시보드에 붙여넣기 |
| 에러 원인 분석 | ✅ 로그 보고 진단 | 로그 복사해서 전달 |
| 기능 추가/수정 코드 | ✅ 전부 작성 | — |
| 비용 초과 알림 대응 | ✅ 방법 안내 | 대시보드에서 실행 |
| 백업 설정 방법 안내 | ✅ 단계별 안내 | 대시보드에서 클릭 |
| Supabase 대시보드 직접 접근 | ❌ 불가 | 사람이 직접 |
| 결제 카드 등록 | ❌ 불가 | 사람이 직접 |
| 도메인 구매/연결 | ❌ 불가 | 사람이 직접 |

**핵심 원칙: Claude가 "무엇을, 어떻게"를 알려주면 사람은 "클릭"만 합니다.**

---

## 자주 발생하는 상황별 대응 방법

### 상황 1 — 앱에서 데이터가 안 불러와져요

**사람이 할 일:**
1. Supabase 대시보드 → Logs → API Logs 열기
2. 빨간 에러 로그 복사
3. Claude Code에 붙여넣기

**Claude Code에 전달하는 방법:**
```
앱에서 챌린지가 안 불러와져. 에러 로그야:

[여기에 복사한 로그 붙여넣기]
```

**Claude Code가 해주는 것:** 원인 분석 + 수정 코드 제공

---

### 상황 2 — DB에 컬럼/테이블을 추가하고 싶어요

**Claude Code에 전달하는 방법:**
```
챌린지에 "카테고리" 필드를 추가하고 싶어. 어떻게 해?
```

**Claude Code가 해주는 것:** SQL 쿼리 작성
```sql
-- Claude가 이런 코드를 만들어줌
ALTER TABLE challenges ADD COLUMN category text not null default '기타';
```

**사람이 할 일:**
1. Supabase 대시보드 → SQL Editor 열기
2. Claude가 준 SQL 붙여넣기
3. Run 버튼 클릭

---

### 상황 3 — 특정 유저의 데이터를 확인하고 싶어요

**Claude Code에 전달하는 방법:**
```
user_id가 'abc-123'인 유저의 챌린지 목록을 조회하는 SQL 만들어줘
```

**Claude Code가 해주는 것:**
```sql
SELECT * FROM challenges WHERE user_id = 'abc-123' ORDER BY created_at DESC;
```

**사람이 할 일:** SQL Editor에 붙여넣고 실행

---

### 상황 4 — 유저 수가 갑자기 늘었어요 (비용 걱정)

**Claude Code에 전달하는 방법:**
```
Supabase 대시보드에서 이번 달 MAU가 45,000명이래. 무료 플랜 한도가 50,000인데 어떻게 해야 해?
```

**Claude Code가 해주는 것:**
- 초과 가능성 계산
- Pro 업그레이드 시점 판단
- 비용 절감 방법 안내 (불필요한 API 호출 줄이기 등)

---

### 상황 5 — 보안이 걱정돼요 (내 유저 데이터 다른 사람이 볼 수 있나요?)

**Claude Code에 전달하는 방법:**
```
Supabase RLS 설정이 제대로 됐는지 확인하고 싶어. 현재 challenges 테이블 RLS 정책 확인하는 방법이랑, 혹시 문제 있으면 고쳐줘
```

**Claude Code가 해주는 것:**
- RLS 정책 점검용 SQL 제공
- 문제 발견 시 수정 SQL 제공
- 올바른 정책 설명

---

### 상황 6 — 앱 업데이트 후 DB 구조도 바꿔야 해요

**Claude Code에 전달하는 방법:**
```
이번 업데이트에서 챌린지에 "색상 테마" 기능을 추가했어. DB도 같이 업데이트해야 하는데 어떻게 해?
```

**Claude Code가 해주는 것:**
- 마이그레이션 SQL 작성
- 기존 데이터 유지하면서 안전하게 변경하는 방법 안내
- 앱 코드 수정까지 일괄 처리

---

## Supabase 대시보드 — 자주 쓰는 메뉴 위치

```
supabase.com → 프로젝트 선택
│
├── Table Editor     → DB 테이블 직접 보기/수정
├── SQL Editor       → Claude가 준 SQL 실행하는 곳
├── Authentication   → 가입한 유저 목록 확인
├── Logs             → 에러 로그 확인 (문제 생겼을 때)
├── Storage          → 파일 저장소
└── Settings
    ├── Billing      → 요금제 / 사용량 확인
    └── API          → API 키 확인
```

---

## 월간 서버 관리 루틴 (10분)

Claude Code에 아래를 붙여넣으면 됩니다:

```
이번 달 Supabase 서버 상태 점검해줘.
확인할 항목 목록이랑, 각각 어디서 확인하는지 알려줘.
```

직접 확인하는 항목:
1. **대시보드 → Billing** — 이번 달 MAU / 용량 사용량
2. **대시보드 → Logs** — 반복되는 에러 있는지
3. **대시보드 → Authentication** — 이상한 가입 패턴 있는지

이상한 게 있으면 스크린샷 찍어서 Claude Code에 전달.

---

## 장애 발생 시 대응 순서

```
1. Supabase 상태 페이지 확인
   → status.supabase.com (Supabase 자체 문제인지 확인)

2. 앱 에러 로그 수집
   → 대시보드 Logs → API Logs 캡처

3. Claude Code에 전달
   → "앱이 갑자기 안 돼. 이 에러가 떴어: [로그]"

4. Claude Code 안내에 따라 조치
```

---

## 핵심 요약

- **코드 관련 모든 것**: Claude Code에게
- **대시보드 클릭**: 사람이 직접
- **에러 났을 때**: 로그 복사 → Claude Code에 붙여넣기
- **DB 변경**: Claude Code가 SQL 작성 → SQL Editor에서 실행

서버 전문 지식 없어도 운영할 수 있습니다.
