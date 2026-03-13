import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'check.dart';
import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Checkbox] or [CheckboxListTile] widget.
class CheckboxPageObject extends PageObject {
  /// Creates a [CheckboxPageObject] with the given [finder].
  CheckboxPageObject(super.t, super.finder);

  /// Whether the checkbox is disabled (i.e. cannot be tapped).
  bool get isDisabled => _checkboxWidget.onChanged == null;

  /// Whether the checkbox is enabled (i.e. can be tapped).
  bool get isEnabled => !isDisabled;

  /// Whether the checkbox is checked.
  bool get value => _checkboxWidget.value;

  /// Checks the checkbox if it is not already checked.
  Future<void> check() => set(true);

  /// Unchecks the checkbox if it is not already unchecked.
  Future<void> uncheck() => set(false);

  /// Sets the checkbox to the given value.
  Future<void> set(bool v) async {
    checkState(isEnabled);

    while (value != v) {
      await tapAndPump();
    }
  }

  _CheckboxWidget get _checkboxWidget {
    final w = widget();
    if (w is Checkbox) {
      return _CheckboxWidget(w.value, w.onChanged, w.tristate);
    } else if (w is CheckboxListTile) {
      return _CheckboxWidget(w.value, w.onChanged, w.tristate);
    } else if (w is CupertinoCheckbox) {
      return _CheckboxWidget(w.value, w.onChanged, w.tristate);
    }
    throw TestFailure(
        '$runtimeType does not support widget of type "${w.runtimeType}".');
  }
}

/// Extension on [PageObjectFactory] to create [CheckboxPageObject]s.
extension CheckboxPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [CheckboxPageObject] with the given [key].
  CheckboxPageObject checkbox(K key) => create(CheckboxPageObject.new, key);
}

class _CheckboxWidget {
  final bool? _value;
  final ValueChanged<bool>? onChanged;

  _CheckboxWidget(this._value, this.onChanged, bool tristate) {
    assert(!tristate);
    assert(_value != null);
  }

  bool get value => _value!;
}
