enum BadgeCategory { streak, completion, logging, timing, subroutine, team }
enum BadgeRarity { common, rare, epic, legendary, secret }

class BadgeDefinition {
  final String id;
  final String nameKo;
  final String nameEn;
  final String icon;
  final String descKo;
  final String descEn;
  final BadgeCategory category;
  final BadgeRarity rarity;
  final bool isSecret;

  const BadgeDefinition({
    required this.id,
    required this.nameKo,
    required this.nameEn,
    required this.icon,
    required this.descKo,
    required this.descEn,
    required this.category,
    required this.rarity,
    this.isSecret = false,
  });
}
