import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../theme/app_theme.dart';

class GuideDetailScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const GuideDetailScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
      body: Markdown(
        data: content,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        styleSheet: _buildStyleSheet(context),
        selectable: false,
      ),
    );
  }

  MarkdownStyleSheet _buildStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    return MarkdownStyleSheet(
      h2: theme.textTheme.titleLarge?.copyWith(
        color: context.colorTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      h3: theme.textTheme.titleMedium?.copyWith(
        color: context.colorTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      p: theme.textTheme.bodyMedium?.copyWith(
        color: context.colorTextPrimary,
        height: 1.65,
      ),
      strong: theme.textTheme.bodyMedium?.copyWith(
        color: context.colorTextPrimary,
        fontWeight: FontWeight.bold,
      ),
      blockquote: theme.textTheme.bodyMedium?.copyWith(
        color: context.colorTextSecondary,
        height: 1.5,
      ),
      blockquoteDecoration: BoxDecoration(
        color: AppColors.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: AppColors.primary, width: 3),
        ),
      ),
      blockquotePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      listBullet: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary),
      tableHead: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorTextPrimary,
      ),
      tableBody: theme.textTheme.bodySmall?.copyWith(
        color: context.colorTextPrimary,
        height: 1.5,
      ),
      tableHeadAlign: TextAlign.left,
      tableBorder: TableBorder.all(color: context.colorOutline, width: 1),
      tableColumnWidth: const FlexColumnWidth(),
      tableCellsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colorOutline, width: 1)),
      ),
      h2Padding: const EdgeInsets.only(top: 24, bottom: 8),
      h3Padding: const EdgeInsets.only(top: 16, bottom: 4),
    );
  }
}
