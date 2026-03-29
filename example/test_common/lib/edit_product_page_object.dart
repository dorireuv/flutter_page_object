import 'package:example/models/product_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/browse_products_page_object.dart';
import 'package:test_common/page_object_factory_extension.dart';

/// Page object for the EditProductPage.
///
/// Demonstrates various page object types including:
/// - TextFormField via TextFormFieldPageObject
/// - Typed TextFormField via TypedTextFormFieldPageObject for price
/// - Switch via SwitchPageObject
/// - Checkbox via CheckboxPageObject
/// - Dropdown via DropdownPageObject
class EditProductPageObject extends PageObject {
  late final nameTextField =
      d.byKey.textFormField(const Key('name_text_field'));
  late final descriptionTextField =
      d.byKey.textFormField(const Key('description_text_field'));
  late final priceTextField =
      d.byKey.priceTextField(const Key('price_text_field'));
  late final availableSwitch = d.byKey.switch_(const Key('available_switch'));
  late final featuredCheckbox =
      d.byKey.checkbox(const Key('featured_checkbox'));
  late final categoryDropdown =
      d.byKey.dropdown<ProductCategory>(const Key('category_dropdown'));
  late final saveButton = d.byKey.navButton(
    const Key('save_button'),
    targetBuilder: BrowseProductsPageObject.new,
  );

  EditProductPageObject(WidgetTester t)
      : super(t, find.byKey(const Key('edit_product_page')));
}
