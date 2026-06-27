import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../widgets/narcolib_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _background = Color(0xFF071018);
  static const Color _backgroundSoft = Color(0xFF0B1620);
  static const Color _surface = Color(0xFF101E2B);
  static const Color _surfaceElevated = Color(0xFF15283B);
  static const Color _border = Color(0xFF23415F);
  static const Color _cyan = Color(0xFF18E7F2);
  static const Color _cyanSoft = Color(0xFF0FB0C5);
  static const Color _textPrimary = Color(0xFFF1FBFF);
  static const Color _textSecondary = Color(0xFF88A6BA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _background,
              _backgroundSoft,
              _background,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 390),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 12),
                          _LogoArea(),
                          const SizedBox(height: 28),
                          _TitleArea(),
                          const SizedBox(height: 24),
                          _DescriptionText(
                            text:
                                'Advanced narcotics identification system designed for Sri Lankan law enforcement agencies.',
                          ),
                          const SizedBox(height: 28),
                          _PrimaryButton(
                            label: 'OFFICER LOGIN',
                            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
                            icon: Icons.lock_outline_rounded,
                            trailingIcon: Icons.arrow_forward_rounded,
                          ),
                          const SizedBox(height: 14),
                          _SecondaryButton(
                            label: 'REGISTER',
                            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
                          ),
                          const SizedBox(height: 26),
                          const _FeatureCard(
                            icon: Icons.center_focus_strong_rounded,
                            title: 'AI-Powered Analysis',
                            subtitle: 'MobileNetV3 neural classification with 96.8% accuracy',
                          ),
                          const SizedBox(height: 14),
                          const _FeatureCard(
                            icon: Icons.bolt_rounded,
                            title: 'CLAHE Enhancement',
                            subtitle: 'Real-time lighting normalization for field operations',
                          ),
                          const SizedBox(height: 14),
                          const _FeatureCard(
                            icon: Icons.public_rounded,
                            title: 'Geospatial Intel',
                            subtitle: 'Integrated mapping with emergency SOS system',
                          ),
                          const SizedBox(height: 14),
                          const _FeatureCard(
                            icon: Icons.description_rounded,
                            title: 'Automated Reports',
                            subtitle: 'Forensic PDF documentation with legal compliance',
                          ),
                          const SizedBox(height: 24),
                          const _FooterArea(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LogoArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NarcoLibLogo(
          size: 96,
          showGlow: true,
        ),
        const SizedBox(height: 12),
        Text(
          'NarcoLib',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: HomeScreen._cyan,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6,
              ),
        ),
      ],
    );
  }
}

class _TitleArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'NARCOLIB',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: HomeScreen._cyan,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(child: _AccentLine()),
            SizedBox(width: 10),
            Text(
              'FORENSIC INTELLIGENCE',
              style: TextStyle(
                color: HomeScreen._textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.6,
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: _AccentLine()),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'PLATFORM',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: HomeScreen._textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 5.6,
          ),
        ),
      ],
    );
  }
}

class _AccentLine extends StatelessWidget {
  const _AccentLine();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: HomeScreen._cyan.withOpacity(0.75));
  }
}

class _DescriptionText extends StatelessWidget {
  const _DescriptionText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: HomeScreen._textPrimary,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.icon,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: HomeScreen._background),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (trailingIcon != null) ...[
              const SizedBox(width: 10),
              Icon(trailingIcon, color: HomeScreen._background, size: 18),
            ],
          ],
        ),
        style: FilledButton.styleFrom(
          backgroundColor: HomeScreen._cyan,
          foregroundColor: HomeScreen._background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: HomeScreen._cyan,
          side: const BorderSide(color: HomeScreen._cyanSoft, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        child: Text(label),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HomeScreen._surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HomeScreen._border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: HomeScreen._surfaceElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: HomeScreen._cyan, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: HomeScreen._textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: HomeScreen._textSecondary,
                        height: 1.35,
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

class _FooterArea extends StatelessWidget {
  const _FooterArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: Color(0xFF1E3144), height: 1),
        const SizedBox(height: 16),
        Text(
          'v2.1.0 • Authorized Personnel Only',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: HomeScreen._textSecondary,
                letterSpacing: 0.3,
              ),
        ),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF1E3144), height: 1),
        const SizedBox(height: 16),
        Text(
          '© Compliant with the Poisons, Opium and Dangerous Drugs Ordinance (Chapter 218) of Sri Lanka',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: HomeScreen._textSecondary,
                height: 1.45,
              ),
        ),
      ],
    );
  }
}