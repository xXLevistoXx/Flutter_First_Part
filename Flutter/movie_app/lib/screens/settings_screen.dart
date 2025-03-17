import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDark;
  const SettingsScreen({required this.toggleTheme, required this.isDark, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Тёмная тема'),
            Switch(
              value: isDark,
              onChanged: toggleTheme,
            ),
          ],
        ),
      ),
    );
  }
}