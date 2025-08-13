import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF002B5B),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: const Text(
        '© 2025 KITE – Kerala Infrastructure and Technology for Education',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}
