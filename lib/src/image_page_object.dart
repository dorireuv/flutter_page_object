import 'package:flutter/material.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing an [Image] widget.
class ImagePageObject extends PageObject {
  /// Creates a [ImagePageObject] with the given [finder].
  ImagePageObject(super.t, super.finder);

  /// Gets the [ImageProvider] of the image.
  ImageProvider? get image => _widget.image;

  /// Gets the semantic label of the image.
  String? get semanticLabel => _widget.semanticLabel;

  Image get _widget => widget<Image>();
}

/// Extension on [PageObjectFactory] to create [ImagePageObject]s.
extension ImagePageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [ImagePageObject] with the given [key].
  ImagePageObject image(K key) => create(ImagePageObject.new, key);
}
