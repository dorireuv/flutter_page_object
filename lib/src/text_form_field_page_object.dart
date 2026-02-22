import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_builder.dart';
import 'page_object_factory.dart';

/// A page object representing a [TextFormField] widget.
class TextFormFieldPageObject<T extends Object> extends PageObject {
  /// Creates a [TextFormFieldPageObject] with the given [finder], for
  /// text fields with values of type [String].
  static TextFormFieldPageObject<String> string(
          WidgetTester t, Finder finder) =>
      TextFormFieldPageObject(t, finder, formatter: (v) => v, parser: (v) => v);

  /// Creates a [TextFormFieldPageObject] with the given [finder], for text
  /// fields with values of type [T], using the given [formatter] and [parser].
  static PageObjectBuilder<TextFormFieldPageObject<T>>
      builder<T extends Object>({
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) =>
          (t, finder) => TextFormFieldPageObject(t, finder,
              formatter: formatter, parser: parser);

  final String Function(T v) _formatter;
  final T? Function(String v) _parser;

  /// Creates a [TextFormFieldPageObject] with the given [finder], [formatter],
  /// and [parser]
  TextFormFieldPageObject(
    super.t,
    super.finder, {
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  })  : _formatter = formatter,
        _parser = parser;

  /// Enters the given text into the text field and waits for the change to be
  Future<void> setText(String v) => t.enterText(_textFormField, v);

  /// Gets the current text value of the text field.
  String get textValue => _state.value!;

  /// Sets the value of the text field to the given value of type [T], by
  /// formatting it to a string and entering the text.
  Future<void> set(T v) => setText(_formatter(v));

  /// Gets the current value of the text field as type [T], by parsing the
  /// current text value. Returns null if the text value cannot be parsed to a
  /// value of type [T].
  T? get value => _parser(textValue);

  FormFieldState<String> get _state => t.state(_textFormField);

  Finder get _textFormField => find.descendant(
      of: this, matching: find.byType(TextFormField), matchRoot: true);
}

/// Extension on [PageObjectFactory] to create [TextFormFieldPageObject]s.
extension TextFormFieldPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextFormFieldPageObject] with the given [key], for text
  /// fields with values of type [String].
  TextFormFieldPageObject<T> textFormField<T extends Object>(
    K key, {
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) =>
      create(
          TextFormFieldPageObject.builder(formatter: formatter, parser: parser),
          key);

  /// Creates a [TextFormFieldPageObject] with the given [key], for text
  /// fields with values of type [String].
  TextFormFieldPageObject<String> stringTextFormField(K key) =>
      create(TextFormFieldPageObject.string, key);
}
