import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/typed_text_input_page_object.dart';

import 'finder_utils.dart';
import 'page_object_factory.dart';
import 'text_form_field_page_object.dart';

/// A typedef for a typed [TypedTextInputPageObject] representing a
/// [TextFormField].
typedef TypedTextFormFieldPageObject<T> = TypedTextInputPageObject<T>;

/// Extension on [PageObjectFactory] to create [TypedTextInputPageObject]s for [TextFormField].
extension TypedTextFormFieldPageObjectFactoryExtension<K>
    on PageObjectFactory<K> {
  /// Creates a typed [TextInputPageObject] with the given [key], for text
  /// fields with values of type [T], using the given [formatter] and [parser].
  TypedTextFormFieldPageObject<T> typedTextFormField<T>(
    K key, {
    required String Function(T v) formatter,
    required T Function(String v) parser,
  }) =>
      TypedTextInputPageObject<T>(
        create(
            (t, finder) => TextFormFieldPageObject(
                t,
                finder
                    .firstDescendantWidgetMatching((w) => w is TextFormField)),
            key),
        formatter: formatter,
        parser: parser,
      );
}
