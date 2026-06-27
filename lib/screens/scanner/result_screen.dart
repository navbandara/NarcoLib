import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_panel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/secondary_button.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

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
                    title: 'ANALYSIS COMPLETE',
                    subtitle: 'MobileNetV3 Neural Classification',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 1. Substance Result Card (with Red Border & Risk Badge)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.8),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.warning.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: AppColors.warningSoft,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.warning_rounded,
                                color: AppColors.warning,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Heroin Detected',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textPrimary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.warningSoft,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: AppColors.warning
                                                .withOpacity(0.6),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          'HIGH RISK',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: AppColors.warning,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 0.5,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI CONFIDENCE',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.6,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  _ConfidenceBar(
                                    percent: 0.947,
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.warning,
                                        AppColors.primary,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              '94.7%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Model: MobileNetV3-Large',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Time: 1.24s',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 2. Legal Classification Card
                  AppPanel(
                    title: 'Legal Classification',
                    subtitle:
                        'Poisons, Opium and Dangerous Drugs Ordinance (Chapter 218) - Sri Lanka',
                    trailing: const Icon(
                      Icons.balance_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Schedule Classification',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Part I - Dangerous Drugs',
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'This substance is prohibited under Sri Lankan law; possession, trafficking, or manufacture may result in imprisonment.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 3. Recommended Actions Card
                  AppPanel(
                    title: 'Recommended Actions',
                    subtitle: 'Protocol for handling identified substance',
                    trailing: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _ActionItemRow(
                            stepNumber: '1',
                            text:
                                'Secure the sample in an airtight container immediately.',
                          ),
                          SizedBox(height: AppSpacing.md),
                          _ActionItemRow(
                            stepNumber: '2',
                            text:
                                'Document context, capture GPS log, and mark evidence bag.',
                          ),
                          SizedBox(height: AppSpacing.md),
                          _ActionItemRow(
                            stepNumber: '3',
                            text:
                                'Dispatch the sample to Government Analyst Dept for laboratory validation.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 4. Alternative Matches Card
                  AppPanel(
                    title: 'Alternative Matches',
                    subtitle:
                        'Secondary classification probabilities from the static sample set',
                    child: Column(
                      children: const [
                        _MatchRow(
                          label: 'Morphine',
                          percentText: '3.2%',
                          value: 0.032,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _MatchRow(
                          label: 'Fentanyl',
                          percentText: '1.8%',
                          value: 0.018,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _MatchRow(
                          label: 'Unknown Substance',
                          percentText: '0.3%',
                          value: 0.003,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // 5. Scan Metadata Card
                  AppPanel(
                    title: 'Scan Metadata',
                    subtitle: 'Static case record for the UI mockup',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _MetadataItem(
                                label: 'Timestamp',
                                value: '5/6/2026, 10:04:42 AM',
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _MetadataItem(
                                label: 'Model Version',
                                value: 'v2.1.0',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: _MetadataItem(
                                label: 'Processing',
                                value: '1.24s',
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _MetadataItem(
                                label: 'Status',
                                value: 'VERIFIED',
                                valueColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // 6. Action Buttons
                  // Generate PDF Report Button
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primary,
                          Color(0xFF0DADB5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/pdf-report');
                      },
                      icon: const Icon(
                        Icons.description_outlined,
                        color: Colors.black,
                      ),
                      label: const Text(
                        'GENERATE PDF REPORT',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Save to History and New Scan Secondary Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'SAVE TO HISTORY',
                          icon: Icons.bookmark_add_outlined,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Saved to case history.'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: SecondaryButton(
                          label: 'NEW SCAN',
                          icon: Icons.refresh_rounded,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  const _ConfidenceBar({required this.percent, required this.gradient});

  final double percent;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 14,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                decoration: BoxDecoration(gradient: gradient),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchRow extends StatelessWidget {
  const _MatchRow({
    required this.label,
    required this.percentText,
    required this.value,
  });

  final String label;
  final String percentText;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Expanded(
          flex: 4,
          child: _ConfidenceBar(
            percent: value,
            gradient: const LinearGradient(
              colors: [AppColors.primarySoft, AppColors.primary],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 50,
          child: Text(
            percentText,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ),
      ],
    );
  }
}

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActionItemRow extends StatelessWidget {
  const _ActionItemRow({required this.stepNumber, required this.text});

  final String stepNumber;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            stepNumber,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
          ),
        ),
      ],
    );
  }
}


