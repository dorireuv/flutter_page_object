import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Text] or [RichText] widget.
class TextPageObject extends PageObject {
  /// Creates a [TextPageObject] with the given [finder].
  TextPageObject(WidgetTester t, Finder finder)
      : super(t, finder.firstDescendantWidgetMatching(_isText));

  /// Gets the text content of the [Text] widget.
  String? get text => _widget.value;

  _TextWidget get _widget {
    final w = widget();
    if (w is Text) {
      return _TextWidget(w.data ?? w.textSpan?.toPlainText() ?? '');
    } else {
      w as RichText;
      return _TextWidget(w.text.toPlainText());
    }
  }
}

/// Extension on [PageObjectFactory] to create [TextPageObject]s.
extension TextPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextPageObject] with the given [key].
  TextPageObject text(K key) => create(TextPageObject.new, key);
}

class _TextWidget {
  final String value;

  _TextWidget(this.value);
}

bool _isText(Widget w) => w is Text || w is RichText;
