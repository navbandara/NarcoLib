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
import '../profile/profile_screen.dart';

class NarcoLibLoginScreen extends StatelessWidget {
  const NarcoLibLoginScreen({super.key});

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
                    title: 'NARCOLIB',
                    subtitle: 'FORENSIC INTELLIGENCE',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const AppWarningBanner(
                    title: 'AUTHORIZED PERSONNEL ONLY',
                    message:
                        'This system is restricted to law enforcement officers. Unauthorized access is prohibited under applicable statutes.',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const AppPanel(
                    title: 'Official Login',
                    subtitle: 'Use your enforcement email and secure passcode to continue.',
                    child: _LoginForm(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
                    child: const Text('Register New Officer Account →'),
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

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTextField(
          labelText: 'Official Email',
          hintText: 'officer@enforcement.gov',
          prefixIcon: Icons.mail_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        const AppTextField(
          labelText: 'Secure Passcode',
          hintText: 'Enter secure password',
          prefixIcon: Icons.lock_rounded,
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppPrimaryButton(
          label: 'Secure Login',
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
        ),
      ],
    );
  }
}
