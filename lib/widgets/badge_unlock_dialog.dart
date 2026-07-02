import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/badge_definition.dart';
import '../providers/settings_provider.dart';

class BadgeUnlockDialog extends StatefulWidget {
  final BadgeDefinition badge;
  final VoidCallback onDismiss;

  const BadgeUnlockDialog({
    super.key,
    required this.badge,
    required this.onDismiss,
  });

  @override
  State<BadgeUnlockDialog> createState() => _BadgeUnlockDialogState();
}

class _BadgeUnlockDialogState extends State<BadgeUnlockDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: _BadgeCard(
              badge: widget.badge,
              onDismiss: widget.onDismiss,
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeDefinition badge;
  final VoidCallback onDismiss;

  const _BadgeCard({required this.badge, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final colors = _rarityColors(badge.rarity);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(24),
        border: colors.border != null
            ? Border.all(color: colors.border!, width: 3)
            : null,
        boxShadow: [
          BoxShadow(
            color: (colors.border ?? Colors.grey).withValues(alpha: 0.4),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.read<SettingsProvider>().strings.badgeUnlockTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.8),
              border: colors.border != null
                  ? Border.all(color: colors.border!, width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: (colors.border ?? Colors.orange).withValues(alpha: 0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(badge.imagePath, width: 64, height: 64),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            badge.localizedName(context.read<SettingsProvider>().strings.language),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge.nameEn,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          _RarityChip(rarity: badge.rarity),
          const SizedBox(height: 12),
          Text(
            badge.localizedDesc(context.read<SettingsProvider>().strings.language),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF424242)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.border ?? const Color(0xFFFF8C00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.read<SettingsProvider>().strings.ok,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RarityChip extends StatelessWidget {
  final BadgeRarity rarity;

  const _RarityChip({required this.rarity});

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _RarityColors {
  final Color background;
  final Color? border;

  const _RarityColors({required this.background, this.border});
}

_RarityColors _rarityColors(BadgeRarity rarity) {
  return switch (rarity) {
    BadgeRarity.common => const _RarityColors(background: Color(0xFFF5F5F5)),
    BadgeRarity.rare =>
      const _RarityColors(background: Color(0xFFDBEAFE), border: Color(0xFF4A90E2)),
    BadgeRarity.epic =>
      const _RarityColors(background: Color(0xFFFFF3E0), border: Color(0xFFFF8C00)),
    BadgeRarity.legendary =>
      const _RarityColors(background: Color(0xFFFFFDE7), border: Color(0xFFFFD700)),
    BadgeRarity.secret =>
      const _RarityColors(background: Color(0xFF2A2A2A), border: Color(0xFF555555)),
  };
}
