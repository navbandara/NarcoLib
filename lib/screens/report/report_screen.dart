import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_panel.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class NarcoLibReportScreen extends StatelessWidget {
  const NarcoLibReportScreen({super.key});

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
            title: 'PDF REPORT',
            subtitle: 'Forensic Documentation Generator',
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPanel(
            title: 'Report Preview',
            subtitle: 'Static sample report layout for UI only',
            trailing: const Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 28,
            ),
            child: Column(
              children: [
                _PreviewSection(
                  icon: Icons.badge_outlined,
                  title: 'OFFICER INFORMATION',
                  child: Column(
                    children: const [
                      _DetailRow(label: 'Name', value: 'ABC Perera'),
                      _DetailRow(label: 'Badge', value: 'N12345'),
                      _DetailRow(label: 'Agency', value: 'Police'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _PreviewSection(
                  icon: Icons.analytics_outlined,
                  title: 'ANALYSIS RESULTS',
                  child: Column(
                    children: const [
                      _DetailRow(label: 'Case', value: 'OP-2026-0423'),
                      _DetailRow(label: 'Substance', value: 'Heroin (Diacetylmorphine)'),
                      _DetailRow(label: 'Confidence', value: '94.7%', valueColor: AppColors.primary),
                      _DetailRow(label: 'Classification', value: 'Schedule I Narcotic', valueColor: AppColors.warning),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _PreviewSection(
                  icon: Icons.location_on_outlined,
                  title: 'LOCATION & TIME',
                  child: Column(
                    children: const [
                      _DetailRow(label: 'Timestamp', value: '3/7/2026, 8:01:24 AM'),
                      _DetailRow(label: 'GPS', value: '22.3193° N, 114.1694° E'),
                      _DetailRow(label: 'Address', value: 'Colombo'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppPrimaryButton(label: 'DOWNLOAD PDF REPORT'),
        ],
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
