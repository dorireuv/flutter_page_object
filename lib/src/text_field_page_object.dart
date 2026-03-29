import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'finder_utils.dart';
import 'page_object_factory.dart';
import 'text_input_page_object.dart';

/// A page object representing a [TextField] widget.
class TextFieldPageObject extends TextInputPageObject {
  /// Creates a [TextFieldPageObject] with the given [finder].
  TextFieldPageObject(WidgetTester t, Finder finder)
      : super(t, finder.firstDescendantWidgetMatching((w) => w is TextField));

  @override
  String get text {
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
  TextFieldPageObject textField(K key) => create(TextFieldPageObject.new, key);
}
