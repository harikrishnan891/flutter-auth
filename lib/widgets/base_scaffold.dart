import 'package:flutter/material.dart';
import 'app_header.dart';

// import 'app_footer.dart';
class BaseScaffold extends StatelessWidget {
  final String title; // Changed to non-nullable
  final List<Widget> actions; // Changed to non-nullable with default value
  final Widget body;

  const BaseScaffold({
    super.key,
    required this.title,
    this.actions = const [],
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: title,
        actions: actions,
      ),
      body: body,
    );
  }
}
