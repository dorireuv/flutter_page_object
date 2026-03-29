import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'nav_page_object.dart';
import 'page_object.dart';
import 'page_object_builder.dart';
import 'page_object_factory.dart';

/// A page object representing a [BottomNavigationBar] widget.
class BottomNavigationBarPageObject extends PageObject {
  /// Creates a [BottomNavigationBarPageObject] with the given [finder].
  BottomNavigationBarPageObject(super.t, super.finder);

  /// The index of the currently selected item.
  int get selectedIndex => _widget.currentIndex;

  /// Selects the item at the given [index].
  Future<void> selectByIndex(int index) async {
    await t.tap(_itemFinder.at(index));
    await t.pump();
  }

  /// Selects the item with the given [icon].
  Future<void> selectByIcon<T>(IconData icon) async {
    await t.tap(find.descendant(of: this, matching: find.byIcon(icon)));
    await t.pump();
  }

  /// Creates a [NavPageObject] for the item with the given [icon] and
  /// [targetBuilder].
  NavPageObject<T> item<T extends PageObject>({
    required IconData icon,
    required PageObjectStaticBuilder<T> targetBuilder,
  }) {
    return d.byIcon.nav(icon, targetBuilder: targetBuilder);
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
