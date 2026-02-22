import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_builder.dart';
import 'page_object_factory.dart';

/// A page object representing a list of widgets of type [T].
class WidgetListPageObject<T extends PageObject> extends PageObject {
  /// Creates a [WidgetListPageObject] with the given [finder] and [itemBuilder].
  static PageObjectBuilder<WidgetListPageObject<T>>
      builder<T extends PageObject>(
              Finder itemsFinder, PageObjectBuilder<T> itemBuilder) =>
          (t, finder) =>
              WidgetListPageObject(t, finder, itemsFinder, itemBuilder);

  final Finder _itemsFinder;
  final PageObjectBuilder<T> _itemBuilder;

  /// Creates a [WidgetListPageObject] with the given [finder] and [_itemBuilder].
  WidgetListPageObject(
      super.t, super.finder, this._itemsFinder, this._itemBuilder);

  /// Gets the page object at the given index in the list.
  T operator [](int index) => _buildItem(_itemsFinder.at(index));

  /// Gets all items.
  List<T> get all {
    final count = _itemsFinder.evaluate().length;
    return List<T>.generate(count, (i) => this[i]);
  }

  /// Gets the page object item matching the given [itemFinder].
  T item(Finder itemFinder) => _buildItem(itemFinder);

  T _buildItem(Finder itemFinder) => _itemBuilder(t, itemFinder);
}

/// Extension on [PageObjectFactory] to create [WidgetListPageObject]s.
extension WidgetListPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [WidgetListPageObject] with the given [key] and [itemBuilder].
  WidgetListPageObject<T> widgetList<T extends PageObject>(
          K key, Finder itemsFinder, PageObjectBuilder<T> itemBuilder) =>
      create(WidgetListPageObject.builder(itemsFinder, itemBuilder), key);
}
