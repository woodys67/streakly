import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/challenge.dart';
import '../../providers/auth_provider.dart';
import '../../providers/badge_provider.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/streak_race_provider.dart';
import '../../services/badge_catalog.dart';
import '../../theme/app_theme.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/native_ad_card.dart';
import '../auth/landing_screen.dart';
import 'badge_collection_screen.dart';
import 'completed_challenge_detail_screen.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/flame.png', width: 22, height: 22),
            const SizedBox(width: 8),
            Text(
              'Streakly',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      body: Consumer<StreakRaceProvider>(
        builder: (context, streakRace, _) =>
        Consumer4<ChallengeProvider, SettingsProvider, BadgeProvider, SubscriptionProvider>(
        builder: (context, challengeProvider, settingsProvider, badgeProvider, subscription, _) {
          final s = settingsProvider.strings;
          final userName = settingsProvider.userName;
          final totalStreak = challengeProvider.totalStreak;
          final longestStreak = challengeProvider.longestStreak;
          final totalRecoveries = challengeProvider.totalRecoveries;
          final completed = challengeProvider.completedChallenges;
          final allChallenges = challengeProvider.challenges;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileHeader(userName: userName),
                const SizedBox(height: 20),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => _StreakRaceSection(
                    isGuest: auth.isGuest,
                    streakRace: streakRace,
                    myDisplayName: settingsProvider.userName,
                  ),
                ),
                const SizedBox(height: 16),
                _BadgeSummaryCard(badgeProvider: badgeProvider),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: s.totalStreaks,
                        value: '$totalStreak',
                        bgColor: AppColors.darkAccent,
                        icon: Icons.local_fire_department,
                        tooltip: s.totalStreaksInfo,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: s.completed,
                        value: '${completed.length}',
                        bgColor: AppColors.success,
                        icon: Icons.emoji_events,
                        tooltip: s.completedInfo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: s.longestStreakLabel,
                        value: '$longestStreak',
                        bgColor: const Color(0xFF9C27B0),
                        icon: Icons.military_tech,
                        tooltip: s.longestStreakInfo,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        title: s.streakRecoveryLabel,
                        value: '$totalRecoveries',
                        bgColor: const Color(0xFF0288D1),
                        icon: Icons.refresh,
                        tooltip: s.streakRecoveryInfo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!subscription.isPremium) const NativeAdCard(),
                const SizedBox(height: 24),
                Text(
                  s.completedChallenges,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                if (allChallenges.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        s.noRecordsYet,
                        style: TextStyle(color: context.colorTextSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (completed.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        s.keepGoingRecords,
                        style: TextStyle(color: context.colorTextSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...completed.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CompletedChallengeDetailScreen(challenge: c),
                          ),
                        ),
                        child: _CompletedChallengeCard(challenge: c),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}

class _BadgeSummaryCard extends StatelessWidget {
  final BadgeProvider badgeProvider;

  const _BadgeSummaryCard({required this.badgeProvider});

  @override
  Widget build(BuildContext context) {
    final earned = badgeProvider.earned;
    final total = BadgeCatalog.all.length;
    final recentBadges = earned.toList()
      ..sort((a, b) => b.earnedAt.compareTo(a.earnedAt));
    final displayBadges = recentBadges.take(5).toList();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BadgeCollectionScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colorOutline, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  context.read<SettingsProvider>().strings.badgeCollectionTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.colorTextPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Tooltip(
                  message: context.read<SettingsProvider>().strings.badgeCollectionInfo,
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(color: Colors.white, fontSize: 13),
                  preferBelow: false,
                  child: Icon(Icons.info_outline, size: 16, color: context.colorTextSecondary),
                ),
                const Spacer(),
                Text(
                  '${earned.length} / $total',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: context.colorTextSecondary,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? earned.length / total : 0,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            if (displayBadges.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: displayBadges.map((ub) {
                  final def = BadgeCatalog.findById(ub.badgeId);
                  if (def == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Tooltip(
                      message: def.nameKo,
                      child: Image.asset(def.imagePath, width: 36, height: 36),
                    ),
                  );
                }).toList(),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(
                context.read<SettingsProvider>().strings.badgeEarnedEmpty,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String userName;

  const _ProfileHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(Icons.person, color: AppColors.primary, size: 28),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                context.watch<SettingsProvider>().strings.habitBuilder,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color bgColor;
  final IconData icon;
  final String tooltip;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.bgColor,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.white, size: 24),
              Tooltip(
                message: tooltip,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(color: Colors.white, fontSize: 13),
                preferBelow: false,
                child: const Icon(Icons.info_outline, color: AppColors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedChallengeCard extends StatelessWidget {
  final Challenge challenge;

  const _CompletedChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    final successRate = challenge.successRate;
    final successPercent = (successRate * 100).round();
    final startStr = DateFormat('MMM d').format(challenge.startDate);
    final endDate = challenge.startDate
        .add(Duration(days: challenge.targetDays - 1));
    final endStr = DateFormat('MMM d, yyyy').format(endDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorOutline, width: 1.5),
      ),
      child: Row(
        children: [
          CircularProgressWidget(
            progress: successRate,
            size: 56,
            strokeWidth: 6,
            progressColor: AppColors.success,
            child: Text(
              '$successPercent%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text('$startStr - $endStr', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  context.watch<SettingsProvider>().strings.challengeSummary(
                        challenge.targetDays,
                        challenge.completedDays.length,
                      ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: context.colorTextSecondary,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Streak Race Section
// ─────────────────────────────────────────────────────────────────────────────

class _StreakRaceSection extends StatelessWidget {
  final bool isGuest;
  final StreakRaceProvider streakRace;
  final String myDisplayName;

  const _StreakRaceSection({
    required this.isGuest,
    required this.streakRace,
    required this.myDisplayName,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  s.streakRaceTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            GestureDetector(
              onTap: () => streakRace.refresh(),
              child: Icon(Icons.refresh, size: 20, color: context.colorTextSecondary),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          s.streakRaceSubtitle,
          style: TextStyle(fontSize: 12, color: context.colorTextSecondary),
        ),
        const SizedBox(height: 12),
        _StreakRaceContent(
          streakRace: streakRace,
          myDisplayName: myDisplayName,
          isGuest: isGuest,
        ),
      ],
    );
  }
}

class _StreakRaceContent extends StatelessWidget {
  final StreakRaceProvider streakRace;
  final String myDisplayName;
  final bool isGuest;

  const _StreakRaceContent({
    required this.streakRace,
    required this.myDisplayName,
    required this.isGuest,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    final leaderboard = streakRace.leaderboard;
    final myRank = streakRace.myRank;
    final isLoading = streakRace.isLoading;
    final myUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

    // Show top 3 only in the main list
    final displayEntries = leaderboard.take(3).toList();
    final showMyRow = !isGuest && myRank > 0;

    // Use DB display_name from leaderboard if available (authoritative), else fall back to local settings
    final myLeaderboardEntry = leaderboard.where((e) => e.userId == myUserId).firstOrNull;
    final myActualDisplayName = myLeaderboardEntry?.displayName ?? myDisplayName;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colorSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorOutline),
      ),
      child: Column(
        children: [
          if (isLoading && leaderboard.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else if (displayEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                s.streakRaceEmpty,
                style: TextStyle(color: context.colorTextSecondary),
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            _PodiumSection(
              entries: displayEntries,
              myUserId: myUserId,
              isGuest: isGuest,
              dayUnit: s.streakRaceDayUnit,
              meLabel: s.streakRaceMe,
            ),
            // 4th row: always show current user (even if they're in top 3)
            if (showMyRow) ...[
              Divider(height: 1, color: context.colorOutline),
              _RankRow(
                entry: StreakRaceEntry(
                  userId: myUserId,
                  displayName: myActualDisplayName,
                  monthlyPoints: streakRace.myMonthlyPoints,
                  rank: myRank,
                ),
                isMe: true,
                isLast: true,
                dayUnit: s.streakRaceDayUnit,
                meLabel: s.streakRaceMe,
              ),
            ],
            // Guest CTA
            if (isGuest) _GuestRankRow(),
          ],
        ],
      ),
    );
  }
}

class _PodiumSection extends StatelessWidget {
  final List<StreakRaceEntry> entries;
  final String myUserId;
  final bool isGuest;
  final String dayUnit;
  final String meLabel;

  const _PodiumSection({
    required this.entries,
    required this.myUserId,
    required this.isGuest,
    required this.dayUnit,
    required this.meLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(entries.length, (i) {
          final entry = entries[i];
          final isMe = !isGuest && entry.userId == myUserId;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
              child: _PodiumCard(
                entry: entry,
                isMe: isMe,
                dayUnit: dayUnit,
                meLabel: meLabel,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final StreakRaceEntry entry;
  final bool isMe;
  final String dayUnit;
  final String meLabel;

  const _PodiumCard({
    required this.entry,
    required this.isMe,
    required this.dayUnit,
    required this.meLabel,
  });

  @override
  Widget build(BuildContext context) {
    const medals = ['🥇', '🥈', '🥉'];
    final medal = entry.rank >= 1 && entry.rank <= 3
        ? medals[entry.rank - 1]
        : '${entry.rank}';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.primary.withValues(alpha: 0.08)
            : context.colorOutline.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(medal, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Text(
            entry.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
              color: isMe ? AppColors.primary : context.colorTextPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (isMe) ...[
            const SizedBox(height: 3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                meLabel,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${entry.monthlyPoints} $dayUnit',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final StreakRaceEntry entry;
  final bool isMe;
  final bool isLast;
  final String dayUnit;
  final String meLabel;

  const _RankRow({
    required this.entry,
    required this.isMe,
    required this.isLast,
    required this.dayUnit,
    this.meLabel = 'Me',
  });

  @override
  Widget build(BuildContext context) {
    final rank = entry.rank;
    final isTop3 = rank <= 3;
    const medals = ['🥇', '🥈', '🥉'];

    return Container(
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary.withValues(alpha: 0.08) : null,
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: context.colorOutline, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: isTop3
                ? Text(medals[rank - 1], style: const TextStyle(fontSize: 18))
                : Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isMe ? AppColors.primary : context.colorTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    entry.displayName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                      color: isMe ? AppColors.primary : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      meLabel,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isTop3
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : context.colorOutline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${entry.monthlyPoints} $dayUnit',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isTop3 ? AppColors.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestRankRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    return Container(
      decoration: BoxDecoration(
        color: context.colorSurface,
        border: Border(top: BorderSide(color: context.colorOutline)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colorOutline.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline, size: 18, color: context.colorTextSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.streakRaceGuestPrompt,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  s.streakRaceGuestDesc,
                  style: TextStyle(fontSize: 11, color: context.colorTextSecondary),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => LandingScreen(onContinueAsGuest: () {}),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              s.streakRaceGuestLogin,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
