import 'package:flutter/material.dart';
import 'package:kite_authenticator/widgets/app_header.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const KiteAuthenticatorApp());
}

class KiteAuthenticatorApp extends StatelessWidget {
  const KiteAuthenticatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KITE Authenticator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF002B5B), // KITE brand blue
        scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Light gray background
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0, // Remove shadow for modern look
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: "KITE Authenticator",
        showLogo: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Add info action
            },
          ),
        ],
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: RegisterScreen(),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: const Color(0xFF002B5B),
        child: const Text(
          "© 2025 KITE. All Rights Reserved.",
          style: TextStyle(
            color: Colors.white70, // Slightly transparent
            fontSize: 13,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}