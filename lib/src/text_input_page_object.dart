import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';

/// A base page object for text input widgets.
abstract class TextInputPageObject extends PageObject {
  /// Creates a [TextInputPageObject].
  TextInputPageObject(super.t, super.finder);

  /// Gets the current text value of the text field.
  String get text;

  /// Sets the value of the text field to the given value.
  Future<void> enterText(String v) => t.enterText(this, v);

  /// Submits the text field, triggering onSubmitted callbacks (simulating the
  /// keyboard's Done/Submit action).
  Future<void> submitText([String? v]) async {
    if (v != null) {
      await enterText(v);
    }
    await doAction(TextInputAction.done);
  }

  /// Performs the given [TextInputAction] on the text field.
  Future<void> doAction(TextInputAction action) =>
      t.testTextInput.receiveAction(action);
}
