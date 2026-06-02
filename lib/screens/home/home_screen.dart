import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/streak_card.dart';
import '../../widgets/routine_item.dart';
import '../../widgets/circular_progress.dart';
import '../challenge/new_challenge_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer2<ChallengeProvider, SettingsProvider>(
        builder: (context, provider, settings, _) {
          final s = settings.strings;
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final allActive = provider.activeChallenges;
          final todaysChallenges = provider.todaysChallenges;
          final weeklyRate = provider.getWeeklyCompletionRate();
          final badges = provider.getBadgesEarned();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ChallengeModeSelector(s: s),
                const SizedBox(height: 20),
                if (allActive.isEmpty) ...[
                  _EmptyState(s: s),
                ] else if (todaysChallenges.isEmpty) ...[
                  _RestDayState(s: s),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: s.weeklyCompletion,
                          value: '$weeklyRate%',
                          icon: Icons.calendar_today_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: s.badgesEarned,
                          value: '$badges',
                          icon: Icons.emoji_events_outlined,
                          color: AppColors.darkAccent,
                          onTap: () => _showBadgesSheet(context, provider, s),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  StreakCard(challenge: todaysChallenges.first),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.todaysRoutines,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        s.doneCount(
                          todaysChallenges.where((c) => c.isTodayCompleted).length,
                          todaysChallenges.length,
                        ),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...todaysChallenges.map(
                    (challenge) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RoutineItem(
                        challenge: challenge,
                        onToggle: () =>
                            provider.toggleTodayComplete(challenge.id),
                        onSubRoutineToggle: (subId) =>
                            provider.toggleSubRoutineComplete(challenge.id, subId),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: s.weeklyCompletion,
                          value: '$weeklyRate%',
                          icon: Icons.calendar_today_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: s.badgesEarned,
                          value: '$badges',
                          icon: Icons.emoji_events_outlined,
                          color: AppColors.darkAccent,
                          onTap: () => _showBadgesSheet(context, provider, s),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_fab',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const NewChallengeScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final dynamic s;

  const _EmptyState({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          CircularProgressWidget(
            progress: 0,
            size: 100,
            child: Image.asset('assets/images/flame.png', width: 36, height: 36),
          ),
          const SizedBox(height: 24),
          Text(
            s.startFirstChallenge,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            s.habitMethodDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _RestDayState extends StatelessWidget {
  final dynamic s;

  const _RestDayState({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          CircularProgressWidget(
            progress: 0,
            size: 100,
            child: Image.asset('assets/images/flame.png', width: 36, height: 36),
          ),
          const SizedBox(height: 24),
          Text(
            s.todayRestDay,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            s.todayRestDayDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeModeSelector extends StatelessWidget {
  final dynamic s;
  const _ChallengeModeSelector({required this.s});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary, width: 1.8),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    s.singleChallenge,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => _showComingSoon(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 1.8),
              ),
              child: Row(
                children: [
                  Icon(Icons.groups_outlined,
                      color: AppColors.textSecondary.withValues(alpha: 0.5), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s.multiChallenge,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    final s = context.read<SettingsProvider>().strings;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.darkAccent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.groups_outlined, color: AppColors.darkAccent, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              s.multiChallenge,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Text(
              s.multiChallengeTeaser,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.darkAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                s.premiumLabel,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkAccent),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

void _showBadgesSheet(
    BuildContext context, ChallengeProvider provider, dynamic s) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BadgesSheet(provider: provider, s: s),
  );
}

class _BadgeItem {
  final String title;
  final String challengeName;
  final IconData icon;
  final Color color;

  const _BadgeItem({
    required this.title,
    required this.challengeName,
    required this.icon,
    required this.color,
  });
}

List<_BadgeItem> _computeBadges(ChallengeProvider provider, dynamic s) {
  final result = <_BadgeItem>[];
  for (final c in provider.challenges) {
    if (c.completedDays.length >= 7) {
      result.add(_BadgeItem(
        title: s.badge7Days,
        challengeName: c.name,
        icon: Icons.local_fire_department,
        color: AppColors.primary,
      ));
    }
    if (c.completedDays.length >= 14) {
      result.add(_BadgeItem(
        title: s.badge14Days,
        challengeName: c.name,
        icon: Icons.bolt,
        color: AppColors.darkAccent,
      ));
    }
    if (c.isCompleted) {
      result.add(_BadgeItem(
        title: s.badgeCompleted,
        challengeName: c.name,
        icon: Icons.emoji_events,
        color: AppColors.success,
      ));
    }
  }
  return result;
}

class _BadgesSheet extends StatelessWidget {
  final ChallengeProvider provider;
  final dynamic s;

  const _BadgesSheet({required this.provider, required this.s});

  @override
  Widget build(BuildContext context) {
    final badges = _computeBadges(provider, s);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              s.badgesTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          if (badges.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                s.noBadgesYet,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, height: 1.6),
              ),
            )
          else
            ...badges.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: b.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(b.icon, color: b.color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            b.challengeName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
