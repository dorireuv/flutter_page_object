import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object_builder.dart';
import 'page_object_factory.dart';
import 'text_input_page_object.dart';

export 'text_input_page_object.dart';

/// A page object representing a [TextFormField] widget.
class TextFormFieldPageObject<T extends Object> extends TextInputPageObject<T> {
  /// Creates a [TextFormFieldPageObject] with the given [finder], for text
  /// fields with values of type [T], using the given [formatter] and [parser].
  static PageObjectBuilder<TextFormFieldPageObject<T>>
      builder<T extends Object>({
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) =>
          (t, finder) => TextFormFieldPageObject(t, finder,
              formatter: formatter, parser: parser);

  /// Creates a [TextFormFieldPageObject] with the given [finder], [formatter],
  /// and [parser]
  TextFormFieldPageObject(
    WidgetTester t,
    Finder finder, {
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) : super(
          t,
          finder.firstDescendantWidgetMatching((w) => w is TextFormField),
          formatter: formatter,
          parser: parser,
        );

  /// Gets the current text value of the text field.
  @override
  String get textValue => _state.value!;

  FormFieldState<String> get _state => state();
}

/// Extension on [PageObjectFactory] to create [TextFormFieldPageObject]s.
extension TextFormFieldPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextFormFieldPageObject] with the given [key].
  TextFormFieldPageObject<String> textFormField(K key) =>
      customTextFormField(key, formatter: (v) => v, parser: (v) => v);

  /// Creates a [TextFormFieldPageObject] with the given [key], for text
  /// fields with values of type [T], using the given [formatter] and [parser].
  TextFormFieldPageObject<T> customTextFormField<T extends Object>(
    K key, {
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) =>
      create(
          TextFormFieldPageObject.builder<T>(
              formatter: formatter, parser: parser),
          key);
}
