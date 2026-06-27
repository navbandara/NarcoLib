import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class NarcoLibLogo extends StatelessWidget {
  const NarcoLibLogo({
    super.key,
    this.size = 96,
    this.showGlow = true,
  });

  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [
            Color(0x3318E7F2),
            Color(0x0018E7F2),
          ],
        ),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: showGlow
            ? const [
                BoxShadow(
                  color: Color(0x3318E7F2),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
