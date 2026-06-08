import 'package:flutter/material.dart';

import 'scan_screen.dart';

class BrandColors {
  static const Color background = Color(0xFF0E1411);
  static const Color surface = Color(0xFF18211C);
  static const Color accent = Color(0xFF34C759);
  static const Color warn = Color(0xFFFF9F0A);
  static const Color danger = Color(0xFFFF3B30);
}

class StorageGateApp extends StatelessWidget {
  const StorageGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Storage Gate Access',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: BrandColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BrandColors.accent,
          brightness: Brightness.dark,
        ),
      ),
      home: const ScanScreen(),
    );
  }
}
