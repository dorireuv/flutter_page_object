import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [TextFormField] widget.
class TextFormFieldPageObject extends PageObject {
  /// Creates a [TextFormFieldPageObject] with the given [finder].
  TextFormFieldPageObject(super.t, super.finder);

  /// Enters the given text into the text field and waits for the change to be.
  Future<void> setText(String v) => t.enterText(this, v);

  /// Gets the current text value of the text field.
  String get textValue => _state.value!;

  FormFieldState<String> get _state => state();
}

/// Extension on [PageObjectFactory] to create [TextFormFieldPageObject]s.
extension TextFormFieldPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextFormFieldPageObject] with the given [key], for text
  /// fields with values of type [String].
  TextFormFieldPageObject textFormField(K key) =>
      create(TextFormFieldPageObject.new, key);
}
