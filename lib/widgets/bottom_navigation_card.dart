import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class BottomNavigationCard extends StatelessWidget {
  const BottomNavigationCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border.withOpacity(0.4),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
