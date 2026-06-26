import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class NarcoLibGalleryScreen extends StatelessWidget {
  const NarcoLibGalleryScreen({super.key});

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
            title: 'EVIDENCE GALLERY',
            subtitle: '6 Photos',
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.92,
            children: const [
              _EvidenceCard(label: 'Heroin', percentText: '94.7%', warning: true),
              _EvidenceCard(label: 'Cocaine', percentText: '91.3%', warning: true),
              _EvidenceCard(label: 'Aspirin', percentText: '98.2%', warning: false),
              _EvidenceCard(label: 'Methamphetamine', percentText: '89.6%', warning: true),
              _EvidenceCard(label: 'Fentanyl', percentText: '96.8%', warning: true),
              _EvidenceCard(label: 'Ibuprofen', percentText: '97.1%', warning: false),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const AppPrimaryButton(label: 'CAPTURE NEW EVIDENCE'),
        ],
      ),
    );
  }
}

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({
    required this.label,
    required this.percentText,
    required this.warning,
  });

  final String label;
  final String percentText;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final accentColor = warning ? AppColors.warning : AppColors.primary;
    final badgeColor = warning ? AppColors.warningSoft : AppColors.surfaceElevated;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundMuted.withOpacity(0.3),
                    AppColors.surface,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: warning ? AppColors.warning : AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.4),
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.photo_camera_outlined,
                      color: warning ? AppColors.warning : AppColors.primary,
                      size: 32,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      percentText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    Icon(Icons.circle, size: 10, color: accentColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
