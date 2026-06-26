import 'package:flutter/material.dart';

import 'screens/auth/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/scanner/scanner_screen.dart';
import 'screens/scanner/result_screen.dart';
import 'screens/history/history_screen.dart';

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
      },
    );
  }
}