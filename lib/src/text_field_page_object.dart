import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_builder.dart';
import 'page_object_factory.dart';

/// A page object representing a [TextField] widget.
class TextFieldPageObject<T extends Object> extends PageObject {
  /// Creates a [TextFieldPageObject] with the given [finder], for text
  /// fields with values of type [T], using the given [formatter] and [parser].
  static PageObjectBuilder<TextFieldPageObject<T>> builder<T extends Object>({
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) =>
      (t, finder) =>
          TextFieldPageObject(t, finder, formatter: formatter, parser: parser);

  final String Function(T v) _formatter;
  final T? Function(String v) _parser;

  /// Creates a [TextFieldPageObject] with the given [finder], [formatter],
  /// and [parser]
  TextFieldPageObject(
    super.t,
    super.finder, {
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  })  : _formatter = formatter,
        _parser = parser;

  /// Enters the given text into the text field.
  Future<void> setText(String v) => t.enterText(this, v);

  /// Gets the current text value of the text field.
  String get textValue {
    final w = descendantWidgetMatchingType<TextField>();
    if (w.controller != null) {
      return w.controller!.text;
    }

    final editableText = t.widget<EditableText>(
        find.descendant(of: this, matching: find.byType(EditableText)));
    return editableText.controller.text;
  }

  /// Sets the value of the text field to the given value of type [T], by
  /// formatting it to a string and entering the text.
  Future<void> set(T v) => setText(_formatter(v));

  /// Gets the current value of the text field as type [T], by parsing the
  /// current text value. Returns null if the text value cannot be parsed to a
  /// value of type [T].
  T? get value => _parser(textValue);
}

/// Extension on [PageObjectFactory] to create [TextFieldPageObject]s.
extension TextFieldPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextFieldPageObject] with the given [key].
  TextFieldPageObject<String> textField(K key) =>
      customTextField(key, formatter: (v) => v, parser: (v) => v);

  /// Creates a [TextFieldPageObject] with the given [key], for text
  /// fields with values of type [T], using the given [formatter] and [parser].
  TextFieldPageObject<T> customTextField<T extends Object>(
    K key, {
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) =>
      create(
          TextFieldPageObject.builder<T>(formatter: formatter, parser: parser),
          key);
}
