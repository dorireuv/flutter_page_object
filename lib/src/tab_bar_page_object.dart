import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [TabBar] widget.
class TabBarPageObject extends PageObject {
  /// Creates a [TabBarPageObject] with the given [finder].
  TabBarPageObject(super.t, super.finder);

  /// Selects the tab at the given [index].
  Future<void> select(int index) async {
    await t.tap(_tabFinder.at(index));
    await t.pump();
  }

  /// The index of the currently selected tab.
  int get selectedIndex => _tabController.index;

  Finder get _tabFinder =>
      find.descendant(of: this, matching: find.byType(Tab));

  TabController get _tabController =>
      _tabBar.controller ?? DefaultTabController.of(finder.evaluate().first);

  TabBar get _tabBar => widget<TabBar>();
}

/// Extension on [PageObjectFactory] to create [TabBarPageObject]s.
extension TabBarPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TabBarPageObject] with the given [key].
  TabBarPageObject tabBar(K key) => create(TabBarPageObject.new, key);
}
