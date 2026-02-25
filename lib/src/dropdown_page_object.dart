import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'check.dart';
import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [DropdownButton] / [DropdownButtonFormField]
/// widget.
class DropdownPageObject<T> extends PageObject {
  /// Creates a [DropdownPageObject] with the given [finder].
  DropdownPageObject(super.t, super.finder);

  /// Returns true if the dropdown is disabled.
  bool get isDisabled {
    final widget = _dropdownButtonWidget;
    return widget.onChanged == null ||
        widget.items == null ||
        widget.items!.isEmpty;
  }

  /// Returns true if the dropdown is enabled.
  bool get isEnabled => !isDisabled;

  /// Gets the currently selected value in the dropdown, or `null` if no value
  /// is selected.
  T? get value => _dropdownButtonWidget.value;

  /// Selects the given value in the dropdown.
  Future<void> select(T? v) async {
    checkState(isEnabled);
    if (value == v) {
      return;
    }

    await open();
    await _selectItem(v);
  }

  /// Gets the list of all values in the dropdown.
  Future<List<T?>> values() async {
    if (isDisabled) {
      return [];
    }

    await open();
    final dropdownValues = _values();
    await close();

    return dropdownValues;
  }

  /// Returns true if the dropdown menu is currently open.
  bool get isOpen => isEnabled && _popupMenuItemsFinder.evaluate().isNotEmpty;

  /// Opens the dropdown menu if it's not already open.
  Future<void> open() async {
    checkState(isEnabled);
    if (isOpen) {
      return;
    }

    await tapAndPump();
    expect(isOpen, isTrue);
  }

  /// Closes the dropdown menu if it's open by tapping outside of it.
  Future<void> close() async {
    checkState(isEnabled);
    if (!isOpen) {
      return;
    }

    final tapLocation = _findTapLocationOutsideThePopupMenu();
    await t.tapAt(tapLocation);
    await t.pump();
    expect(isOpen, isFalse);
  }

  Future<void> _selectItem(T? v) async {
    await t.tap(_popupMenuItemWithValue(v), warnIfMissed: false);
    await t.pump();
    await t.pump();
  }

  List<T?> _values() => _items().map((e) => e.value).toList();

  Iterable<DropdownMenuItem<T>> _items() => t.widgetList(_popupMenuItemsFinder);

  Finder _popupMenuItemWithValue(T? v) => find.descendant(
      of: _popupMenuFinder,
      matching: find
          .byWidgetPredicate((w) => w is DropdownMenuItem<T> && w.value == v));

  Finder get _popupMenuItemsFinder =>
      find.descendant(of: _popupMenuFinder, matching: _itemsFinder);

  Finder get _popupMenuFinder => find.byWidgetPredicate(
      (w) => w is Material && w.type == MaterialType.transparency);

  Finder get _itemsFinder =>
      find.byWidgetPredicate((w) => w is DropdownMenuItem<T>);

  DropdownButton<T> get _dropdownButtonWidget => t.widget<DropdownButton<T>>(
        find.descendant(
          of: this,
          matching: find.byWidgetPredicate((w) => w is DropdownButton<T>),
          matchRoot: true,
        ),
      );

  Offset _findTapLocationOutsideThePopupMenu() {
    final menuFinder = find.ancestor(
      of: _popupMenuItemsFinder.first,
      matching: _popupMenuFinder,
    );

    final menuBox = t.renderObject(menuFinder) as RenderBox;
    final menuRect = menuBox.localToGlobal(Offset.zero) & menuBox.size;

    final screenSize = t.view.physicalSize / t.view.devicePixelRatio;

    // Try screen corners.
    final candidates = [
      Offset.zero,
      Offset(screenSize.width - 1, 0),
      Offset(0, screenSize.height - 1),
      Offset(screenSize.width - 1, screenSize.height - 1),
    ];

    return candidates.firstWhere(
      (offset) => !menuRect.contains(offset),
      orElse: () => throw TestFailure(
          'Could not find a tap location outside the dropdown menu'),
    );
  }
}

/// Extension on [PageObjectFactory] to create [DropdownPageObject]s.
extension DropdownPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [DropdownPageObject] with the given [key].
  DropdownPageObject<T> dropdown<T>(K key) =>
      create(DropdownPageObject.new, key);
}
