import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage() : super(key: const Key('home_page'));

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('welcome', key: Key('greeting_text')),
    );
  }
}
