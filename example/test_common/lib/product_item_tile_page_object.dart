import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:test_common/page_object_factory_extension.dart';

import 'edit_product_page_object.dart';

/// PageObject for [ProductItemTile] widget.
class ProductItemTilePageObject extends NavPageObject<EditProductPageObject> {
  late final name = d.byKey.text(Key('name'));
  late final price = d.byKey.priceText(Key('price'));

  ProductItemTilePageObject(
    super.t,
    super.finder,
  ) : super(targetBuilder: EditProductPageObject.new);
}
