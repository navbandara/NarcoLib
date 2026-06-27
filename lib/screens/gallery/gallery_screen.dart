import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class EvidenceItem {
  final String sampleId;
  final String substance;
  final String date;
  final String confidence;
  final bool isWarning;

  const EvidenceItem({
    required this.sampleId,
    required this.substance,
    required this.date,
    required this.confidence,
    required this.isWarning,
  });
}

const List<EvidenceItem> _sampleEvidence = [
  EvidenceItem(
    sampleId: 'SMP-20491',
    substance: 'Heroin',
    date: '2026-06-27',
    confidence: '94.7%',
    isWarning: true,
  ),
  EvidenceItem(
    sampleId: 'SMP-20492',
    substance: 'Cocaine',
    date: '2026-06-27',
    confidence: '91.3%',
    isWarning: true,
  ),
  EvidenceItem(
    sampleId: 'SMP-20493',
    substance: 'Aspirin',
    date: '2026-06-26',
    confidence: '98.2%',
    isWarning: false,
  ),
  EvidenceItem(
    sampleId: 'SMP-20494',
    substance: 'Methamphetamine',
    date: '2026-06-25',
    confidence: '89.6%',
    isWarning: true,
  ),
  EvidenceItem(
    sampleId: 'SMP-20495',
    substance: 'Fentanyl',
    date: '2026-06-24',
    confidence: '96.8%',
    isWarning: true,
  ),
  EvidenceItem(
    sampleId: 'SMP-20496',
    substance: 'Ibuprofen',
    date: '2026-06-23',
    confidence: '97.1%',
    isWarning: false,
  ),
];

class NarcoLibGalleryScreen extends StatelessWidget {
  const NarcoLibGalleryScreen({super.key});

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
                    title: 'EVIDENCE GALLERY',
                    subtitle: 'Forensic Digital Catalog',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.74,
                    ),
                    itemCount: _sampleEvidence.length,
                    itemBuilder: (context, index) {
                      return _EvidenceCard(item: _sampleEvidence[index]);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppPrimaryButton(
                    label: 'UPLOAD EVIDENCE',
                    onPressed: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upload Evidence flow simulated successfully.'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.surfaceElevated,
                        ),
                      );
                    },
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

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({required this.item});

  final EvidenceItem item;

  @override
  Widget build(BuildContext context) {
    final statusColor = item.isWarning ? AppColors.warning : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image / Placeholder Section
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  // Gradient Background mimicking photo preview container
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surfaceElevated,
                          AppColors.backgroundMuted,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: 0.25,
                        child: Icon(
                          Icons.biotech_outlined,
                          color: statusColor,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  // Futuristic Grid lines simulation
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GridLinesPainter(color: statusColor.withOpacity(0.08)),
                    ),
                  ),
                  // Confidence Badge overlay in top-right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: statusColor.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: statusColor,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            item.confidence,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Info Section
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.sampleId,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.substance,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                    ),
                    Icon(
                      item.isWarning ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                      size: 14,
                      color: statusColor,
                    ),
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

class _GridLinesPainter extends CustomPainter {
  final Color color;
  _GridLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    for (double y = 0; y < size.height; y += 15) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Draw vertical grid lines
    for (double x = 0; x < size.width; x += 15) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
