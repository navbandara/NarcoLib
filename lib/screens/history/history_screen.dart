import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<_HistoryRecord> _records;

  @override
  void initState() {
    super.initState();
    _records = List.from(_sampleRecords);
  }

  void _deleteRecord(int index, _HistoryRecord record) {
    setState(() {
      _records.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${record.title} removed from history.'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.primary,
          onPressed: () {
            setState(() {
              _records.insert(index, record);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'BACK',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
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
                  if (_records.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48.0),
                        child: Text(
                          'No records found.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ...List.generate(
                      _records.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _HistoryRecordCard(
                          record: _records[index],
                          onViewReport: () {
                            Navigator.pushNamed(context, '/result');
                          },
                          onDelete: () => _deleteRecord(index, _records[index]),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HistoryRecordCard extends StatelessWidget {
  const _HistoryRecordCard({
    required this.record,
    required this.onViewReport,
    required this.onDelete,
  });

  final _HistoryRecord record;
  final VoidCallback onViewReport;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final accentColor = record.warning ? AppColors.warning : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: record.warning
              ? AppColors.warning.withOpacity(0.3)
              : AppColors.border,
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HistoryIconBadge(warning: record.warning),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.classification,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
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
                          color: AppColors.textMuted,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.borderSoft, height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.textMuted,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '${record.dateText}  •  ${record.locationText}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
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
                          ? [AppColors.warning, AppColors.warning.withOpacity(0.4)]
                          : [AppColors.primarySoft, AppColors.primary],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.borderSoft, height: 1),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: onViewReport,
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text('VIEW REPORT'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                    color: AppColors.primary.withOpacity(0.35),
                    width: 1.1,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('DELETE'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.warning,
                  side: BorderSide(
                    color: AppColors.warning.withOpacity(0.35),
                    width: 1.1,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
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
    final backgroundColor =
        warning ? AppColors.warningSoft : AppColors.surfaceElevated;
    final iconColor = warning ? AppColors.warning : AppColors.primary;
    final icon = warning ? Icons.warning_rounded : Icons.verified_rounded;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}

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
