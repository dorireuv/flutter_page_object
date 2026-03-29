import 'price.dart';
import 'product_category.dart';

/// Product model class
class Product {
  final String name;
  final Price price;
  final ProductCategory category;
  final String description;

  const Product({
    required this.name,
    required this.price,
    required this.category,
    this.description = '',
  });
}
