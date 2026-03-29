import 'package:example/product_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'product_item_tile_page_object.dart';

/// Page object for the ProductListPage.
class BrowseProductsPageObject extends PageObject {
  late final itemsList = d.byKey.scrollableList(
    const Key('items_list'),
    find.byType(ProductItemTile),
    ProductItemTilePageObject.new,
  );

  BrowseProductsPageObject(WidgetTester t)
      : super(t, find.byKey(const Key('browse_products_page')));
}
