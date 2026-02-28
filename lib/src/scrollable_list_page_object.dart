import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_builder.dart';
import 'page_object_factory.dart';
import 'scrollable_page_object.dart';
import 'widget_list_page_object.dart';

/// A page object representing a scrollable list of widgets of type [T].
/// It combines the functionalities of [ScrollablePageObject] and
/// [WidgetListPageObject].
class ScrollableListPageObject<T extends PageObject> extends PageObject
    with IsScrollable {
  /// Creates a [ScrollableListPageObject] with the given [finder] for the overall
  /// scrollable list, and a [builder] for the individual list items.
  static PageObjectBuilder<ScrollableListPageObject<T>>
      builder<T extends PageObject, K extends Object>(
              Finder itemsFinder, PageObjectBuilder<T> itemBuilder) =>
          (t, finder) =>
              ScrollableListPageObject(t, finder, itemsFinder, itemBuilder);

  late final WidgetListPageObject<T> _widgetList;

  /// Creates a [ScrollableListPageObject].
  ScrollableListPageObject(super.t, super.finder, Finder itemsFinder,
      PageObjectBuilder<T> itemBuilder) {
    _widgetList = d.widgetList(this, itemsFinder, itemBuilder);
  }

  /// Gets the page object for the item at the given index.
  T operator [](int index) => _widgetList[index];

  /// Gets all items in the list.
  List<T> get all => _widgetList.all;

  /// Gets the number of items in the list.
  int get count => _widgetList.count;

  /// Gets the page object item matching the given [itemFinder].
  T item(Finder itemFinder) => _widgetList.item(itemFinder);
}

/// Extension on [PageObjectFactory] to create [ScrollableListPageObject]s.
extension ScrollableListPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [ScrollableListPageObject] with the given [key] and [widgetList].
  ScrollableListPageObject<T> scrollableList<T extends PageObject>(
          K key, Finder itemsFinder, PageObjectBuilder<T> itemBuilder) =>
      create(ScrollableListPageObject.builder(itemsFinder, itemBuilder), key);
}
