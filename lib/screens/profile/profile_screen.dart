import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/app_panel.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';

class NarcoLibProfileScreen extends StatelessWidget {
  const NarcoLibProfileScreen({super.key});

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  const AppSectionHeader(
                    title: 'OFFICER PROFILE',
                    subtitle: 'Account Information',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppPanel(
                    title: 'Officer ABC Perera',
                    subtitle: 'Active Duty',
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
                        _ProfileInfoTile(
                          label: 'Email',
                          value: 'n12345@slpolice.gov',
                          icon: Icons.mail_outline_rounded,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _ProfileInfoTile(
                          label: 'Agency',
                          value: 'Sri Lanka Police',
                          icon: Icons.apartment_rounded,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _ProfileInfoTile(
                          label: 'Badge Number',
                          value: 'N12345',
                          icon: Icons.badge_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Quick Access',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.15,
                    children: [
                      _QuickAccessButton(
                        label: 'New Scan',
                        icon: Icons.center_focus_strong_rounded,
                        highlighted: true,
                        onTap: () => Navigator.pushNamed(context, '/scanner'),
                      ),
                      _QuickAccessButton(
                        label: 'History',
                        icon: Icons.history_rounded,
                        onTap: () => Navigator.of(context).pushNamed('/history'),
                      ),
                      _QuickAccessButton(
                        label: 'Geo Map',
                        icon: Icons.public_rounded,
                        onTap: () => Navigator.of(context).pushNamed('/location'),
                      ),
                      _QuickAccessButton(
                        label: 'Gallery',
                        icon: Icons.photo_camera_rounded,
                        onTap: () => Navigator.of(context).pushNamed('/gallery'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _QuickAccessButton(
                    label: 'Help',
                    icon: Icons.menu_book_rounded,
                    fullWidth: true,
                    onTap: () => Navigator.of(context).pushNamed('/help'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppPrimaryButton(
                    label: 'LOGOUT',
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
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

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessButton extends StatelessWidget {
  const _QuickAccessButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
    this.fullWidth = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = highlighted ? AppColors.primary : AppColors.surface;
    final borderColor = highlighted ? AppColors.primary : AppColors.border;
    final foregroundColor = highlighted ? AppColors.background : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: highlighted ? AppColors.primarySoft : AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: highlighted ? AppColors.background : AppColors.primary, size: 24),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
