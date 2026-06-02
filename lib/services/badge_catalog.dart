import '../models/badge_definition.dart';

class BadgeCatalog {
  static const List<BadgeDefinition> all = [
    // ── 스트릭 (12개) ──────────────────────────────────────────
    BadgeDefinition(
      id: 'streak_001', nameKo: '첫 불꽃', nameEn: 'First Spark', icon: '🔥',
      descKo: '첫 스트릭 1일 달성', descEn: 'Achieve your first 1-day streak',
      category: BadgeCategory.streak, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'streak_002', nameKo: '불씨', nameEn: 'Ember', icon: '🔥',
      descKo: '스트릭 3일 연속', descEn: '3-day streak',
      category: BadgeCategory.streak, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'streak_003', nameKo: '작은 불꽃', nameEn: 'Kindling', icon: '🔥',
      descKo: '스트릭 7일 연속', descEn: '7-day streak',
      category: BadgeCategory.streak, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'streak_004', nameKo: '모닥불', nameEn: 'Campfire', icon: '🪵',
      descKo: '스트릭 14일 연속', descEn: '14-day streak',
      category: BadgeCategory.streak, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'streak_005', nameKo: '화톳불', nameEn: 'Bonfire', icon: '✨',
      descKo: '스트릭 21일 연속', descEn: '21-day streak',
      category: BadgeCategory.streak, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'streak_006', nameKo: '용광로', nameEn: 'Furnace', icon: '⚡',
      descKo: '스트릭 30일 연속', descEn: '30-day streak',
      category: BadgeCategory.streak, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'streak_007', nameKo: '불의 지배자', nameEn: 'Fire Lord', icon: '🌋',
      descKo: '스트릭 50일 연속', descEn: '50-day streak',
      category: BadgeCategory.streak, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'streak_008', nameKo: '태양', nameEn: 'The Sun', icon: '☀️',
      descKo: '스트릭 66일 연속 (습관 완전 정착)', descEn: '66-day streak — habit fully formed',
      category: BadgeCategory.streak, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'streak_009', nameKo: '영원한 불꽃', nameEn: 'Eternal Flame', icon: '🌟',
      descKo: '스트릭 100일 연속', descEn: '100-day streak',
      category: BadgeCategory.streak, rarity: BadgeRarity.legendary,
    ),
    BadgeDefinition(
      id: 'streak_010', nameKo: '불사조', nameEn: 'Phoenix', icon: '🦅',
      descKo: '스트릭이 끊긴 후 재시작해 이전 최고 기록 경신', descEn: 'Break your own streak record after a reset',
      category: BadgeCategory.streak, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'streak_011', nameKo: '부활', nameEn: 'Comeback', icon: '↩️',
      descKo: '스트릭 0에서 7일 이상 회복', descEn: 'Recover to 7+ days after a streak break',
      category: BadgeCategory.streak, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'streak_012', nameKo: '올해의 불꽃', nameEn: 'Year of Fire', icon: '📅',
      descKo: '한 해에 누적 스트릭 300일 이상', descEn: '300+ cumulative streak days in a year',
      category: BadgeCategory.streak, rarity: BadgeRarity.legendary,
    ),

    // ── 챌린지 완주 (10개) ────────────────────────────────────
    BadgeDefinition(
      id: 'complete_001', nameKo: '첫 완주', nameEn: 'First Finish', icon: '🎯',
      descKo: '챌린지 최초 1회 완료', descEn: 'Complete your first challenge',
      category: BadgeCategory.completion, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'complete_002', nameKo: '세 번의 약속', nameEn: 'Triple Vow', icon: '🏅',
      descKo: '챌린지 3회 완료', descEn: 'Complete 3 challenges',
      category: BadgeCategory.completion, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'complete_003', nameKo: '10전 10승', nameEn: 'Perfect Ten', icon: '🔟',
      descKo: '챌린지 10회 완료', descEn: 'Complete 10 challenges',
      category: BadgeCategory.completion, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'complete_004', nameKo: '챌린지 마스터', nameEn: 'Challenge Master', icon: '🎓',
      descKo: '챌린지 25회 완료', descEn: 'Complete 25 challenges',
      category: BadgeCategory.completion, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'complete_005', nameKo: '완벽주의자', nameEn: 'Perfectionist', icon: '💎',
      descKo: '한 챌린지를 완료율 100%로 완주', descEn: 'Complete a challenge with 100% success rate',
      category: BadgeCategory.completion, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'complete_006', nameKo: '두 번의 완벽', nameEn: 'Double Perfect', icon: '💎',
      descKo: '완료율 100% 챌린지 2회 연속', descEn: '100% success rate on 2 consecutive challenges',
      category: BadgeCategory.completion, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'complete_007', nameKo: '끝까지', nameEn: 'All the Way', icon: '🏁',
      descKo: '28일 이상 커스텀 챌린지 완료', descEn: 'Complete a 28+ day challenge',
      category: BadgeCategory.completion, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'complete_008', nameKo: '삼관왕', nameEn: 'Triple Crown', icon: '👑',
      descKo: '서로 다른 목표명으로 각 1회씩 3회 완료', descEn: 'Complete 3 challenges with different names',
      category: BadgeCategory.completion, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'complete_009', nameKo: '한 해의 왕', nameEn: 'Champion of the Year', icon: '🏆',
      descKo: '한 해에 챌린지 12회 완료', descEn: 'Complete 12 challenges in one year',
      category: BadgeCategory.completion, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'complete_010', nameKo: '전설의 시작', nameEn: 'Legend Begins', icon: '⚜️',
      descKo: '누적 완료율 80% 이상 유지하며 챌린지 20회 완료', descEn: 'Complete 20 challenges with 80%+ average success rate',
      category: BadgeCategory.completion, rarity: BadgeRarity.legendary,
    ),

    // ── 기록 습관 (8개) ───────────────────────────────────────
    BadgeDefinition(
      id: 'log_001', nameKo: '첫 기록', nameEn: 'First Entry', icon: '✏️',
      descKo: '데일리 로그 최초 작성', descEn: 'Write your first daily log',
      category: BadgeCategory.logging, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'log_002', nameKo: '일주일 일기', nameEn: 'Week Diary', icon: '📒',
      descKo: '7일 연속 데일리 로그 작성', descEn: 'Write daily logs for 7 consecutive days',
      category: BadgeCategory.logging, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'log_003', nameKo: '21일 일기', nameEn: '21-Day Journal', icon: '📔',
      descKo: '챌린지 21일 동안 매일 로그 작성', descEn: 'Write logs for 21 consecutive days',
      category: BadgeCategory.logging, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'log_004', nameKo: '소설가', nameEn: 'Novelist', icon: '📖',
      descKo: '누적 데일리 로그 100개 작성', descEn: 'Write 100 total daily logs',
      category: BadgeCategory.logging, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'log_005', nameKo: '말이 많은 날', nameEn: 'Verbose Day', icon: '💬',
      descKo: '한 번의 로그에 200자 이상 작성', descEn: 'Write a log with 200+ characters',
      category: BadgeCategory.logging, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'log_006', nameKo: '돌아보기', nameEn: 'Reflector', icon: '🔍',
      descKo: '완료된 챌린지의 로그를 30일 후 다시 열람', descEn: 'Revisit a completed challenge log after 30 days',
      category: BadgeCategory.logging, rarity: BadgeRarity.secret, isSecret: true,
    ),
    BadgeDefinition(
      id: 'log_007', nameKo: '연대기 작가', nameEn: 'Chronicler', icon: '📜',
      descKo: '누적 데일리 로그 500개 작성', descEn: 'Write 500 total daily logs',
      category: BadgeCategory.logging, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'log_008', nameKo: '기억의 수호자', nameEn: 'Memory Keeper', icon: '🗂️',
      descKo: '1년 이상 기간 동안 로그 기록 지속', descEn: 'Keep logging for over 1 year',
      category: BadgeCategory.logging, rarity: BadgeRarity.legendary,
    ),

    // ── 시간 & 루틴 패턴 (8개) ───────────────────────────────
    BadgeDefinition(
      id: 'timing_001', nameKo: '새벽 전사', nameEn: 'Dawn Warrior', icon: '🌅',
      descKo: '오전 6시 이전 체크인 7회', descEn: 'Check in before 6am 7 times',
      category: BadgeCategory.timing, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'timing_002', nameKo: '아침형 인간', nameEn: 'Morning Person', icon: '☀️',
      descKo: '오전 9시 이전 체크인 21회 연속', descEn: '21 consecutive morning check-ins before 9am',
      category: BadgeCategory.timing, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'timing_003', nameKo: '야행성', nameEn: 'Night Owl', icon: '🌙',
      descKo: '자정(00:00) 이후 체크인 5회', descEn: 'Check in after midnight 5 times',
      category: BadgeCategory.timing, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'timing_004', nameKo: '칼같은 시간', nameEn: 'Clockwork', icon: '⏱️',
      descKo: '알림 시간 ±15분 이내 체크인 10회', descEn: 'Check in within ±15 minutes of reminder 10 times',
      category: BadgeCategory.timing, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'timing_005', nameKo: '주말 전사', nameEn: 'Weekend Warrior', icon: '🎉',
      descKo: '토+일 연속 체크인 4주', descEn: 'Check in on weekends for 4 consecutive weeks',
      category: BadgeCategory.timing, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'timing_006', nameKo: '월화수목금', nameEn: 'Weekday Grind', icon: '💼',
      descKo: '월~금 체크인 4주 연속', descEn: 'Check in on weekdays for 4 consecutive weeks',
      category: BadgeCategory.timing, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'timing_007', nameKo: '자정의 약속', nameEn: 'Midnight Promise', icon: '🕛',
      descKo: '23:59 이내 체크인 3회', descEn: 'Check in at 23:59 three times',
      category: BadgeCategory.timing, rarity: BadgeRarity.secret, isSecret: true,
    ),
    BadgeDefinition(
      id: 'timing_008', nameKo: '신년 첫날', nameEn: 'New Year, New Me', icon: '🎆',
      descKo: '1월 1일 체크인', descEn: 'Check in on January 1st',
      category: BadgeCategory.timing, rarity: BadgeRarity.secret, isSecret: true,
    ),

    // ── 서브루틴 (6개) ────────────────────────────────────────
    BadgeDefinition(
      id: 'sub_001', nameKo: '첫 서브루틴', nameEn: 'Sub Starter', icon: '➕',
      descKo: '서브루틴 포함 챌린지 최초 생성', descEn: 'Create your first challenge with subroutines',
      category: BadgeCategory.subroutine, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'sub_002', nameKo: '멀티태스커', nameEn: 'Multitasker', icon: '🔀',
      descKo: '서브루틴 3개 이상 포함 챌린지 완료', descEn: 'Complete a challenge with 3+ subroutines',
      category: BadgeCategory.subroutine, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'sub_003', nameKo: '서브루틴 달인', nameEn: 'Subroutine Master', icon: '🎛️',
      descKo: '서브루틴 5개 이상 + 완료율 90% 이상 완주', descEn: 'Complete a challenge with 5+ subroutines at 90%+ rate',
      category: BadgeCategory.subroutine, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'sub_004', nameKo: '동시에', nameEn: 'Parallel Runner', icon: '⚡',
      descKo: '챌린지 2개 동시 진행 중 둘 다 체크인 7일', descEn: 'Check in on 2 simultaneous challenges for 7 days',
      category: BadgeCategory.subroutine, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'sub_005', nameKo: '모두 완료', nameEn: 'Full Sweep', icon: '✅',
      descKo: '메인+서브 전부 당일 완료 21회', descEn: 'Complete all main + sub routines in one day 21 times',
      category: BadgeCategory.subroutine, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'sub_006', nameKo: '궁극의 루틴', nameEn: 'Ultimate Routine', icon: '🌐',
      descKo: '서브루틴 5개 포함 챌린지 100% 완료율로 완주', descEn: 'Complete a challenge with 5+ subroutines at 100% rate',
      category: BadgeCategory.subroutine, rarity: BadgeRarity.legendary,
    ),

    // ── 팀 챌린지 (6개) — PRO 전용 ───────────────────────────
    BadgeDefinition(
      id: 'team_001', nameKo: '팀 플레이어', nameEn: 'Team Player', icon: '🤝',
      descKo: '팀 챌린지 최초 참가', descEn: 'Join your first team challenge',
      category: BadgeCategory.team, rarity: BadgeRarity.common,
    ),
    BadgeDefinition(
      id: 'team_002', nameKo: '팀장', nameEn: 'Squad Leader', icon: '🎖️',
      descKo: '팀 챌린지 생성 후 완주까지 이끌기', descEn: 'Lead a team challenge to completion',
      category: BadgeCategory.team, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'team_003', nameKo: '팀 완주', nameEn: 'All for One', icon: '🏆',
      descKo: '팀원 전원 챌린지 100% 완료', descEn: 'All team members complete the challenge at 100%',
      category: BadgeCategory.team, rarity: BadgeRarity.epic,
    ),
    BadgeDefinition(
      id: 'team_004', nameKo: '응원단장', nameEn: 'Biggest Fan', icon: '📣',
      descKo: '하루 팀원 3명 모두 응원 반응 보내기 7일', descEn: 'Cheer all 3 teammates for 7 days',
      category: BadgeCategory.team, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'team_005', nameKo: '팀 MVP', nameEn: 'Team MVP', icon: '⭐',
      descKo: '팀 챌린지 종료 시 팀 내 1위', descEn: 'Finish #1 in a team challenge',
      category: BadgeCategory.team, rarity: BadgeRarity.rare,
    ),
    BadgeDefinition(
      id: 'team_006', nameKo: '전설의 팀', nameEn: 'Legendary Crew', icon: '🌟',
      descKo: '같은 팀원과 3회 이상 팀 챌린지 완주', descEn: 'Complete 3+ team challenges with the same teammates',
      category: BadgeCategory.team, rarity: BadgeRarity.legendary,
    ),
  ];

  static BadgeDefinition? findById(String id) {
    try {
      return all.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<BadgeDefinition> byCategory(BadgeCategory category) =>
      all.where((b) => b.category == category).toList();
}
