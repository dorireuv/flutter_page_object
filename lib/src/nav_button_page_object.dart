import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

/// A page object representing a button that navigates to another page object
/// when tapped.
class NavButtonPageObject<T extends PageObject> extends ButtonPageObject {
  /// Creates a [NavButtonPageObject] with the given [finder] and
  /// [targetBuilder].
  static PageObjectBuilder<NavButtonPageObject<T>>
      builder<T extends PageObject>(
              {required PageObjectStaticBuilder<T> targetBuilder}) =>
          (t, finder) =>
              NavButtonPageObject(t, finder, targetBuilder: targetBuilder);

  final PageObjectStaticBuilder<T> _targetBuilder;
  late final _nav = r.nav(this, targetBuilder: _targetBuilder);

  /// Creates a [NavButtonPageObject] with the given [finder] and
  /// [_targetBuilder].
  NavButtonPageObject(super.t, super.finder,
      {required PageObjectStaticBuilder<T> targetBuilder})
      : _targetBuilder = targetBuilder;

  /// Taps the button and waits for the target page object to be found.
  Future<T> tapNav({bool expectTarget = true}) =>
      _nav.tapNav(expectTarget: expectTarget);

  /// Taps the button, pumps once, and waits for the target page object to be
  /// found.
  Future<T> tapNavAndPump({bool expectTarget = true}) =>
      _nav.tapNavAndPump(expectTarget: expectTarget);

  /// Taps the button, pumps until settled, and waits for the target page
  /// object to be found.
  Future<T> tapNavAndSettle({bool expectTarget = true}) =>
      _nav.tapNavAndSettle(expectTarget: expectTarget);
}

/// Extension on [PageObjectFactory] to create [NavButtonPageObject]s.
extension NavButtonPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [NavButtonPageObject] with the given [key] and [targetBuilder].
  NavButtonPageObject<T> navButton<T extends PageObject>(K key,
          {required PageObjectStaticBuilder<T> targetBuilder}) =>
      create(NavButtonPageObject.builder<T>(targetBuilder: targetBuilder), key);
}
