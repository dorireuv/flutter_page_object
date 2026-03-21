import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'check.dart';
import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Radio] widget.
class RadioPageObject<T> extends PageObject {
  /// Creates a [RadioPageObject] with the given [finder].
  RadioPageObject(WidgetTester t, Finder finder)
      : super(t, finder.firstDescendantWidgetMatching(_isRadio<T>));

  /// Whether the radio is disabled (i.e. cannot be tapped).
  bool get isDisabled => _onChanged == null;

  /// Whether the radio is enabled (i.e. can be tapped).
  bool get isEnabled => !isDisabled;

  /// Whether the radio is selected.
  bool get isSelected => value == groupValue;

  /// The value of the radio.
  T get value => _widget.value;

  /// The value of the radio group.
  T? get groupValue => _widget.groupValue;

  /// Selects the radio.
  Future<void> select() async {
    checkState(isEnabled);
    await tapAndPump();
  }

  Function(T?)? get _onChanged => _widget.onChanged;

  _RadioWidget<T> get _widget {
    final w = widget();
    if (w is RadioListTile<T>) {
      return _RadioWidget(
        w.value,
        // ignore: deprecated_member_use
        w.groupValue,
        // ignore: deprecated_member_use
        w.onChanged,
      );
    } else if (w is Radio<T>) {
      return _RadioWidget(
        w.value,
        // ignore: deprecated_member_use
        w.groupValue,
        // ignore: deprecated_member_use
        w.onChanged,
      );
    } else {
      w as CupertinoRadio<T>;
      return _RadioWidget(
        w.value,
        // ignore: deprecated_member_use
        w.groupValue,
        // ignore: deprecated_member_use
        w.onChanged,
      );
    }
  }
}

/// Extension on [PageObjectFactory] to create [RadioPageObject]s.
extension RadioPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [RadioPageObject] with the given [key].
  RadioPageObject<T> radio<T>(K key) =>
      create((t, finder) => RadioPageObject<T>(t, finder), key);
}

class _RadioWidget<T> {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  _RadioWidget(this.value, this.groupValue, this.onChanged);
}

bool _isRadio<T>(Widget w) =>
    w is Radio<T> || w is RadioListTile<T> || w is CupertinoRadio<T>;
