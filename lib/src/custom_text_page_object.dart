import 'package:flutter/material.dart';

import 'page_object_factory.dart';
import 'text_page_object.dart';

/// Parser for [CustomTextPageObject].
typedef CustomTextPageObjectParser<T> = T Function(String v);

/// A page object representing a [Text] or [RichText] widget.
class CustomTextPageObject<T> extends TextPageObject {
  final CustomTextPageObjectParser<T> _parser;

  /// Creates a [CustomTextPageObject] with the given [finder].
  CustomTextPageObject(
    super.t,
    super.finder, {
    required CustomTextPageObjectParser<T> parser,
  }) : _parser = parser;

  /// Gets the current value of the text as type [T], by parsing the current
  /// text. Returns null if the text value cannot be parsed to a value of type [T].
  T get value => _parser(text);
}

/// Extension on [PageObjectFactory] to create [CustomTextPageObject]s.
extension CustomTextPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [CustomTextPageObject] with the given [key] and a given [parser].
  CustomTextPageObject<T> customText<T>(K key,
          {required CustomTextPageObjectParser<T> parser}) =>
      create(
          (t, finder) => CustomTextPageObject(t, finder, parser: parser), key);
}
