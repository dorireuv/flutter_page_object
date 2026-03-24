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

  /// Gets the text content of the text widget.
  String get text => _widget.value;

  _TextWidget get _widget {
    final w = widget();
    if (w is Text) {
      return _TextWidget.fromText(w);
    } else {
      w as RichText;
      return _TextWidget.fromRichText(w);
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

  factory _TextWidget.fromText(Text w) {
    final data = w.data;
    final textSpan = w.textSpan;
    if (data != null) {
      return _TextWidget(data);
    } else if (textSpan != null) {
      return _TextWidget.fromSpan(textSpan);
    } else {
      return _TextWidget.empty();
    }
  }

  factory _TextWidget.fromRichText(RichText w) => _TextWidget.fromSpan(w.text);

  factory _TextWidget.fromSpan(InlineSpan w) {
    return _TextWidget(w.toPlainText(
        includeSemanticsLabels: false, includePlaceholders: false));
  }

  factory _TextWidget.empty() => _TextWidget('');
}

bool _isText(Widget w) => w is Text || w is RichText;
