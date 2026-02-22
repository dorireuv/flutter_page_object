import 'package:flutter/material.dart';

/// A helper wrapper for testing.
final class LocalizedWidgetWrapperForTesting extends StatelessWidget {
  final Widget child;
  final Locale? locale;

  const LocalizedWidgetWrapperForTesting(
      {super.key, required this.child, this.locale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: child),
      locale: locale,
    );
  }
}
