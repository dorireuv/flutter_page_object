import 'package:flutter/material.dart';
import 'package:flutter_page_object/src/finder_utils.dart';
import 'package:flutter_test/flutter_test.dart';

import 'check.dart';
import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [Slider] widget.
class SliderPageObject extends PageObject {
  /// Creates a [SliderPageObject] with the given [finder].
  SliderPageObject(WidgetTester t, Finder finder)
      : super(t, finder.firstDescendantWidgetMatching((w) => w is Slider));

  /// The current value of the slider.
  double get value => _widget.value;

  /// The minimum value the slider can hold.
  double get min => _widget.min;

  /// The maximum value the slider can hold.
  double get max => _widget.max;

  /// The number of discrete divisions.
  int? get divisions => _widget.divisions;

  /// Whether the slider is enabled.
  bool get isEnabled => _widget.onChanged != null;

  /// Whether the slider is disabled.
  bool get isDisabled => !isEnabled;

  @override
  Future<void> drag(Offset offset, {bool warnIfMissed = true}) async {
    checkState(isEnabled);
    await super.drag(offset, warnIfMissed: warnIfMissed);
  }

  Slider get _widget => widget<Slider>();
}

/// Extension on [PageObjectFactory] to create [SliderPageObject]s.
extension SliderPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [SliderPageObject] with the given [key].
  SliderPageObject slider(K key) => create(SliderPageObject.new, key);
}
