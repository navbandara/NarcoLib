import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import 'app_panel.dart';

class OfficerCard extends StatelessWidget {
  const OfficerCard({
    super.key,
    required this.name,
    required this.status,
    required this.email,
    required this.agency,
    required this.badgeNumber,
  });

  final String name;
  final String status;
  final String email;
  final String agency;
  final String badgeNumber;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: name,
      subtitle: status,
      trailing: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceElevated,
          border: Border.all(color: AppColors.primarySoft, width: 1),
        ),
        child: const Icon(
          Icons.person_outline_rounded,
          color: AppColors.primary,
          size: 34,
        ),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            context,
            label: 'Email',
            value: email,
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoTile(
            context,
            label: 'Agency',
            value: agency,
            icon: Icons.apartment_rounded,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoTile(
            context,
            label: 'Badge Number',
            value: badgeNumber,
            icon: Icons.badge_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
