import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/app_panel.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/app_warning_banner.dart';

class NarcoLibHomeScreen extends StatelessWidget {
  const NarcoLibHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0x3318E7F2),
                        Color(0x0018E7F2),
                      ],
                    ),
                    border: Border.all(color: AppColors.primary, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3318E7F2),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.manage_search_rounded,
                    size: 42,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'NarcoLib',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const AppSectionHeader(
            title: 'NARCOLIB',
            subtitle: 'FORENSIC INTELLIGENCE PLATFORM',
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppWarningBanner(
            title: 'Authorized Personnel Only',
            message:
                'This system is restricted to law enforcement officers. Unauthorized access is prohibited under applicable statutes.',
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Advanced AI-powered narcotics identification system for Sri Lankan law enforcement agencies.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppPrimaryButton(
            label: 'OFFICER LOGIN',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              side: const BorderSide(color: AppColors.primarySoft, width: 1.2),
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
            child: const Text('REGISTER'),
          ),
          const SizedBox(height: AppSpacing.xl),
          _FeatureCard(
            icon: Icons.center_focus_strong_rounded,
            title: 'AI-Powered Analysis',
            subtitle: 'MobileNetV3 neural classification with 96.8% accuracy',
          ),
          const SizedBox(height: AppSpacing.md),
          _FeatureCard(
            icon: Icons.bolt_rounded,
            title: 'CLAHE Enhancement',
            subtitle: 'Real-time lighting normalization for field operations',
          ),
          const SizedBox(height: AppSpacing.md),
          _FeatureCard(
            icon: Icons.public_rounded,
            title: 'Geospatial Intel',
            subtitle: 'Integrated mapping with emergency SOS system',
          ),
          const SizedBox(height: AppSpacing.md),
          _FeatureCard(
            icon: Icons.description_rounded,
            title: 'Automated Reports',
            subtitle: 'Forensic PDF documentation with legal compliance',
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(color: AppColors.borderSoft, height: 1),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              'v2.1.0 • Authorized Personnel Only',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.borderSoft, height: 1),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '© Compliant with the Poisons, Opium and Dangerous Drugs Ordinance (Chapter 218) of Sri Lanka',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: title,
      subtitle: subtitle,
      trailing: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
    );
  }
}
