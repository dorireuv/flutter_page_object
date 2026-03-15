import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'check.dart';
import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Chip] widget and its variants ([ChoiceChip],
/// [FilterChip], [InputChip], [ActionChip], [RawChip]).
class ChipPageObject extends PageObject {
  /// Creates a [ChipPageObject] with the given [finder].
  ChipPageObject(super.t, super.finder);

  /// Whether the chip is selected.
  bool get isSelected => _chipWidget.selected;

  /// Whether the chip is enabled.
  bool get isEnabled => _chipWidget.isEnabled;

  /// Whether the chip is disabled.
  bool get isDisabled => !isEnabled;

  /// Selects the chip.
  Future<void> select() => set(true);

  /// Deselects the chip.
  Future<void> deselect() => set(false);

  /// Sets the chip to the given value.
  Future<void> set(bool selected) async {
    checkState(isEnabled);

    while (isSelected != selected) {
      await tapAndPump();
    }
  }

  _ChipWidget get _chipWidget {
    final w = widget<Widget>();
    if (w is ChoiceChip) {
      return _ChipWidget(selected: w.selected, isEnabled: w.onSelected != null);
    } else if (w is FilterChip) {
      return _ChipWidget(selected: w.selected, isEnabled: w.onSelected != null);
    } else if (w is InputChip) {
      return _ChipWidget(selected: w.selected, isEnabled: w.isEnabled);
    } else if (w is RawChip) {
      return _ChipWidget(selected: w.selected, isEnabled: w.isEnabled);
    }

    throw TestFailure(
        '$runtimeType does not support widget of type "${w.runtimeType}".');
  }
}

/// Extension on [PageObjectFactory] to create [ChipPageObject]s.
extension ChipPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [ChipPageObject] with the given [key].
  ChipPageObject chip(K key) => create(ChipPageObject.new, key);
}

class _ChipWidget {
  final bool selected;
  final bool isEnabled;

  _ChipWidget({required this.selected, required this.isEnabled});
}
