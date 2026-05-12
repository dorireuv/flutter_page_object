import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'text_input_page_object.dart';

/// A wrapper that adds type parsing and formatting to any [TextInputPageObject].
///
/// This uses composition to expose a type-safe API, while still implementing
/// [TextInputPageObject] to allow standard page object interactions (like `tap`)
/// and raw text interactions for testing invalid inputs.
class TypedTextInputPageObject<T> extends PageObject
    implements TextInputPageObject {
  /// The underlying text input page object.
  final TextInputPageObject inner;

  /// The formatter used to format a value of type [T] to a string.
  final String Function(T v) formatter;

  /// The parser used to parse a string to a value of type [T].
  final T Function(String v) parser;

  /// Creates a [TypedTextInputPageObject].
  TypedTextInputPageObject(
    this.inner, {
    required this.formatter,
    required this.parser,
  }) : super(inner.t, inner);

  @override
  String get text => inner.text;

  @override
  Future<void> enterText(String v) => inner.enterText(v);

  @override
  Future<void> submitText([String? v]) => inner.submitText(v);

  @override
  Future<void> doAction(TextInputAction action) => inner.doAction(action);

  /// Returns true if the text input has focus.
  @override
  bool get hasFocus => inner.hasFocus;

  /// Sets the value of the text input to the given value of type [T].
  Future<void> enterValue(T v) => inner.enterText(formatter(v));

  /// Submits the text input, triggering onSubmitted callbacks (simulating the
  /// keyboard's Done/Submit action).
  Future<void> submit() => inner.submitText();

  /// Submits the text input with the given value of type [T].
  Future<void> submitValue(T v) => inner.submitText(formatter(v));

  /// Gets the current value of the text input as type [T].
  T get value => parser(inner.text);
}
