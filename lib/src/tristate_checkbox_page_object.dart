import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Checkbox] or [CheckboxListTile] widget with
/// `tristate` set to `true`.
class TristateCheckboxPageObject extends PageObject {
  /// Creates a [TristateCheckboxPageObject] with the given [finder].
  TristateCheckboxPageObject(WidgetTester t, Finder finder)
      : super(t, finder.firstDescendantWidgetMatching(_isCheckbox));

  /// Gets whether the checkbox is disabled.
  bool get isDisabled => _checkboxWidget.onChanged == null;

  /// Whether the checkbox is enabled (i.e. can be tapped).
  bool get isEnabled => !isDisabled;

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

  _CheckboxWidget get _checkboxWidget {
    final w = widget();
    if (w is Checkbox) {
      return _CheckboxWidget(w.value, w.onChanged, w.tristate);
    } else if (w is CheckboxListTile) {
      return _CheckboxWidget(w.value, w.onChanged, w.tristate);
    } else {
      w as CupertinoCheckbox;
      return _CheckboxWidget(w.value, w.onChanged, w.tristate);
    }
  }
}

/// Extension on [PageObjectFactory] to create [TristateCheckboxPageObject]s.
extension TristateCheckboxPageObjectFactoryExtension<K>
    on PageObjectFactory<K> {
  /// Creates a [TristateCheckboxPageObject] with the given [key].
  TristateCheckboxPageObject tristateCheckbox(K key) =>
      create(TristateCheckboxPageObject.new, key);
}

class _CheckboxWidget {
  final bool? value;
  final ValueChanged<bool>? onChanged;

  _CheckboxWidget(this.value, this.onChanged, bool tristate) {
    assert(tristate);
  }
}

bool _isCheckbox(Widget w) =>
    w is Checkbox || w is CheckboxListTile || w is CupertinoCheckbox;
