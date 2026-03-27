import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';

/// A base page object for text input widgets.
abstract class TextInputPageObject<T extends Object> extends PageObject {
  final String Function(T v) _formatter;
  final T? Function(String v) _parser;

  /// Creates a [TextInputPageObject].
  TextInputPageObject(
    super.t,
    super.finder, {
    required String Function(T v) formatter,
    required T? Function(String v) parser,
  })  : _formatter = formatter,
        _parser = parser;

  /// Sets the value of the text field to the given value of type [T], by
  /// formatting it to a string and entering the text.
  Future<void> setValue(T v) => t.enterText(this, _formatter(v));

  /// Performs the given [TextInputAction] on the text field.
  Future<void> doAction(TextInputAction action) =>
      t.testTextInput.receiveAction(action);

  /// Submits the text field, triggering onSubmitted callbacks (simulating the
  /// keyboard's Done/Submit action).
  Future<void> submit([T? v]) async {
    if (v != null) {
      await setValue(v);
    }
    await doAction(TextInputAction.done);
  }

  /// Gets the current text value of the text field.
  String get textValue;

  /// Gets the current value of the text field as type [T], by parsing the
  /// current text value. Returns null if the text value cannot be parsed to a
  /// value of type [T].
  T? get value => _parser(textValue);
}

/// Extension on [TextInputPageObject] to enter text.
extension EnterTextTextInputPageObjectExtension on TextInputPageObject<String> {
  /// Sets the value of the text field to the given value.
  Future<void> enterText(String v) => setValue(v);

  /// Gets the current text value of the text field.
  String get text => textValue;
}
