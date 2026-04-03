import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';
import 'widget_page_object.dart';

/// A page object representing a [Drawer] widget.
class DrawerPageObject extends PageObject {
  late final _openButton = r.byIcon.widget(Icons.menu);

  /// Creates a [DrawerPageObject] with the given [finder].
  DrawerPageObject.custom(super.t, super.finder);

  /// A default constructor for [DrawerPageObject].
  DrawerPageObject(WidgetTester t) : super(t, find.byType(Drawer));

  /// Returns true if the drawer is open.
  bool get isOpen => hitTestable().evaluate().isNotEmpty;

  /// Opens the drawer.
  Future<void> open() async {
    if (isOpen) {
      return;
    }

    await _openButton.tapAndSettle();
  }

  /// Closes the drawer.
  Future<void> close() async {
    if (!isOpen) {
      return;
    }

    final tapLocation = _findTapLocationOutsideTheDrawer();
    await t.tapAt(tapLocation);
    await t.pumpAndSettle();
  }

  Offset _findTapLocationOutsideTheDrawer() {
    final drawerRect = t.getRect(this);
    final screenSize = t.view.physicalSize / t.view.devicePixelRatio;

    final candidates = [
      Offset(screenSize.width - 1, screenSize.height / 2),
      Offset(1, screenSize.height / 2),
    ];

    return candidates.firstWhere(
      (offset) => !drawerRect.contains(offset),
      orElse: () =>
          throw TestFailure('Could not find a tap location outside the drawer'),
    );
  }
}

/// A mixin for page objects that have a drawer.
mixin HasDrawer on PageObject {
  /// Gets the drawer.
  DrawerPageObject get drawer => r.drawer();
}

/// Extension on [PageObjectFactory] to create [DrawerPageObject]s.
extension DrawerPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [DrawerPageObject] with the given [key].
  DrawerPageObject drawer([K? key]) {
    return key == null
        ? createStatic(DrawerPageObject.new)
        : create(DrawerPageObject.custom, key);
  }
}
