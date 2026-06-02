-- ============================================================
-- Streakly — Supabase 초기 설정 SQL
-- Supabase Dashboard > SQL Editor 에서 순서대로 실행하세요.
-- 재실행 시에도 안전하게 동작합니다 (idempotent).
-- ============================================================


-- ────────────────────────────────────────
-- 1. 테이블 생성
-- ────────────────────────────────────────

create table if not exists public.users (
  id                    uuid        primary key references auth.users(id) on delete cascade,
  email                 text,
  display_name          text        not null default 'Streakly User',
  language              text        not null default 'English',
  notifications_enabled boolean     not null default true,
  dark_mode             boolean     not null default false,
  is_pro                boolean     not null default false,
  created_at            timestamptz not null default now()
);

create table if not exists public.challenges (
  id             uuid        primary key default gen_random_uuid(),
  user_id        uuid        not null references public.users(id) on delete cascade,
  name           text        not null,
  target_days    integer     not null,
  start_date     date        not null,
  completed_days integer[]   not null default '{}',
  reminder_time  text        not null default '',
  repeat_days    integer[]   not null default '{}',
  notes          text        not null default '',
  is_completed   boolean     not null default false,
  created_at     timestamptz not null default now()
);

create table if not exists public.sub_routines (
  id            uuid    primary key default gen_random_uuid(),
  challenge_id  uuid    not null references public.challenges(id) on delete cascade,
  name          text    not null,
  alert_time    text    not null default '',
  alert_enabled boolean not null default false,
  sort_order    integer not null default 0
);

create table if not exists public.sub_routine_completions (
  challenge_id   uuid    not null references public.challenges(id) on delete cascade,
  sub_routine_id uuid    not null references public.sub_routines(id) on delete cascade,
  day_number     integer not null,
  primary key (challenge_id, sub_routine_id, day_number)
);

create table if not exists public.daily_logs (
  id           uuid        primary key default gen_random_uuid(),
  challenge_id uuid        not null references public.challenges(id) on delete cascade,
  day_number   integer     not null,
  content      text        not null,
  created_at   timestamptz not null default now()
);


-- ────────────────────────────────────────
-- 2. Row Level Security 활성화
-- ────────────────────────────────────────

alter table public.users                   enable row level security;
alter table public.challenges              enable row level security;
alter table public.sub_routines            enable row level security;
alter table public.sub_routine_completions enable row level security;
alter table public.daily_logs              enable row level security;


-- ────────────────────────────────────────
-- 3. RLS 정책 — users
-- ────────────────────────────────────────

drop policy if exists "users: 본인만 조회" on public.users;
create policy "users: 본인만 조회"
  on public.users for select
  using (auth.uid() = id);

drop policy if exists "users: 본인만 삽입" on public.users;
create policy "users: 본인만 삽입"
  on public.users for insert
  with check (auth.uid() = id);

drop policy if exists "users: 본인만 수정" on public.users;
create policy "users: 본인만 수정"
  on public.users for update
  using (auth.uid() = id);


-- ────────────────────────────────────────
-- 4. RLS 정책 — challenges
-- ────────────────────────────────────────

drop policy if exists "challenges: 본인만 조회" on public.challenges;
create policy "challenges: 본인만 조회"
  on public.challenges for select
  using (auth.uid() = user_id);

drop policy if exists "challenges: 본인만 삽입" on public.challenges;
create policy "challenges: 본인만 삽입"
  on public.challenges for insert
  with check (auth.uid() = user_id);

drop policy if exists "challenges: 본인만 수정" on public.challenges;
create policy "challenges: 본인만 수정"
  on public.challenges for update
  using (auth.uid() = user_id);

drop policy if exists "challenges: 본인만 삭제" on public.challenges;
create policy "challenges: 본인만 삭제"
  on public.challenges for delete
  using (auth.uid() = user_id);


-- ────────────────────────────────────────
-- 5. RLS 정책 — sub_routines
-- ────────────────────────────────────────

drop policy if exists "sub_routines: 본인 챌린지만 조회" on public.sub_routines;
create policy "sub_routines: 본인 챌린지만 조회"
  on public.sub_routines for select
  using (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );

drop policy if exists "sub_routines: 본인 챌린지만 삽입" on public.sub_routines;
create policy "sub_routines: 본인 챌린지만 삽입"
  on public.sub_routines for insert
  with check (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );

drop policy if exists "sub_routines: 본인 챌린지만 수정" on public.sub_routines;
create policy "sub_routines: 본인 챌린지만 수정"
  on public.sub_routines for update
  using (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );

drop policy if exists "sub_routines: 본인 챌린지만 삭제" on public.sub_routines;
create policy "sub_routines: 본인 챌린지만 삭제"
  on public.sub_routines for delete
  using (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );


-- ────────────────────────────────────────
-- 6. RLS 정책 — sub_routine_completions
-- ────────────────────────────────────────

drop policy if exists "sub_routine_completions: 본인 챌린지만 조회" on public.sub_routine_completions;
create policy "sub_routine_completions: 본인 챌린지만 조회"
  on public.sub_routine_completions for select
  using (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );

drop policy if exists "sub_routine_completions: 본인 챌린지만 삽입" on public.sub_routine_completions;
create policy "sub_routine_completions: 본인 챌린지만 삽입"
  on public.sub_routine_completions for insert
  with check (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );

drop policy if exists "sub_routine_completions: 본인 챌린지만 삭제" on public.sub_routine_completions;
create policy "sub_routine_completions: 본인 챌린지만 삭제"
  on public.sub_routine_completions for delete
  using (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );


-- ────────────────────────────────────────
-- 7. RLS 정책 — daily_logs
-- ────────────────────────────────────────

drop policy if exists "daily_logs: 본인 챌린지만 조회" on public.daily_logs;
create policy "daily_logs: 본인 챌린지만 조회"
  on public.daily_logs for select
  using (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );

drop policy if exists "daily_logs: 본인 챌린지만 삽입" on public.daily_logs;
create policy "daily_logs: 본인 챌린지만 삽입"
  on public.daily_logs for insert
  with check (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );

drop policy if exists "daily_logs: 본인 챌린지만 삭제" on public.daily_logs;
create policy "daily_logs: 본인 챌린지만 삭제"
  on public.daily_logs for delete
  using (
    exists (
      select 1 from public.challenges c
      where c.id = challenge_id and c.user_id = auth.uid()
    )
  );


-- ────────────────────────────────────────
-- 8. 신규 가입 시 users 행 자동 생성 트리거
-- ────────────────────────────────────────

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.users (id, email, display_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'display_name', 'Streakly User')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
