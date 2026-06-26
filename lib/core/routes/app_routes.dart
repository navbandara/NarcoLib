import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/gallery/gallery_screen.dart';
import '../../screens/help/help_screen.dart';
import '../../screens/history/history_screen.dart';
import '../../screens/location/location_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/result/result_screen.dart';
import '../../screens/report/report_screen.dart';
import '../../screens/scanner/scanner_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/profile';
  static const String scanner = '/scanner';
  static const String result = '/result';
  static const String location = '/location';
  static const String history = '/history';
  static const String report = '/report';
  static const String help = '/help';
  static const String gallery = '/gallery';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibHomeScreen(),
        );
      case login:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibLoginScreen(),
        );
      case register:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibRegisterScreen(),
        );
      case profile:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibProfileScreen(),
        );
      case scanner:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ScannerScreen(),
        );
      case result:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibResultScreen(),
        );
      case location:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibLocationScreen(),
        );
      case history:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibHistoryScreen(),
        );
      case report:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibReportScreen(),
        );
      case help:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibHelpScreen(),
        );
      case gallery:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibGalleryScreen(),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const NarcoLibHomeScreen(),
        );
    }
  }
}