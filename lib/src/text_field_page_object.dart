import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [TextField] widget.
class TextFieldPageObject extends PageObject {
  /// Creates a [TextFieldPageObject] with the given [finder].
  TextFieldPageObject(super.t, super.finder);

  /// Enters the given text into the text field.
  Future<void> setText(String v) => t.enterText(this, v);

  /// Gets the current text value of the text field.
  String get textValue {
    final w = widget<TextField>();
    if (w.controller != null) {
      return w.controller!.text;
    }

    final editableText = t.widget<EditableText>(
        find.descendant(of: this, matching: find.byType(EditableText)));
    return editableText.controller.text;
  }
}

/// Extension on [PageObjectFactory] to create [TextFieldPageObject]s.
extension TextFieldPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextFieldPageObject] with the given [key].
  TextFieldPageObject textField(K key) => create(TextFieldPageObject.new, key);
}
