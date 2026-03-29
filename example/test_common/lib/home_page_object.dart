import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/browse_products_page_object.dart';

final _finder = find.byType(Scaffold).first;

class HomePageObject extends PageObject {
  late final greetingText = d.byKey.text(const Key('greeting_text'));
  late final browseProductsButton = d.byKey.navButton(
    const Key('browse_products_button'),
    targetBuilder: BrowseProductsPageObject.new,
  );

  HomePageObject(WidgetTester t) : super(t, _finder);
}
