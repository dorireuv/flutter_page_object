import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'finder_utils.dart';
import 'page_object_factory.dart';
import 'text_input_page_object.dart';

/// A page object representing a [TextFormField] widget.
class TextFormFieldPageObject extends TextInputPageObject {
  /// Creates a [TextFormFieldPageObject] with the given [finder].
  TextFormFieldPageObject(WidgetTester t, Finder finder)
      : super(
            t, finder.firstDescendantWidgetMatching((w) => w is TextFormField));

  @override
  String get text => _state.value!;

  FormFieldState<String> get _state => state();
}

/// Extension on [PageObjectFactory] to create [TextFormFieldPageObject]s.
extension TextFormFieldPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextFormFieldPageObject] with the given [key].
  TextFormFieldPageObject textFormField(K key) =>
      create(TextFormFieldPageObject.new, key);
}
