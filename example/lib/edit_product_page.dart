import 'package:flutter/material.dart';

import 'models/price.dart';
import 'models/product.dart';
import 'models/product_category.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late Price? _price;
  final _formKey = GlobalKey<FormState>();

  bool _isAvailable = true;
  ProductCategory? _selectedCategory;
  bool _featured = false;

  @override
  void initState() {
    super.initState();

    final product = widget.product;
    _nameController = TextEditingController(text: product.name);
    _descriptionController = TextEditingController(text: product.description);
    _price = product.price;
    _selectedCategory = product.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: SingleChildScrollView(
        key: const Key('edit_product_page'),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _nameTextField(),
              _descriptionTextField(),
              _priceTextField(),
              _availabilitySwitch(),
              _featuredCheckbox(),
              _categoryDropdown(),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      key: const Key('name_text_field'),
      controller: _nameController,
      validator: (v) => v?.isEmpty ?? true ? 'Name cannot be empty' : null,
    );
  }

  Widget _descriptionTextField() {
    return TextFormField(
      key: const Key('description_text_field'),
      controller: _descriptionController,
      maxLines: 3,
    );
  }

  Widget _priceTextField() {
    return TextFormField(
      key: const Key('price_text_field'),
      initialValue: _price?.toDisplayString(),
      keyboardType: TextInputType.number,
      onChanged: (v) => setState(() => _price = Price.fromDisplayString(v)),
      validator: (v) =>
          Price.fromDisplayString(v) == null ? 'Price invalid' : null,
    );
  }

  Widget _availabilitySwitch() {
    return SwitchListTile(
      key: const Key('available_switch'),
      title: const Text('Available'),
      value: _isAvailable,
      onChanged: (v) => setState(() => _isAvailable = v),
    );
  }

  Widget _featuredCheckbox() {
    return CheckboxListTile(
      key: const Key('featured_checkbox'),
      title: Text('Featured Product'),
      value: _featured,
      onChanged: (value) => setState(() => _featured = value ?? false),
    );
  }

  Widget _categoryDropdown() {
    return DropdownButtonFormField<ProductCategory>(
      key: const Key('category_dropdown'),
      initialValue: _selectedCategory,
      validator: (v) => v == null ? 'Please select a category' : null,
      items: ProductCategory.values
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category.displayName),
              ))
          .toList(),
      onChanged: (v) => setState(() => _selectedCategory = v),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      key: const Key('save_button'),
      onPressed: _saveProduct,
      child: const Text('Save Product'),
    );
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedProduct = Product(
      name: _nameController.text,
      price: _price!,
      category: _selectedCategory!,
      description: _descriptionController.text,
    );
    Navigator.of(context).pop(updatedProduct);
  }
}
