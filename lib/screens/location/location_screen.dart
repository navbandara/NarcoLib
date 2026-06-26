import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_panel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class NarcoLibLocationScreen extends StatelessWidget {
  const NarcoLibLocationScreen({super.key});

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
            title: 'GEOSPATIAL INTEL',
            subtitle: 'Real-time Location Services',
          ),
          const SizedBox(height: AppSpacing.lg),
          _MapSurface(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.place_outlined, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Colombo',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            Text(
                              'Active Scene Location',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const _MapMarkerPulse(),
                const SizedBox(height: 110),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: const [
              Expanded(
                child: _StatCard(label: 'Active Scans', value: '3'),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(label: 'Reports', value: '12'),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(label: 'GPS Signal', value: '98%'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppPrimaryButton(label: 'GENERATE PDF REPORT'),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: const [
              Expanded(
                child: _ActionButton(
                  label: 'VIEW RESULTS',
                  icon: Icons.bar_chart_rounded,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ActionButton(
                  label: 'HISTORY',
                  icon: Icons.history_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapSurface extends StatelessWidget {
  const _MapSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.98,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 26,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapGridPainter(),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.15, -0.1),
                      radius: 1.0,
                      colors: [
                        AppColors.primary.withOpacity(0.12),
                        AppColors.backgroundMuted.withOpacity(0.0),
                        AppColors.background.withOpacity(0.25),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 18,
                top: 18,
                child: _MapToolButton(icon: Icons.my_location_rounded),
              ),
              Positioned(
                left: 18,
                top: 84,
                child: _MapToolButton(icon: Icons.send_outlined),
              ),
              Positioned.fill(child: child),
              const Positioned(
                left: 48,
                top: 160,
                child: _DotMarker(color: Color(0xFF18E7F2), size: 8),
              ),
              const Positioned(
                right: 64,
                top: 210,
                child: _DotMarker(color: Color(0xFF18E7F2), size: 6),
              ),
              const Positioned(
                right: 52,
                bottom: 126,
                child: _DotMarker(color: Color(0xFF18E7F2), size: 7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.08)
      ..strokeWidth = 1;

    const verticalCount = 3;
    const horizontalCount = 2;

    for (var i = 1; i <= verticalCount; i++) {
      final x = size.width * i / (verticalCount + 1);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (var i = 1; i <= horizontalCount; i++) {
      final y = size.height * i / (horizontalCount + 1);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = AppColors.primarySoft.withOpacity(0.10)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(size.width * 0.18, size.height * 0.18), Offset(size.width * 0.82, size.height * 0.34), roadPaint);
    canvas.drawLine(Offset(size.width * 0.22, size.height * 0.74), Offset(size.width * 0.76, size.height * 0.60), roadPaint);

    final glowPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x0018E7F2),
          Color(0x4018E7F2),
          Color(0x0018E7F2),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(size.width * 0.24, 0, size.width * 0.02, size.height), glowPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.64, 0, size.width * 0.015, size.height), glowPaint);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.34, size.width, size.height * 0.018), glowPaint);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.68, size.width, size.height * 0.012), glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapToolButton extends StatelessWidget {
  const _MapToolButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Icon(icon, color: AppColors.primary, size: 22),
    );
  }
}

class _DotMarker extends StatelessWidget {
  const _DotMarker({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
    );
  }
}

class _MapMarkerPulse extends StatelessWidget {
  const _MapMarkerPulse();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 142,
          height: 142,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.16),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.4),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 38,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border, width: 1.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
