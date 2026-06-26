import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import 'app_panel.dart';
import 'app_primary_button.dart';
import 'app_scaffold.dart';
import 'app_section_header.dart';

class NarcoLibShell extends StatelessWidget {
  const NarcoLibShell({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: const [
          AppSectionHeader(
            title: 'NarcoLib',
            subtitle: 'Forensic intelligence UI foundation',
          ),
          SizedBox(height: AppSpacing.lg),
          AppPanel(
            title: 'Design System Ready',
            subtitle:
                'Dark navy surfaces, cyan accents, blue borders, and warning states are now centralized for future screens.',
          ),
          SizedBox(height: AppSpacing.md),
          AppPrimaryButton(label: 'Route structure configured'),
          SizedBox(height: AppSpacing.md),
          AppPanel(
            title: 'Screen placeholders only',
            subtitle:
                'Authentication, profile, scanner, location, history, report, help, and gallery folders are scaffolded but intentionally empty.',
          ),
        ],
      ),
    );
  }
}