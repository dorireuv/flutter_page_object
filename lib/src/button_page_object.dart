import 'package:flutter/material.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a button.
class ButtonPageObject extends PageObject {
  /// Creates a [ButtonPageObject] with the given [finder].
  ButtonPageObject(super.t, super.finder);

  /// Whether the button is enabled.
  bool get isEnabled => _styleButtonWidget.onPressed != null;

  ButtonStyleButton get _styleButtonWidget => widget<ButtonStyleButton>();
}

/// Extension on [PageObjectFactory] to create [ButtonPageObject]s.
extension ButtonPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [ButtonPageObject] with the given [key].
  ButtonPageObject button(K key) => create(ButtonPageObject.new, key);
}
