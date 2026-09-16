import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a slidable widget, such as [Dismissible] or
/// [Slidable].
class SlidablePageObject extends PageObject with IsSlidable {
  /// Creates a [SlidablePageObject] with the given [finder].
  SlidablePageObject(super.t, super.finder);
}

/// A mixin for page objects that are slidable.
mixin IsSlidable on PageObject {
  /// Swipes the slidable to the start.
  /// In a PageView it will always move to the next page.
  Future<void> swipeToStart({double? dx}) async {
    assert(dx == null || dx > 0);
    await _swipeHorizontally(toStart: true, dx: dx);
  }

  /// Swipes the slidable to the end.
  /// In a PageView it will always move to the previous page.
  Future<void> swipeToEnd({double? dx}) async {
    assert(dx == null || dx > 0);
    await _swipeHorizontally(toStart: false, dx: dx);
  }

  Future<void> _swipeHorizontally({required bool toStart, double? dx}) async {
    dx ??= t.getRect(this).width;
    final dxWithDirection = dx * (toStart ? -1 : 1);

    await t.drag(this, Offset(dxWithDirection, 0), warnIfMissed: false);
    await t.pumpAndSettle();
  }
}

/// Extension on [PageObjectFactory] to create [SlidablePageObject]s.
extension SlidablePageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [SlidablePageObject] with the given [key].
  SlidablePageObject slidable(K key) => create(SlidablePageObject.new, key);
}
