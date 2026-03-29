import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_builder.dart';
import 'page_object_factory.dart';

/// A page object representing a widget that navigates to another page object
/// when tapped.
class NavPageObject<T extends PageObject> extends PageObject {
  /// Creates a [NavPageObject] builder for the given [targetBuilder].
  static PageObjectBuilder<NavPageObject<T>> builder<T extends PageObject>(
          {required PageObjectStaticBuilder<T> targetBuilder}) =>
      (t, finder) => NavPageObject(t, finder, targetBuilder: targetBuilder);

  final PageObjectStaticBuilder<T> _targetBuilder;
  late final _target = _targetBuilder(t);

  /// Creates a [NavPageObject] with the given [finder] and [_targetBuilder].
  NavPageObject(super.t, super.finder,
      {required PageObjectStaticBuilder<T> targetBuilder})
      : _targetBuilder = targetBuilder;

  /// Taps and waits for the target page object to be found.
  Future<T> tapNav({bool expectTarget = true}) async {
    await tap();
    if (expectTarget) {
      expect(_target, findsAny);
    }
    return _target;
  }

  /// Taps, pumps once, and waits for the target page object to be found.
  Future<T> tapNavAndPump({bool expectTarget = true}) async {
    await tapAndPump();
    if (expectTarget) {
      expect(_target, findsAny);
    }
    return _target;
  }

  /// Taps, pumps until settled, and waits for the target page object to be found.
  Future<T> tapNavAndSettle({bool expectTarget = true}) async {
    await tapAndSettle();
    if (expectTarget) {
      expect(_target, findsAny);
    }
    return _target;
  }
}

/// Extension on [PageObjectFactory] to create [NavPageObject]s.
extension NavPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [NavPageObject] with the given [key] and [targetBuilder].
  NavPageObject<T> nav<T extends PageObject>(K key,
          {required PageObjectStaticBuilder<T> targetBuilder}) =>
      create(NavPageObject.builder<T>(targetBuilder: targetBuilder), key);
}
