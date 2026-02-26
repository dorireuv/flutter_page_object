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
  final Finder finder;

  /// Creates a [PageObject].
  PageObject(this.t, this.finder);

  @override
  // ignore: deprecated_member_use
  String get description => finder.description;

  @override
  Iterable<Element> get allCandidates => finder.allCandidates;

  @override
  Iterable<Element> findInCandidates(Iterable<Element> candidates) =>
      finder.findInCandidates(candidates);

  /// Accesses page objects starting from the root of the widget tree.
  late final root = PageObjectFactory.root(t);

  /// Accesses page objects which are descendants of this page object.
  late final descendantOf = PageObjectFactory.descendantOf(t, this);

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

  /// Waits until the page object is shown on the screen.
  ///
  /// Throws if it is not shown after the given [timeout].
  Future<void> waitUntilShown({Duration timeout = _defaultTimeout}) {
    final hitTestableFinder = hitTestable();
    return _wait(
      () => hitTestableFinder.evaluate().isEmpty,
      'Timed out waiting until $this is shown',
      timeout,
    );
  }

  /// Waits while the page object is shown on the screen.
  ///
  /// Throws if it is still shown after the given [timeout].
  Future<void> waitWhileShown({Duration timeout = _defaultTimeout}) {
    final hitTestableFinder = hitTestable();
    return _wait(
      () => hitTestableFinder.evaluate().isNotEmpty,
      'Timed out waiting while $this is shown',
      timeout,
    );
  }

  /// Gets the widget represented by this page object.
  T widget<T extends Widget>() {
    return t.widget<T>(this);
  }

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
  PageObjectFactory<Finder> get d => descendantOf;
}
