import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';
import 'page_object_factory.dart';

const _defaultDelta = 50.0;
const _defaultMaxScrolls = 50;

/// A page object representing a scrollable widget, such as a [ListView] or
/// a [SingleChildScrollView].
class ScrollablePageObject extends PageObject with IsScrollable {
  /// Creates a [ScrollablePageObject] with the given [finder].
  ScrollablePageObject(super.t, super.finder);
}

/// Extension on [PageObjectFactory] to create [ScrollablePageObject]s.
extension ScrollablePageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [ScrollablePageObject] with the given [key].
  ScrollablePageObject scrollable(K key) =>
      create(ScrollablePageObject.new, key);
}

/// A mixin for page objects that are scrollable widget.
mixin IsScrollable on PageObject {
  /// Scrolls up until the given [itemFinder] is visible, or until the maximum
  /// number of scrolls is reached.
  Future<void> scrollUpUntilVisible(
    Finder itemFinder, {
    double delta = _defaultDelta,
    int maxScrolls = _defaultMaxScrolls,
  }) async {
    assert(delta > 0.0);
    await _scrollUntilVisible(itemFinder,
        delta: -delta, maxScrolls: maxScrolls);
  }

  /// Scrolls down until the given [itemFinder] is visible, or until the maximum
  /// number of scrolls is reached.
  Future<void> scrollDownUntilVisible(
    Finder itemFinder, {
    double delta = _defaultDelta,
    int maxScrolls = _defaultMaxScrolls,
  }) async {
    assert(delta > 0.0);
    await _scrollUntilVisible(itemFinder, delta: delta, maxScrolls: maxScrolls);
  }

  Future<void> _scrollUntilVisible(
    Finder itemFinder, {
    required double delta,
    required int maxScrolls,
  }) async {
    await t.scrollUntilVisible(itemFinder, delta,
        maxScrolls: maxScrolls, scrollable: _scrollable);
    await t.pump();
  }

  /// Flings the scrollable in the given direction with the given speed, and
  /// waits until the fling animation is complete.
  Future<void> fling(
      {double dx = 0.0, double dy = 0.0, double speed = 1000.0}) async {
    await t.fling(_scrollable, Offset(dx, dy), speed);
    await t.pump();
  }

  /// Pulls to refresh by flinging down with a default speed and distance.
  Future<void> pullToRefresh() async {
    await fling(dy: 300.0);
  }

  Finder get _scrollable => find
      .descendant(of: this, matching: find.byType(Scrollable), matchRoot: true)
      .first;
}
