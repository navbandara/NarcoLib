import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_panel.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class NarcoLibHistoryScreen extends StatelessWidget {
  const NarcoLibHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('BACK'),
        titleSpacing: 0,
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          const AppSectionHeader(
            title: 'SCAN HISTORY',
            subtitle: 'Forensic Archive Database',
          ),
          const SizedBox(height: AppSpacing.lg),
          ..._sampleRecords.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _HistoryRecordCard(record: record),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppPrimaryButton(label: 'NEW FORENSIC SCAN'),
        ],
      ),
    );
  }
}

const List<_HistoryRecord> _sampleRecords = [
  _HistoryRecord(
    title: 'Heroin (Diacetylmorphine)',
    classification: 'Schedule I',
    percentText: '94.7%',
    ageText: '1h ago',
    dateText: '5/6/2026',
    locationText: 'Colombo',
    value: 0.947,
    warning: true,
  ),
  _HistoryRecord(
    title: 'Cocaine Hydrochloride',
    classification: 'Schedule I',
    percentText: '91.3%',
    ageText: '2h ago',
    dateText: '5/6/2026',
    locationText: 'Gampaha',
    value: 0.913,
    warning: true,
  ),
  _HistoryRecord(
    title: 'Aspirin (Acetylsalicylic Acid)',
    classification: 'Non-controlled',
    percentText: '98.2%',
    ageText: '1d ago',
    dateText: '5/5/2026',
    locationText: 'Negombo',
    value: 0.982,
    warning: false,
  ),
  _HistoryRecord(
    title: 'Methamphetamine',
    classification: 'Schedule I',
    percentText: '89.6%',
    ageText: '2d ago',
    dateText: '5/4/2026',
    locationText: 'Kandy',
    value: 0.896,
    warning: true,
  ),
  _HistoryRecord(
    title: 'Fentanyl',
    classification: 'Schedule I',
    percentText: '96.8%',
    ageText: '3d ago',
    dateText: '5/3/2026',
    locationText: 'Colombo',
    value: 0.968,
    warning: true,
  ),
];

class _HistoryRecord {
  const _HistoryRecord({
    required this.title,
    required this.classification,
    required this.percentText,
    required this.ageText,
    required this.dateText,
    required this.locationText,
    required this.value,
    required this.warning,
  });

  final String title;
  final String classification;
  final String percentText;
  final String ageText;
  final String dateText;
  final String locationText;
  final double value;
  final bool warning;
}

class _HistoryRecordCard extends StatelessWidget {
  const _HistoryRecordCard({required this.record});

  final _HistoryRecord record;

  @override
  Widget build(BuildContext context) {
    final accentColor = record.warning ? AppColors.warning : AppColors.primary;
    final badgeColor = record.warning ? AppColors.warningSoft : AppColors.surfaceElevated;

    return AppPanel(
      title: record.title,
      subtitle: record.classification,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            record.percentText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            record.ageText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _HistoryIconBadge(
                warning: record.warning,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${record.dateText} • ${record.locationText}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        height: 6,
                        color: AppColors.surfaceElevated,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: record.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: record.warning
                                    ? [AppColors.warning, AppColors.textMuted]
                                    : [AppColors.primarySoft, AppColors.primary],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, color: AppColors.textSecondary, size: 18),
                const SizedBox(width: 8),
                Text(
                  record.classification,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: record.warning ? AppColors.warning : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryIconBadge extends StatelessWidget {
  const _HistoryIconBadge({required this.warning});

  final bool warning;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = warning ? AppColors.warningSoft : AppColors.surfaceElevated;
    final iconColor = warning ? AppColors.warning : AppColors.primary;
    final icon = warning ? Icons.warning_rounded : Icons.verified_rounded;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}
