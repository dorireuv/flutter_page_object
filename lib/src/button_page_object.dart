import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a button.
class ButtonPageObject extends PageObject {
  /// Creates a [ButtonPageObject] with the given [finder].
  ButtonPageObject(super.t, super.finder);

  /// Whether the button is enabled.
  bool get isEnabled {
    final w = widget<Widget>();
    if (w is ButtonStyleButton) {
      return w.onPressed != null;
    } else if (w is IconButton) {
      return w.onPressed != null;
    } else if (w is MaterialButton) {
      return w.onPressed != null;
    } else if (w is CupertinoButton) {
      return w.onPressed != null;
    } else if (w is FloatingActionButton) {
      return w.onPressed != null;
    }
    throw TestFailure(
        'ButtonPageObject does not support widget of type "${w.runtimeType}".');
  }

  /// Whether the button is disabled.
  bool get isDisabled => !isEnabled;
}

/// Extension on [PageObjectFactory] to create [ButtonPageObject]s.
extension ButtonPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [ButtonPageObject] with the given [key].
  ButtonPageObject button(K key) => create(ButtonPageObject.new, key);
}
