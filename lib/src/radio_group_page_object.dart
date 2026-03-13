import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';
import 'radio_page_object.dart';

/// A page object representing a group of [Radio] widgets.
class RadioGroupPageObject<T> extends PageObject {
  /// Creates a [RadioGroupPageObject] with the given [finder].
  RadioGroupPageObject(super.t, super.finder);

  /// Returns true if the radio button with the given [value] is selected.
  bool isSelected(T value) => _radioPageObjectForValue(value).isSelected;

  /// Returns the group value.
  T? get groupValue =>
      _radioPageObjects.where((r) => r.isSelected).firstOrNull?.value;

  /// Selects the radio button with the given [value].
  Future<void> select(T value) => _radioPageObjectForValue(value).select();

  RadioPageObject<T> _radioPageObjectForValue(T value) =>
      _radioPageObjects.where((r) => r.value == value).first;

  List<RadioPageObject<T>> get _radioPageObjects => List.generate(
      _radioFinder.evaluate().length,
      (i) => RadioPageObject<T>(t, _radioFinder.at(i)));

  Finder get _radioFinder =>
      find.descendant(of: this, matching: find.byWidgetPredicate(_isRadio));

  bool _isRadio(Widget w) =>
      w is Radio<T> || w is RadioListTile<T> || w is CupertinoRadio<T>;
}

/// Extension on [PageObjectFactory] to create [RadioGroupPageObject]s.
extension RadioGroupPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [RadioGroupPageObject] with the given [key].
  RadioGroupPageObject<T> radioGroup<T>(K key) => create(
        (t, finder) => RadioGroupPageObject<T>(t, finder),
        key,
      );
}
