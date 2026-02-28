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
  bool get isDisabled => _radioWidget.onChanged == null;

  /// Whether the radio is enabled (i.e. can be tapped).
  bool get isEnabled => !isDisabled;

  /// Whether the radio is selected.
  bool get isSelected => value == groupValue;

  /// The value of the radio.
  T get value => _radioWidget.value;

  /// The value of the radio group.
  T? get groupValue {
    // ignore: deprecated_member_use
    return _radioWidget.groupValue;
  }

  /// Selects the radio.
  Future<void> select() async {
    checkState(isEnabled);
    await tapAndPump();
  }

  Radio<T> get _radioWidget => t.widget(_radioFinder);

  Finder get _radioFinder => find.descendant(
      of: this,
      matching: find.byWidgetPredicate((widget) => widget is Radio<T>),
      matchRoot: true);
}

/// Extension on [PageObjectFactory] to create [RadioPageObject]s.
extension RadioPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [RadioPageObject] with the given [key].
  RadioPageObject<T> radio<T>(K key) =>
      create((t, finder) => RadioPageObject<T>(t, finder), key);
}
