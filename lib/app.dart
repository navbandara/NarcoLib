import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class NarcoLibApp extends StatelessWidget {
  const NarcoLibApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NarcoLib',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}