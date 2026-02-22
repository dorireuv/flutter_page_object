import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

/// A page object representing a button that navigates to another page object
/// when tapped.
class NavButtonPageObject<T extends PageObject> extends ButtonPageObject {
  /// Creates a [NavButtonPageObject] with the given [finder] and
  /// [target].
  static PageObjectBuilder<NavButtonPageObject<T>>
      builder<T extends PageObject>(T target) =>
          (t, finder) => NavButtonPageObject(t, finder, target);

  final T _target;

  /// Creates a [NavButtonPageObject] with the given [finder] and
  /// [_target].
  NavButtonPageObject(super.t, super.finder, this._target);

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
  NavButtonPageObject<T> navButton<T extends PageObject>(K key, T target) =>
      create(NavButtonPageObject.builder<T>(target), key);
}
