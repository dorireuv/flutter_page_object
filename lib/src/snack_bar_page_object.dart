import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';
import 'widget_page_object.dart';

/// A page object representing a [SnackBar] widget.
class SnackBarPageObject extends PageObject {
  /// The action button of the [SnackBar].
  late final actionButton = d.byType.widget(SnackBarAction);

  /// Creates a [SnackBarPageObject] with the given [finder].
  SnackBarPageObject(super.t, super.finder);

  /// Dismisses the snack bar.
  Future<void> dismiss() async {
    final state = t.state<ScaffoldMessengerState>(
        find.ancestor(of: this, matching: find.byType(ScaffoldMessenger)));
    state.hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
    await t.pumpAndSettle();
  }
}

/// Extension on [PageObjectFactory] to create [SnackBarPageObject]s.
extension SnackBarPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [SnackBarPageObject] with the given [key].
  SnackBarPageObject snackBar(K key) => create(SnackBarPageObject.new, key);
}
