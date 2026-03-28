import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'check.dart';
import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a switch widget, such as [Switch] or
/// [SwitchListTile].
class SwitchPageObject extends PageObject {
  /// Creates a [SwitchPageObject] with the given [finder].
  SwitchPageObject(WidgetTester t, Finder finder)
      : super(t, finder.firstDescendantWidgetMatching(_isSwitch));

  /// Gets the value of the switch.
  bool get value => _widget.value;

  /// Whether the switch is disabled (i.e. cannot be tapped).
  bool get isDisabled => _widget.onChanged == null;

  /// Whether the switch is enabled (i.e. can be tapped).
  bool get isEnabled => !isDisabled;

  /// Turns on the switch if it is not already on.
  Future<void> turnOn() => set(true);

  /// Turns off the switch if it is not already off.
  Future<void> turnOff() => set(false);

  /// Sets the value of the switch.
  Future<void> set(bool v) async {
    checkState(isEnabled);
    if (v != value) {
      await tapAndPump();
    }
  }

  _SwitchWidget get _widget {
    final w = widget();
    if (w is Switch) {
      return _SwitchWidget(w.value, w.onChanged);
    } else if (w is SwitchListTile) {
      return _SwitchWidget(w.value, w.onChanged);
    } else {
      w as CupertinoSwitch;
      return _SwitchWidget(w.value, w.onChanged);
    }
  }
}

/// Extension on [PageObjectFactory] to create [SwitchPageObject]s.
extension SwitchPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [SwitchPageObject] with the given [key].
  SwitchPageObject switch_(K key) => create(SwitchPageObject.new, key);
}

class _SwitchWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  _SwitchWidget(this.value, this.onChanged);
}

bool _isSwitch(Widget w) =>
    w is Switch || w is SwitchListTile || w is CupertinoSwitch;
