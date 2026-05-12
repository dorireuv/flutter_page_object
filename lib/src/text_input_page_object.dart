import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';

/// A base page object for text input widgets.
abstract class TextInputPageObject extends PageObject {
  /// Creates a [TextInputPageObject].
  TextInputPageObject(super.t, super.finder);

  /// Gets the current text value of the text input.
  String get text;

  /// Sets the value of the text input to the given value.
  Future<void> enterText(String v) => t.enterText(this, v);

  /// Submits the text input, triggering onSubmitted callbacks (simulating the
  /// keyboard's Done/Submit action).
  Future<void> submitText([String? v]) async {
    if (v != null) {
      await enterText(v);
    }
    await doAction(TextInputAction.done);
  }

  /// Performs the given [TextInputAction] on the text input.
  Future<void> doAction(TextInputAction action) =>
      t.testTextInput.receiveAction(action);

  /// Returns true if the text input has focus.
  bool get hasFocus => _editableText.focusNode.hasFocus;

  EditableText get _editableText => t.widget<EditableText>(_editableTextFinder);

  Finder get _editableTextFinder =>
      find.descendant(of: this, matching: find.byType(EditableText));
}
