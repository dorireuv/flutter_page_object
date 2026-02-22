import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Checkbox] or [CheckboxListTile] widget with
/// `tristate` set to `true`.
class TristateCheckboxPageObject extends PageObject {
  /// Creates a [TristateCheckboxPageObject] with the given [finder].
  TristateCheckboxPageObject(super.t, super.finder);

  /// Gets whether the checkbox is disabled.
  bool get isDisabled => _checkboxWidget.onChanged == null;

  /// Gets the current value of the checkbox, which can be `true`, `false`,
  /// or `null` (indeterminate).
  bool? get value => _checkboxWidget.value;

  /// Checks the checkbox by setting its value to `true`.
  Future<void> check() => set(true);

  /// Unchecks the checkbox by setting its value to `false`.
  Future<void> uncheck() => set(false);

  /// Sets the checkbox to the indeterminate state by setting its value to
  /// `null`.
  Future<void> indeterminate() => set(null);

  /// Sets the value of the checkbox to the given value, which can be `true`,
  /// `false`, or `null` (indeterminate).
  Future<void> set(bool? v) async {
    if (isDisabled) {
      throw StateError('widget is disabled, cannot set its value');
    }

    while (value != v) {
      await tapAndPump();
    }
  }

  Checkbox get _checkboxWidget {
    final checkbox = t.widget<Checkbox>(_checkboxFinder);
    assert(checkbox.tristate);
    return checkbox;
  }

  Finder get _checkboxFinder => find.descendant(
      of: finder, matching: find.byType(Checkbox), matchRoot: true);
}

/// Extension on [PageObjectFactory] to create [TristateCheckboxPageObject]s.
extension TristateCheckboxPageObjectFactoryExtension<K>
    on PageObjectFactory<K> {
  /// Creates a [TristateCheckboxPageObject] with the given [key].
  TristateCheckboxPageObject tristateCheckbox(K key) =>
      create(TristateCheckboxPageObject.new, key);
}
