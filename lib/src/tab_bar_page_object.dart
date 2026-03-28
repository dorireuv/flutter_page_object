import 'package:flutter/material.dart';
import 'finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [TabBar] widget.
class TabBarPageObject extends PageObject {
  /// Creates a [TabBarPageObject] with the given [finder].
  TabBarPageObject(WidgetTester t, Finder finder)
      : super(t, finder.firstDescendantWidgetMatching((w) => w is TabBar));

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
      _widget.controller ?? DefaultTabController.of(evaluate().first);

  TabBar get _widget => widget<TabBar>();
}

/// Extension on [PageObjectFactory] to create [TabBarPageObject]s.
extension TabBarPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TabBarPageObject] with the given [key].
  TabBarPageObject tabBar(K key) => create(TabBarPageObject.new, key);
}
