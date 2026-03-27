import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object_factory.dart';

const _defaultTimeout = Duration(seconds: 10);

/// Base class for page objects. It extends [Finder] so that it can be used
/// seamlessly in expect statements and other places where a [Finder] is
/// expected.
abstract class PageObject extends Finder {
  /// The [WidgetTester] used to interact.
  final WidgetTester t;

  /// Finder that locates the widget(s) represented by this page object.
  final Finder _finder;

  /// Creates a [PageObject].
  PageObject(this.t, this._finder);

  @override
  // ignore: deprecated_member_use
  String get description => _finder.description;

  @override
  Iterable<Element> get allCandidates => _finder.allCandidates;

  @override
  Iterable<Element> findInCandidates(Iterable<Element> candidates) =>
      _finder.findInCandidates(candidates);

  /// Accesses page objects starting from the root of the widget tree.
  late final root = PageObjectFactory.root(t);

  /// Accesses page objects which are descendants of this page object.
  late final descendant = PageObjectFactory.descendant(t, this);

  /// Whether the widget represented by this page object is currently visible
  /// and can be interacted with.
  bool get isHitTestable => hitTestable().evaluate().isNotEmpty;

  /// Taps the page object.
  Future<void> tap({bool warnIfMissed = true}) =>
      t.tap(this, warnIfMissed: warnIfMissed);

  /// Taps the page object and pumps the widget tree.
  Future<void> tapAndPump({bool warnIfMissed = true}) async {
    await tap(warnIfMissed: warnIfMissed);
    await t.pump();
  }

  /// Taps the page object and pumps the widget tree until it settles.
  Future<void> tapAndSettle({bool warnIfMissed = true}) async {
    await tap(warnIfMissed: warnIfMissed);
    await t.pumpAndSettle();
  }

  /// Long presses the page object.
  Future<void> longPress({bool warnIfMissed = true}) =>
      t.longPress(this, warnIfMissed: warnIfMissed);

  /// Long presses the page object and pumps the widget tree.
  Future<void> longPressAndPump({bool warnIfMissed = true}) async {
    await longPress(warnIfMissed: warnIfMissed);
    await t.pump();
  }

  /// Long presses the page object and pumps the widget tree until it settles.
  Future<void> longPressAndSettle({bool warnIfMissed = true}) async {
    await longPress(warnIfMissed: warnIfMissed);
    await t.pumpAndSettle();
  }

  /// Drags the page object by the given offset.
  Future<void> drag(Offset offset, {bool warnIfMissed = true}) =>
      t.drag(this, offset, warnIfMissed: warnIfMissed);

  /// Drags the page object by the given offset and pumps the widget tree.
  Future<void> dragAndPump(Offset offset, {bool warnIfMissed = true}) async {
    await drag(offset, warnIfMissed: warnIfMissed);
    await t.pump();
  }

  /// Waits until the page object is hit-testable on the screen.
  ///
  /// Throws if it is not hit-testable after the given [timeout].
  Future<void> waitUntilHitTestable({Duration timeout = _defaultTimeout}) {
    return _wait(
      () => !isHitTestable,
      'Timed out waiting until $this is hit-testable',
      timeout,
    );
  }

  /// Waits while the page object is hit-testable on the screen.
  ///
  /// Throws if it is still hit-testable after the given [timeout].
  Future<void> waitWhileHitTestable({Duration timeout = _defaultTimeout}) {
    return _wait(
      () => isHitTestable,
      'Timed out waiting while $this is hit-testable',
      timeout,
    );
  }

  /// Gets the widget represented by this page object.
  T widget<T extends Widget>() => t.widget<T>(this);

  /// Gets the widget state represented by this page object.
  T state<T extends State>() => t.state<T>(this);

  Future<void> _wait(bool Function() condition, String timeoutMessage,
      Duration timeout) async {
    var elapsed = Duration.zero;
    const step = Duration(milliseconds: 100);
    while (condition()) {
      if (elapsed >= timeout) {
        throw TestFailure(timeoutMessage);
      }

      await t.pump(step);
      elapsed += step;
    }
  }
}

/// Shorthand extension for page objects.
extension PageObjectFactoryShorthandExtension on PageObject {
  /// Shorthand for accessing page objects starting from the root of the widget
  /// tree.
  PageObjectFactory<Finder> get r => root;

  /// Shorthand for accessing page objects which are descendants of this page
  /// object.
  PageObjectFactory<Finder> get d => descendant;
}
