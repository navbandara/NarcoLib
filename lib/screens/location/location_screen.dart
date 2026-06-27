import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class NarcoLibLocationScreen extends StatelessWidget {
  const NarcoLibLocationScreen({super.key});

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
                    title: 'GEOSPATIAL INTEL',
                    subtitle: 'Forensic Intelligence Map',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // 1. Interactive Map Surface
                  const _MapSurface(),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // 2. Current Location Card with Lat/Long values
                  const _CurrentLocationCard(
                    locationName: 'Colombo District Headquarters',
                    latitude: '6.9271° N',
                    longitude: '79.8612° E',
                    accuracy: '3.4m',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // 3. Recent Scan Location Markers/List
                  Text(
                    'Recent Incident Intel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _RecentIncidentsList(),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // 4. SOS Emergency Trigger Button
                  _SosButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MapSurface extends StatelessWidget {
  const _MapSurface();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.25,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Stack(
            children: [
              // Grid lines and roads simulation
              Positioned.fill(
                child: CustomPaint(
                  painter: _MapGridPainter(),
                ),
              ),
              // Radar pulse/lock gradient
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.05, -0.05),
                      radius: 0.8,
                      colors: [
                        AppColors.primary.withOpacity(0.12),
                        AppColors.backgroundMuted.withOpacity(0.0),
                        AppColors.background.withOpacity(0.20),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Floating Toolbar actions
              Positioned(
                left: 14,
                top: 14,
                child: _MapToolButton(icon: Icons.my_location_rounded),
              ),
              Positioned(
                left: 14,
                top: 70,
                child: _MapToolButton(icon: Icons.layers_rounded),
              ),
              
              // Pulsing Main Scan Marker
              const Center(child: _MapMarkerPulse()),
              
              // Static Dot Markers for other scans
              const Positioned(
                left: 55,
                top: 65,
                child: _DotMarker(color: AppColors.warning, size: 8),
              ),
              const Positioned(
                right: 75,
                top: 85,
                child: _DotMarker(color: AppColors.warning, size: 6),
              ),
              const Positioned(
                right: 60,
                bottom: 50,
                child: _DotMarker(color: AppColors.primary, size: 7),
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

    const verticalCount = 4;
    const horizontalCount = 3;

    for (var i = 1; i <= verticalCount; i++) {
      final x = size.width * i / (verticalCount + 1);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (var i = 1; i <= horizontalCount; i++) {
      final y = size.height * i / (horizontalCount + 1);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw simulated streets / paths
    final roadPaint = Paint()
      ..color = AppColors.primarySoft.withOpacity(0.08)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.20),
      Offset(size.width * 0.85, size.height * 0.35),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.80),
      Offset(size.width * 0.75, size.height * 0.65),
      roadPaint,
    );

    // Glowing coordinate lines
    final glowPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x0018E7F2),
          Color(0x3318E7F2),
          Color(0x0018E7F2),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(size.width * 0.52, 0, size.width * 0.015, size.height), glowPaint);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.48, size.width, size.height * 0.015), glowPaint);
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
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
        ),
      ),
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
            color: color.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
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
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: const Icon(
            Icons.my_location_rounded,
            color: AppColors.primary,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _CurrentLocationCard extends StatelessWidget {
  const _CurrentLocationCard({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });

  final String locationName;
  final String latitude;
  final String longitude;
  final String accuracy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.gps_fixed_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'GPS LOCK: ACTIVE',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  'Acc: ±$accuracy',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            locationName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1, thickness: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LATITUDE',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      latitude,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: AppColors.border,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LONGITUDE',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      longitude,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentIncidentItem {
  final String substance;
  final String coordinates;
  final String location;
  final String time;
  final bool isWarning;

  const _RecentIncidentItem({
    required this.substance,
    required this.coordinates,
    required this.location,
    required this.time,
    required this.isWarning,
  });
}

const List<_RecentIncidentItem> _recentIncidents = [
  _RecentIncidentItem(
    substance: 'Heroin Scan',
    coordinates: '6.9271° N, 79.8612° E',
    location: 'Colombo 03',
    time: '1h ago',
    isWarning: true,
  ),
  _RecentIncidentItem(
    substance: 'Cocaine Scan',
    coordinates: '7.0873° N, 79.9925° E',
    location: 'Gampaha Center',
    time: '2h ago',
    isWarning: true,
  ),
  _RecentIncidentItem(
    substance: 'Aspirin Scan',
    coordinates: '7.2906° N, 80.6337° E',
    location: 'Kandy Outpost',
    time: '1d ago',
    isWarning: false,
  ),
];

class _RecentIncidentsList extends StatelessWidget {
  const _RecentIncidentsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _recentIncidents.map((incident) {
        final markerColor = incident.isWarning ? AppColors.warning : AppColors.primary;
        final markerBg = incident.isWarning ? AppColors.warningSoft : AppColors.surfaceElevated;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderSoft, width: 1.0),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: markerBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  incident.isWarning ? Icons.warning_amber_rounded : Icons.verified_rounded,
                  color: markerColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      incident.substance,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${incident.location} • ${incident.coordinates}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                incident.time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SosButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.warning,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        icon: const Icon(Icons.emergency_share_rounded, color: Colors.white, size: 22),
        label: const Text('TRIGGER EMERGENCY SOS'),
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Theme(
                data: ThemeData.dark().copyWith(
                  dialogBackgroundColor: AppColors.surface,
                ),
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: AppColors.warning, width: 1.5),
                  ),
                  title: Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 28),
                      SizedBox(width: 10),
                      Text(
                        'EMERGENCY SOS',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  content: const Text(
                    'Confirm sending current GPS coordinates (6.9271° N, 79.8612° E) and officer profile data to emergency dispatch and local command center?',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'CONFIRM SOS',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'SOS Broadcast Sent. Dispatch notified.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.warning,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
