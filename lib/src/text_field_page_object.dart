import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object_builder.dart';
import 'page_object_factory.dart';
import 'text_input_page_object.dart';

export 'text_input_page_object.dart';

/// A page object representing a [TextField] widget.
class TextFieldPageObject<T extends Object> extends TextInputPageObject<T> {
  /// Creates a [TextFieldPageObject] with the given [finder], for text
  /// fields with values of type [T], using the given [formatter] and [parser].
  static PageObjectBuilder<TextFieldPageObject<T>> builder<T extends Object>({
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) =>
      (t, finder) =>
          TextFieldPageObject(t, finder, formatter: formatter, parser: parser);

  /// Creates a [TextFieldPageObject] with the given [finder], [formatter],
  /// and [parser]
  TextFieldPageObject(
    WidgetTester t,
    Finder finder, {
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  }) : super(
          t,
          finder.firstDescendantWidgetMatching((w) => w is TextField),
          formatter: formatter,
          parser: parser,
        );

  /// Gets the current text value of the text field.
  @override
  String get textValue {
    final w = _widget;
    if (w.controller != null) {
      return w.controller!.text;
    }

    final editableText = t.widget<EditableText>(
        find.descendant(of: this, matching: find.byType(EditableText)));
    return editableText.controller.text;
  }

  TextField get _widget => widget<TextField>();
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
