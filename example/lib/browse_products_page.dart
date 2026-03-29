import 'package:flutter/material.dart';

import 'models/price.dart';
import 'models/product.dart';
import 'models/product_category.dart';
import 'product_item_tile.dart';

class BrowseProductsPage extends StatefulWidget {
  const BrowseProductsPage({super.key});

  @override
  State<BrowseProductsPage> createState() => _BrowseProductsPageState();
}

class _BrowseProductsPageState extends State<BrowseProductsPage> {
  late final List<Product> _products = [
    const Product(
        name: 'Flutter Widget',
        price: Price(999),
        category: ProductCategory.software),
    const Product(
        name: 'Dart SDK', price: Price(0), category: ProductCategory.tools),
    const Product(
        name: 'Firebase Plugin',
        price: Price(499),
        category: ProductCategory.services),
    const Product(
        name: 'Test Framework',
        price: Price(299),
        category: ProductCategory.testing),
    const Product(
        name: 'Animation Library',
        price: Price(699),
        category: ProductCategory.ui),
  ];

  void _onProductUpdated(int index, Product updatedProduct) {
    setState(() {
      _products[index] = updatedProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Container(
        key: const Key('browse_products_page'),
        child: ListView.builder(
          key: const Key('items_list'),
          itemCount: _products.length,
          itemBuilder: (_, i) => ProductItemTile(
            product: _products[i],
            index: i,
            onProductUpdated: _onProductUpdated,
          ),
        ),
      ),
    );
  }
}
