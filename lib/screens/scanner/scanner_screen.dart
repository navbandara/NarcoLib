import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/bottom_navigation_card.dart';
import '../../widgets/secondary_button.dart';
import '../../services/image_picker_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  /// Static bypass flag for testing navigation transitions.
  static bool bypassValidation = false;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePickerService _pickerService = ImagePickerService();
  String? _imagePath;
  String? _placeholderMessage;
  bool _isAnalyzing = false;

  Future<void> _onCapturePressed() async {
    final path = await _pickerService.captureImage();
    if (path != null) {
      setState(() {
        _imagePath = path;
        _placeholderMessage = null;
      });
    } else {
      if (_imagePath == null) {
        setState(() {
          _placeholderMessage = 'Selection cancelled.';
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selection cancelled.')),
        );
      }
    }
  }

  Future<void> _onUploadPressed() async {
    final path = await _pickerService.selectFromGallery();
    if (path != null) {
      setState(() {
        _imagePath = path;
        _placeholderMessage = null;
      });
    } else {
      if (_imagePath == null) {
        setState(() {
          _placeholderMessage = 'Selection cancelled.';
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selection cancelled.')),
        );
      }
    }
  }

  void _onRemovePressed() {
    setState(() {
      _imagePath = null;
      _placeholderMessage = 'Image removed.';
    });
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
      child: _isAnalyzing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Analyzing Image...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                  ),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 390),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: AppSpacing.xs),
                            // 1. Instruction label
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        'Capture the substance',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.3,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            // 2. Scanner targeting/reticle design
                            Center(
                              child: Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.border.withValues(alpha: 0.4),
                                    width: 1.2,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Selected image preview or placeholder text
                                    Positioned.fill(
                                      child: _imagePath != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.file(
                                                File(_imagePath!),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(AppSpacing.md),
                                                child: Text(
                                                  _placeholderMessage ?? 'Ready to scan.\nUse the controls below to select an image.',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: AppColors.textSecondary,
                                                      ),
                                                ),
                                              ),
                                            ),
                                    ),
                                    // Reticle overlay paint
                                    const Positioned.fill(
                                      child: CustomPaint(
                                        painter: ScannerReticlePainter(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // 3. Image Actions controls
                            if (_imagePath == null) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: SecondaryButton(
                                      label: 'Capture Image',
                                      icon: Icons.camera_alt_outlined,
                                      onPressed: _onCapturePressed,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: SecondaryButton(
                                      label: 'Upload Image',
                                      icon: Icons.photo_library_outlined,
                                      onPressed: _onUploadPressed,
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: SecondaryButton(
                                      label: 'Capture Again',
                                      icon: Icons.camera_alt_outlined,
                                      onPressed: _onCapturePressed,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: SecondaryButton(
                                      label: 'Choose Another',
                                      icon: Icons.photo_library_outlined,
                                      onPressed: _onUploadPressed,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Center(
                                child: TextButton.icon(
                                  key: const Key('remove_image_button'),
                                  onPressed: _onRemovePressed,
                                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                  label: const Text(
                                    'REMOVE IMAGE',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.xl),
                            // 4. ANALYZE button
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
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                 onPressed: () async {
                                  if (_imagePath == null && !ScannerScreen.bypassValidation) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please capture or upload an image first.'),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      _isAnalyzing = true;
                                    });

                                    final navigator = Navigator.of(context);

                                    // Mock 2-second analysis delay
                                    await Future<void>.delayed(const Duration(seconds: 2));

                                    if (mounted) {
                                      setState(() {
                                        _isAnalyzing = false;
                                      });
                                      navigator.pushNamed(
                                        '/result',
                                        arguments: _imagePath,
                                      );
                                    }
                                  }
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ScannerIcon(),
                                    SizedBox(width: 12),
                                    Text(
                                      'ANALYZE',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            // 5. Bottom navigation grid
                            Row(
                              children: [
                                Expanded(
                                  child: BottomNavigationCard(
                                    label: 'GEO MAP',
                                    icon: Icons.map_outlined,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/location');
                                    },
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: BottomNavigationCard(
                                    label: 'HISTORY',
                                    icon: Icons.history_rounded,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/history');
                                    },
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: BottomNavigationCard(
                                    label: 'GALLERY',
                                    icon: Icons.photo_camera_outlined,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/gallery');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ScannerReticlePainter extends CustomPainter {
  const ScannerReticlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = Offset(width / 2, height / 2);
    final paintCyan = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 1. Concentric Circles
    // Outer circle
    canvas.drawCircle(center, 120, paintCyan..color = AppColors.primary.withValues(alpha: 0.25));
    // Middle circle
    canvas.drawCircle(center, 90, paintCyan..color = AppColors.primary.withValues(alpha: 0.45));
    // Inner circle
    canvas.drawCircle(center, 60, paintCyan..color = AppColors.primary.withValues(alpha: 0.7));

    // 2. Crosshairs
    final paintCrosshair = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Horizontal line through the center
    canvas.drawLine(Offset(center.dx - 85, center.dy), Offset(center.dx + 85, center.dy), paintCrosshair);
    // Vertical line through the center
    canvas.drawLine(Offset(center.dx, center.dy - 85), Offset(center.dx, center.dy + 85), paintCrosshair);

    // 3. Tick Marks on the Outer Circle (R = 120)
    final tickPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final tickAngles = [
      -100 * pi / 180, // top-left
      10 * pi / 180,  // middle-right
      100 * pi / 180, // bottom-right
      190 * pi / 180, // middle-left
    ];

    for (final angle in tickAngles) {
      final startX = center.dx + 114 * cos(angle);
      final startY = center.dy + 114 * sin(angle);
      final endX = center.dx + 126 * cos(angle);
      final endY = center.dy + 126 * sin(angle);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), tickPaint);
    }

    // 4. Corner Brackets
    final bracketPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    const double padding = 8.0;
    const double bracketLen = 30.0;

    // Top-Left
    canvas.drawLine(const Offset(padding, padding), const Offset(padding + bracketLen, padding), bracketPaint);
    canvas.drawLine(const Offset(padding, padding), const Offset(padding, padding + bracketLen), bracketPaint);

    // Top-Right
    canvas.drawLine(Offset(width - padding, padding), Offset(width - padding - bracketLen, padding), bracketPaint);
    canvas.drawLine(Offset(width - padding, padding), Offset(width - padding, padding + bracketLen), bracketPaint);

    // Bottom-Left
    canvas.drawLine(Offset(padding, height - padding), Offset(padding + bracketLen, height - padding), bracketPaint);
    canvas.drawLine(Offset(padding, height - padding), Offset(padding, height - padding - bracketLen), bracketPaint);

    // Bottom-Right
    canvas.drawLine(Offset(width - padding, height - padding), Offset(width - padding - bracketLen, height - padding), bracketPaint);
    canvas.drawLine(Offset(width - padding, height - padding), Offset(width - padding, height - padding - bracketLen), bracketPaint);

    // 5. Center Glow and Dot
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.8),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 24));
    canvas.drawCircle(center, 24, glowPaint);

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScannerIcon extends StatelessWidget {
  const ScannerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: const ScannerIconPainter(),
    );
  }
}

class ScannerIconPainter extends CustomPainter {
  const ScannerIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    const double len = 6.0;

    // Top-Left
    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, len), paint);

    // Top-Right
    canvas.drawLine(Offset(w, 0), Offset(w - len, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, len), paint);

    // Bottom-Left
    canvas.drawLine(Offset(0, h), Offset(len, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - len), paint);

    // Bottom-Right
    canvas.drawLine(Offset(w, h), Offset(w - len, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
