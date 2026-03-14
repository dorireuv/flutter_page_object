import 'package:flutter_test/flutter_test.dart';

import 'button_page_object.dart';
import 'page_object.dart';
import 'page_object_builder.dart';
import 'page_object_factory.dart';

/// A page object representing a button that navigates to another page object
/// when tapped.
class NavButtonPageObject<T extends PageObject> extends ButtonPageObject {
  /// Creates a [NavButtonPageObject] with the given [finder] and
  /// [target].
  static PageObjectBuilder<NavButtonPageObject<T>>
      builder<T extends PageObject>(PageObjectStaticBuilder<T> targetBuilder) =>
          (t, finder) => NavButtonPageObject(t, finder, targetBuilder);

  final PageObjectStaticBuilder<T> _targetBuilder;
  late final _target = _targetBuilder(t);

  /// Creates a [NavButtonPageObject] with the given [finder] and
  /// [_targetBuilder].
  NavButtonPageObject(super.t, super.finder, this._targetBuilder);

  /// Taps the button and waits for the target page object to be found.
  Future<T> tapNav({bool expectTarget = true}) async {
    await tap();
    if (expectTarget) {
      expect(_target, findsAny);
    }
    return _target;
  }

  /// Taps the button, pumps once, and waits for the target page object to be
  /// found.
  Future<T> tapNavAndPump({bool expectTarget = true}) async {
    await tapAndPump();
    if (expectTarget) {
      expect(_target, findsAny);
    }
    return _target;
  }

  /// Taps the button, pumps until settled, and waits for the target page
  /// object to be found.
  Future<T> tapNavAndSettle({bool expectTarget = true}) async {
    await tapAndSettle();
    if (expectTarget) {
      expect(_target, findsAny);
    }
    return _target;
  }
}

/// Extension on [PageObjectFactory] to create [NavButtonPageObject]s.
extension NavButtonPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [NavButtonPageObject] with the given [key] and [target].
  NavButtonPageObject<T> navButton<T extends PageObject>(
          K key, PageObjectStaticBuilder<T> targetBuilder) =>
      create(NavButtonPageObject.builder<T>(targetBuilder), key);
}
