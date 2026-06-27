import 'package:flutter/material.dart';

import 'screens/auth/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/scanner/scanner_screen.dart';
import 'screens/scanner/result_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/gallery/gallery_screen.dart';
import 'screens/location/location_screen.dart';
import 'screens/report/pdf_report_screen.dart';
import 'screens/help/help_screen.dart';

void main() {
  runApp(const NarcoLibApp());
}

class NarcoLibApp extends StatelessWidget {
  const NarcoLibApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NarcoLib',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/auth/login': (context) => const NarcoLibLoginScreen(),
        '/auth/register': (context) => const NarcoLibRegisterScreen(),
        '/profile': (context) => const NarcoLibProfileScreen(),
        '/scanner': (context) => ScannerScreen(),
        '/result': (context) => ResultScreen(),
        '/history': (context) => HistoryScreen(),
        '/gallery': (context) => const NarcoLibGalleryScreen(),
        '/location': (context) => const NarcoLibLocationScreen(),
        '/pdf-report': (context) => const PdfReportScreen(),
        '/help': (context) => const NarcoLibHelpScreen(),
      },
    );
  }
}