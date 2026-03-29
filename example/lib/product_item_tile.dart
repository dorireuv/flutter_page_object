import 'package:flutter/material.dart';

import 'edit_product_page.dart';
import 'models/product.dart';

class ProductItemTile extends StatelessWidget {
  final Product product;
  final int index;
  final Function(int, Product) onProductUpdated;

  const ProductItemTile({
    super.key,
    required this.product,
    required this.index,
    required this.onProductUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key('item'),
      title: Text(product.name, key: Key('name')),
      subtitle: Text(product.price.toDisplayString(), key: Key('price')),
      onTap: () => _onTap(context),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final result = await Navigator.of(context).push<Product>(
      MaterialPageRoute(builder: (_) => EditProductPage(product: product)),
    );
    if (result != null) {
      onProductUpdated(index, result);
    }
  }
}
