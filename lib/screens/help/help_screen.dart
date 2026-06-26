import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class NarcoLibHelpScreen extends StatelessWidget {
  const NarcoLibHelpScreen({super.key});

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
            title: 'USER MANUAL',
            subtitle: 'System Guide & Documentation',
          ),
          const SizedBox(height: AppSpacing.lg),
          _QuickStartCard(
            title: 'Quick Start Guide',
            icon: Icons.menu_book_rounded,
            bullets: const [
              'Navigate to Scanner from your profile.',
              'Position substance within the central reticle.',
              'Enable CLAHE for optimal lighting adjustment.',
              'Tap "START ANALYSIS" to begin scan.',
              'Review results and export PDF report.',
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'DETAILED TOPICS',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _ExpandableHelpSection(
            title: 'Using the Scanner',
            icon: Icons.photo_camera_outlined,
            initiallyExpanded: true,
            children: [
              'Position the substance within the central reticle for optimal results.',
              'Ensure proper lighting or enable the tactical flashlight for dark environments.',
              'Keep the camera steady during the 2-3 second scanning process.',
              'The scanner automatically captures and analyzes the sample using MobileNetV3 AI.',
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _ExpandableHelpSection(
            title: 'CLAHE Enhancement',
            icon: Icons.bolt_rounded,
            children: [
              'CLAHE improves local contrast before classification.',
              'Use it when the sample is underexposed, shadowed, or washed out.',
              'The enhancement runs locally on the capture pipeline.',
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _ExpandableHelpSection(
            title: 'AI Classification',
            icon: Icons.psychology_alt_outlined,
            children: [
              'The system compares the captured sample against trained narcotics classes.',
              'Confidence scores indicate the strongest match returned by the model.',
              'Alternative matches are shown to support review, not as final legal proof.',
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _ExpandableHelpSection(
            title: 'Legal Framework',
            icon: Icons.shield_outlined,
            children: [
              'Results are mapped to the Poisons, Opium and Dangerous Drugs Ordinance.',
              'Classification labels are provided for operational guidance only.',
              'Officer review and evidence handling procedures still apply.',
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _ExpandableHelpSection(
            title: 'Geospatial Features',
            icon: Icons.location_on_outlined,
            children: [
              'The map view summarizes the active scene location and nearby activity.',
              'Location markers are shown alongside scan metadata for quick reference.',
              'No live map provider is enabled in this screen build.',
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const _ExpandableHelpSection(
            title: 'PDF Reports',
            icon: Icons.description_outlined,
            children: [
              'Reports package the scan summary, classification, and location details.',
              'The current screen is a UI mockup only; no document generation is active.',
              'Use the download button after PDF integration is added later.',
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SupportCard(),
        ],
      ),
    );
  }
}

class _QuickStartCard extends StatelessWidget {
  const _QuickStartCard({
    required this.title,
    required this.icon,
    required this.bullets,
  });

  final String title;
  final IconData icon;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...bullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Icon(Icons.circle, size: 8, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      bullet,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
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

class _ExpandableHelpSection extends StatelessWidget {
  const _ExpandableHelpSection({
    required this.title,
    required this.icon,
    required this.children,
    this.initiallyExpanded = false,
  });

  final String title;
  final IconData icon;
  final List<String> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textSecondary,
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ],
        ),
        children: children
            .map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 8, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            'Need Additional Support?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Contact your system administrator for technical assistance or training resources.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}
