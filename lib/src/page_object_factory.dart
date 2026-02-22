import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_builder.dart';

/// A typedef for a function that builds a [Finder] given a key of type [K].
typedef FinderBuilder<K> = Finder Function(K);

/// A factory for creating page objects based on a key of type [K].
final class PageObjectFactory<K> {
  final WidgetTester _t;
  final FinderBuilder<K> _finderBuilder;

  /// Creates a [PageObjectFactory] that is looking for widgets starting from
  /// the root of the widget tree.
  static PageObjectFactory<Finder> root(WidgetTester t) {
    return PageObjectFactory._(t, (f) => f);
  }

  /// Creates a [PageObjectFactory] that is looking for widgets that are
  /// descendants of a given [ancestor].
  static PageObjectFactory<Finder> descendantOf(
      WidgetTester t, Finder ancestor) {
    return PageObjectFactory._(
      t,
      (f) => find.descendant(of: ancestor, matching: f, matchRoot: true),
    );
  }

  PageObjectFactory._(this._t, this._finderBuilder);

  /// Maps the keys of this factory to new keys of type [NewKey] using the given
  /// [mapping] function, and returns a new factory with the new key type.
  PageObjectFactory<NewKey> map<NewKey>(K Function(NewKey) mapping) {
    return PageObjectFactory._(_t, (newKey) => _finderBuilder(mapping(newKey)));
  }

  /// Creates a page object of type [T] using the given [pageObjectBuilder] and
  /// [key].
  T create<T extends PageObject>(
      PageObjectBuilder<T> pageObjectBuilder, K key) {
    return pageObjectBuilder(_t, _finderBuilder(key));
  }

  /// Creates a page object of type [T] using the given [staticBuilder].
  T createStatic<T extends PageObject>(T Function(WidgetTester) staticBuilder) {
    return staticBuilder(_t);
  }
}

/// An extension on [PageObjectFactory] that provides factories for common
/// finder types.
extension PageObjectFactoryFinderExtension on PageObjectFactory<Finder> {
  /// A factory that creates page objects by finding widgets by key.
  PageObjectFactory<Key> get byKey => map((key) => find.byKey(key));

  /// A factory that creates page objects by finding widgets by icon.
  PageObjectFactory<IconData> get byIcon => map((icon) => find.byIcon(icon));

  /// A factory that creates page objects by finding widgets by type.
  PageObjectFactory<Type> get byType => map((type) => find.byType(type));

  /// A factory that creates page objects by finding widgets by text containing
  /// a given string.
  PageObjectFactory<String> get textContaining =>
      map((text) => find.textContaining(text));
}
