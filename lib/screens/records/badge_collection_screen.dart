import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_strings.dart';
import '../../models/badge_definition.dart';
import '../../providers/badge_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/badge_catalog.dart';
import '../../theme/app_theme.dart';

class BadgeCollectionScreen extends StatefulWidget {
  const BadgeCollectionScreen({super.key});

  @override
  State<BadgeCollectionScreen> createState() => _BadgeCollectionScreenState();
}

class _BadgeCollectionScreenState extends State<BadgeCollectionScreen> {
  BadgeCategory? _selectedCategory;

  Map<BadgeCategory?, String> _categoryLabels(AppStrings s) => {
    null: s.badgeCategoryAll,
    BadgeCategory.streak: s.badgeCategoryStreak,
    BadgeCategory.completion: s.badgeCategoryCompletion,
    BadgeCategory.logging: s.badgeCategoryLogging,
    BadgeCategory.timing: s.badgeCategoryTiming,
    BadgeCategory.subroutine: s.badgeCategorySubroutine,
    BadgeCategory.team: s.badgeCategoryTeam,
  };

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>().strings;
    final badgeProvider = context.watch<BadgeProvider>();
    final allBadges = BadgeCatalog.all;
    final filtered = _selectedCategory == null
        ? allBadges
        : allBadges.where((b) => b.category == _selectedCategory).toList();
    final earnedCount = badgeProvider.earned.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.badgeCollectionTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$earnedCount / ${allBadges.length}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _ProgressBar(earned: earnedCount, total: allBadges.length),
          _CategoryFilter(
            selected: _selectedCategory,
            onChanged: (c) => setState(() => _selectedCategory = c),
            labels: _categoryLabels(s),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final badge = filtered[i];
                final earned = badgeProvider.hasEarned(badge.id);
                return GestureDetector(
                  onTap: () => _showDetail(context, badge, badgeProvider),
                  child: _BadgeCell(badge: badge, earned: earned),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetail(
    BuildContext context,
    BadgeDefinition badge,
    BadgeProvider provider,
  ) {
    final earned = provider.hasEarned(badge.id);
    final earnedAt = provider.earnedAt(badge.id);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _BadgeDetailSheet(
        badge: badge,
        earned: earned,
        earnedAt: earnedAt,
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int earned;
  final int total;

  const _ProgressBar({required this.earned, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.read<SettingsProvider>().strings.badgeEarnedSection,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '$earned / $total',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? earned / total : 0,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final BadgeCategory? selected;
  final void Function(BadgeCategory?) onChanged;
  final Map<BadgeCategory?, String> labels;

  const _CategoryFilter({
    required this.selected,
    required this.onChanged,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: labels.entries.map((e) {
          final isSelected = selected == e.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(e.key),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  e.value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BadgeCell extends StatelessWidget {
  final BadgeDefinition badge;
  final bool earned;

  const _BadgeCell({required this.badge, required this.earned});

  @override
  Widget build(BuildContext context) {
    final isSecret = badge.isSecret && !earned;

    return Container(
      decoration: BoxDecoration(
        color: earned ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: earned ? _rarityBorderColor(badge.rarity) : Colors.grey[300]!,
          width: earned ? 2 : 1,
        ),
        boxShadow: earned
            ? [
                BoxShadow(
                  color: _rarityBorderColor(badge.rarity).withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isSecret
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Text(badge.icon,
                        style: const TextStyle(fontSize: 28)),
                  ),
                )
              : ColorFiltered(
                  colorFilter: earned
                      ? const ColorFilter.mode(
                          Colors.transparent, BlendMode.saturation)
                      : const ColorFilter.matrix([
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0,      0,      0,      1, 0,
                        ]),
                  child: Text(badge.icon,
                      style: const TextStyle(fontSize: 28)),
                ),
          const SizedBox(height: 4),
          Text(
            isSecret ? '???' : badge.nameKo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: earned ? Colors.grey[800] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeDetailSheet extends StatelessWidget {
  final BadgeDefinition badge;
  final bool earned;
  final DateTime? earnedAt;

  const _BadgeDetailSheet({
    required this.badge,
    required this.earned,
    required this.earnedAt,
  });

  @override
  Widget build(BuildContext context) {
    final isSecret = badge.isSecret && !earned;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            badge.icon,
            style: TextStyle(
              fontSize: 56,
              color: earned ? null : Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isSecret ? '???' : badge.nameKo,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!isSecret) ...[
            const SizedBox(height: 4),
            Text(
              badge.nameEn,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
          const SizedBox(height: 8),
          _RarityRow(rarity: badge.rarity),
          const SizedBox(height: 12),
          Text(
            isSecret ? context.read<SettingsProvider>().strings.badgeSecretCondition : badge.descKo,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          if (earned && earnedAt != null) ...[
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    context.read<SettingsProvider>().strings.badgeEarnedOn(earnedAt!),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RarityRow extends StatelessWidget {
  final BadgeRarity rarity;

  const _RarityRow({required this.rarity});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (rarity) {
      BadgeRarity.common => ('Common', const Color(0xFF757575)),
      BadgeRarity.rare => ('Rare', const Color(0xFF4A90E2)),
      BadgeRarity.epic => ('Epic', const Color(0xFFFF8C00)),
      BadgeRarity.legendary => ('Legendary', const Color(0xFFFFD700)),
      BadgeRarity.secret => ('Secret', const Color(0xFF555555)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

Color _rarityBorderColor(BadgeRarity rarity) => switch (rarity) {
      BadgeRarity.common => const Color(0xFFBDBDBD),
      BadgeRarity.rare => const Color(0xFF4A90E2),
      BadgeRarity.epic => const Color(0xFFFF8C00),
      BadgeRarity.legendary => const Color(0xFFFFD700),
      BadgeRarity.secret => const Color(0xFF555555),
    };
