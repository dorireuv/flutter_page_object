import 'package:flutter/material.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Text] widget.
class TextPageObject extends PageObject {
  /// Creates a [TextPageObject] with the given [finder].
  TextPageObject(super.t, super.finder);

  /// Gets the text content of the [Text] widget.
  String? get text => _widget.data;

  /// Gets the text content of the [Text] widget, or an empty string if it is
  /// `null`.
  String get textOrEmpty => text ?? '';

  /// Gets the plain text content of the [Text.textSpan].
  String? get textSpanPlainText => _widget.textSpan?.toPlainText();

  /// Gets the plain text content of the [Text.textSpan], or an empty string if
  /// it is `null`.
  String get textSpanPlainTextOrEmpty => textSpanPlainText ?? '';

  Text get _widget => widget();
}

/// Extension on [PageObjectFactory] to create [TextPageObject]s.
extension TextPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextPageObject] with the given [key].
  TextPageObject text(K key) => create(TextPageObject.new, key);
}
