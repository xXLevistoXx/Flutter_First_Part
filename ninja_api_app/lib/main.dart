import 'package:flutter/material.dart';
import 'di.dart';
import 'home_page.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ninja Quotes',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A2B47), // Темно-синий
        scaffoldBackgroundColor: const Color(0xFFF5E8C7), // Бежевый
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1A2B47),
          secondary: Color(0xFFDEBA9D), // Светло-бежевый акцент
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A2B47),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}