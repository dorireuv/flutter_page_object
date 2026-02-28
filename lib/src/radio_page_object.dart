import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/check.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Radio] widget.
class RadioPageObject<T> extends PageObject {
  /// Creates a [RadioPageObject] with the given [finder].
  RadioPageObject(super.t, super.finder);

  /// Whether the radio is disabled (i.e. cannot be tapped).
  bool get isDisabled => _onChanged == null;

  /// Whether the radio is enabled (i.e. can be tapped).
  bool get isEnabled => !isDisabled;

  /// Whether the radio is selected.
  bool get isSelected => value == groupValue;

  /// The value of the radio.
  T get value {
    final w = widget();
    if (w is RadioListTile<T>) {
      return w.value;
    } else if (w is Radio<T>) {
      return w.value;
    }

    throw _testFailure(w);
  }

  /// The value of the radio group.
  T? get groupValue {
    final w = widget();
    if (w is RadioListTile<T>) {
      return w.groupValue;
    } else if (w is Radio<T>) {
      // ignore: deprecated_member_use
      return w.groupValue;
    }

    throw _testFailure(w);
  }

  /// Selects the radio.
  Future<void> select() async {
    checkState(isEnabled);
    await tapAndPump();
  }

  Function(T?)? get _onChanged {
    final w = widget();
    if (w is RadioListTile<T>) {
      return w.onChanged;
    } else if (w is Radio<T>) {
      return w.onChanged;
    }

    throw _testFailure(w);
  }

  static TestFailure _testFailure(Widget widget) {
    return TestFailure(
        'RadioPageObject does not support widget of type "${widget.runtimeType}".');
  }
}

/// Extension on [PageObjectFactory] to create [RadioPageObject]s.
extension RadioPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [RadioPageObject] with the given [key].
  RadioPageObject<T> radio<T>(K key) =>
      create((t, finder) => RadioPageObject<T>(t, finder), key);
}
