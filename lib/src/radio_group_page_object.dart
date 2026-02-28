import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

/// A page object representing a group of [Radio] widgets.
class RadioGroupPageObject<T> extends PageObject {
  /// Creates a [RadioGroupPageObject] with the given [finder].
  RadioGroupPageObject(super.t, super.finder);

  /// Returns true if the radio button with the given [value] is selected.
  bool isSelected(T value) {
    final radio = _radioPageObjectForValue(value);
    return radio.value == radio.groupValue;
  }

  /// Returns the group value.
  T? get groupValue {
    final count = _radioFinder.evaluate().length;
    for (var i = 0; i < count; i++) {
      final radio = _radioPageObject(_radioFinder.at(i));
      if (radio.isSelected) {
        return radio.value;
      }
    }

    return null;
  }

  /// Selects the radio button with the given [value].
  Future<void> select(T value) => _radioPageObjectForValue(value).select();

  RadioPageObject<T> _radioPageObjectForValue(T value) =>
      _radioPageObject(_radioFinderForValue(value));

  RadioPageObject<T> _radioPageObject(Finder finder) =>
      RadioPageObject<T>(t, finder);

  Finder get _radioFinder => find.descendant(
        of: this,
        matching: find.byWidgetPredicate(
            (widget) => widget is Radio<T> || widget is RadioListTile<T>),
        matchRoot: true,
      );

  Finder _radioFinderForValue(T value) => find
      .descendant(
        of: this,
        matching: find.byWidgetPredicate(
          (widget) =>
              (widget is Radio<T> && widget.value == value) ||
              (widget is RadioListTile<T> && widget.value == value),
        ),
      )
      .first;
}

/// Extension on [PageObjectFactory] to create [RadioGroupPageObject]s.
extension RadioGroupPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [RadioGroupPageObject] with the given [key].
  RadioGroupPageObject<T> radioGroup<T>(K key) => create(
        (t, finder) => RadioGroupPageObject<T>(t, finder),
        key,
      );
}
