import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class NarcoLibHelpScreen extends StatelessWidget {
  const NarcoLibHelpScreen({super.key});

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
                    title: 'USER MANUAL',
                    subtitle: 'Operational Guide & Protocols',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Expandable Topics
                  const _ExpandableHelpSection(
                    title: 'How to scan a substance',
                    icon: Icons.qr_code_scanner_rounded,
                    initiallyExpanded: true,
                    children: [
                      'Navigate to the Scanner screen from the Profile dashboard.',
                      'Position the substance sample within the central camera reticle.',
                      'For optimal lighting, toggle the flash or enable the CLAHE contrast enhancement.',
                      'Keep the device steady and press the START SCAN button to begin analysis.',
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  const _ExpandableHelpSection(
                    title: 'How to read AI confidence',
                    icon: Icons.psychology_rounded,
                    children: [
                      'The neural classification engine displays positive matches with a percentage score.',
                      'Scores above 90% indicate a very high probability match.',
                      'Any score below 80% represents a tentative detection and requires human validation.',
                      'Check the Alternative Matches section at the bottom of results for secondary outputs.',
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  const _ExpandableHelpSection(
                    title: 'How to generate a report',
                    icon: Icons.picture_as_pdf_rounded,
                    children: [
                      'Tap the GENERATE PDF REPORT button on the scan result page.',
                      'Review the biometric-secured document letterhead preview card.',
                      'Use the DOWNLOAD PDF action button to save the file onto local storage.',
                      'Tap SHARE REPORT to dispatch it to other officers or command channels.',
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  const _ExpandableHelpSection(
                    title: 'How to use location support',
                    icon: Icons.map_rounded,
                    children: [
                      'Access the Geo Map page to view active GPS lock statistics.',
                      'Verify latitude and longitude coordinates are showing and accuracy is under 5m.',
                      'Plotted color markers show recent scan incidents around your location.',
                      'Use the red emergency SOS trigger button to broadcast coordinates to nearest dispatch.',
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  const _ExpandableHelpSection(
                    title: 'Safety and legal disclaimer',
                    icon: Icons.policy_rounded,
                    children: [
                      'This software is designated for authorized law enforcement personnel only.',
                      'AI classification is an operational aid and does not constitute absolute proof.',
                      'Follow standard hazardous substance handling protocols when securing chemical items.',
                      'All coordinate queries and scanned reports are biometrically logged for audit.',
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Support card footer
                  const _SupportCard(),
                ],
              ),
            ),
          );
        },
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(17),
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textSecondary,
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
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
                        child: Icon(Icons.circle, size: 6, color: AppColors.primary),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.headset_mic_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Need Technical Support?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Contact the command center tech administrators for operational support, server sync issues, or account permission edits.',
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
