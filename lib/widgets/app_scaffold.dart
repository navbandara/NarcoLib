import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, this.appBar});

  final Widget child;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.backgroundMuted,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}