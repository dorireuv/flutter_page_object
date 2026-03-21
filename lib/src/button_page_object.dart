import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a button.
class ButtonPageObject extends PageObject {
  /// Creates a [ButtonPageObject] with the given [finder].
  ButtonPageObject(WidgetTester t, Finder finder)
      : super(t, finder.firstDescendantWidgetMatching(_isButton));

  /// Whether the button is enabled.
  bool get isEnabled => _widget.onPressed != null;

  _ButtonWidget get _widget {
    final w = widget();
    if (w is ButtonStyleButton) {
      return _ButtonWidget(w.onPressed);
    } else if (w is IconButton) {
      return _ButtonWidget(w.onPressed);
    } else if (w is MaterialButton) {
      return _ButtonWidget(w.onPressed);
    } else if (w is CupertinoButton) {
      return _ButtonWidget(w.onPressed);
    } else if (w is FloatingActionButton) {
      return _ButtonWidget(w.onPressed);
    } else {
      w as RawMaterialButton;
      return _ButtonWidget(w.onPressed);
    }
  }

  /// Whether the button is disabled.
  bool get isDisabled => !isEnabled;
}

/// Extension on [PageObjectFactory] to create [ButtonPageObject]s.
extension ButtonPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [ButtonPageObject] with the given [key].
  ButtonPageObject button(K key) => create(ButtonPageObject.new, key);
}

class _ButtonWidget {
  final VoidCallback? onPressed;

  _ButtonWidget(this.onPressed);
}

bool _isButton(Widget w) =>
    w is ButtonStyleButton ||
    w is IconButton ||
    w is MaterialButton ||
    w is CupertinoButton ||
    w is FloatingActionButton ||
    w is RawMaterialButton;
