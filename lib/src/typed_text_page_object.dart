import 'package:flutter/material.dart';

import 'page_object_factory.dart';
import 'text_page_object.dart';

/// Parser for [TypedTextPageObject].
typedef TypedTextPageObjectParser<T> = T Function(String v);

/// A page object representing a [Text] or [RichText] widget.
class TypedTextPageObject<T> extends TextPageObject {
  final TypedTextPageObjectParser<T> _parser;

  /// Creates a [TypedTextPageObject] with the given [finder].
  TypedTextPageObject(
    super.t,
    super.finder, {
    required TypedTextPageObjectParser<T> parser,
  }) : _parser = parser;

  /// Gets the current value of the text as type [T], by parsing the current
  /// text. Returns null if the text value cannot be parsed to a value of type [T].
  T get value => _parser(text);
}

/// Extension on [PageObjectFactory] to create [TypedTextPageObject]s.
extension TypedTextPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TypedTextPageObject] with the given [key] and a given [parser].
  TypedTextPageObject<T> typedText<T>(K key,
          {required TypedTextPageObjectParser<T> parser}) =>
      create(
          (t, finder) => TypedTextPageObject(t, finder, parser: parser), key);
}
