import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [BottomNavigationBar] widget.
class BottomNavigationBarPageObject extends PageObject {
  /// Creates a [BottomNavigationBarPageObject] with the given [finder].
  BottomNavigationBarPageObject(super.t, super.finder);

  /// The index of the currently selected item.
  int get selectedIndex => _widget.currentIndex;

  /// Selects the item at the given [index].
  Future<void> select(int index) async {
    await t.tap(_itemFinder.at(index));
    await t.pump();
  }

  Finder get _itemFinder =>
      find.descendant(of: this, matching: find.byType(Icon));

  BottomNavigationBar get _widget => widget<BottomNavigationBar>();
}

/// Extension on [PageObjectFactory] to create [BottomNavigationBarPageObject]s.
extension BottomNavigationBarPageObjectFactoryExtension<K>
    on PageObjectFactory<K> {
  /// Creates a [BottomNavigationBarPageObject] with the given [key].
  BottomNavigationBarPageObject bottomNavigationBar(K key) =>
      create(BottomNavigationBarPageObject.new, key);
}
