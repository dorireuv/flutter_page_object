import 'package:flutter/material.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a [ProgressIndicator] widget.
class ProgressIndicatorPageObject extends PageObject {
  /// Creates a [ProgressIndicatorPageObject] with the given [finder].
  ProgressIndicatorPageObject(super.t, super.finder);

  /// The value of the progress indicator.
  ///
  /// Returns `null` if the progress indicator is indeterminate.
  double? get value => _widget.value;

  ProgressIndicator get _widget => widget<ProgressIndicator>();
}

/// Extension on [PageObjectFactory] to create [ProgressIndicatorPageObject]s.
extension ProgressIndicatorPageObjectFactoryExtension<K>
    on PageObjectFactory<K> {
  /// Creates a [ProgressIndicatorPageObject] with the given [key].
  ProgressIndicatorPageObject progressIndicator(K key) =>
      create(ProgressIndicatorPageObject.new, key);
}
