import 'package:flutter/material.dart';

import 'browse_products_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        key: const Key('home_page'),
        children: [
          const Text('Welcome', key: Key('greeting_text')),
          ElevatedButton(
            key: const Key('browse_products_button'),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BrowseProductsPage())),
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}
