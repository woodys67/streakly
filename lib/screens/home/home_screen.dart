import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/challenge_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/streak_card.dart';
import '../../widgets/routine_item.dart';
import '../../widgets/circular_progress.dart';
import '../challenge/new_challenge_screen.dart';

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
        actions: const [],
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (allActive.isEmpty) ...[
                  _EmptyState(s: s),
                ] else if (todaysChallenges.isEmpty) ...[
                  _RestDayState(s: s),
                  const SizedBox(height: 24),
                  _StatCard(
                    title: s.weeklyCompletion,
                    value: '$weeklyRate%',
                    icon: Icons.calendar_today_outlined,
                    color: AppColors.primary,
                  ),
                ] else ...[
                  const StreakCard(),
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
                        canRecover: provider.canRecoverStreak(challenge),
                        onRecover: () => _showRecoverDialog(context, provider, settings, challenge.id),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _StatCard(
                    title: s.weeklyCompletion,
                    value: '$weeklyRate%',
                    icon: Icons.calendar_today_outlined,
                    color: AppColors.primary,
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

  Future<void> _showRecoverDialog(
    BuildContext context,
    ChallengeProvider provider,
    SettingsProvider settings,
    String challengeId,
  ) async {
    final s = settings.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.recoverStreakConfirmTitle),
        content: Text(s.recoverStreakConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text(s.recoverStreak),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await provider.recoverStreak(challengeId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.streakRecovered),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
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

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
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
    );
  }
}


