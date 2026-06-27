import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/app_panel.dart';
import '../../widgets/app_primary_button.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_section_header.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_warning_banner.dart';
import '../../widgets/narcolib_logo.dart';

class NarcoLibRegisterScreen extends StatelessWidget {
  const NarcoLibRegisterScreen({super.key});

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
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                children: [
                  const SizedBox(height: AppSpacing.xs),
                  Center(
                    child: Column(
                      children: [
                        const NarcoLibLogo(
                          size: 100,
                          showGlow: false,
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
                    title: 'OFFICER REGISTRATION',
                    subtitle: 'SECURE ENROLLMENT',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const AppWarningBanner(
                    title: 'AUTHORIZED PERSONNEL ONLY',
                    message:
                        'Officer accounts require verification. Keep enrollment details accurate and secure.',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const AppPanel(
                    title: 'Create Officer Account',
                    subtitle: 'All fields are for enrollment only and do not submit anywhere yet.',
                    child: _RegisterForm(),
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

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTextField(
          labelText: 'Full Name',
          hintText: 'Officer ABC Perera',
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: AppSpacing.md),
        const AppTextField(
          labelText: 'Official Email',
          hintText: 'officer@enforcement.gov',
          prefixIcon: Icons.mail_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: const [
            Expanded(
              child: AppTextField(
                labelText: 'Agency',
                hintText: 'Police',
                prefixIcon: Icons.apartment_rounded,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(
                labelText: 'Badge ID',
                hintText: 'N12345',
                prefixIcon: Icons.badge_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const AppTextField(
          labelText: 'Create Password',
          hintText: 'Enter password',
          prefixIcon: Icons.lock_rounded,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.md),
        const AppTextField(
          labelText: 'Confirm Password',
          hintText: 'Re-enter password',
          prefixIcon: Icons.lock_rounded,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppPrimaryButton(
          label: 'Complete Registration',
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
        ),
      ],
    );
  }
}
