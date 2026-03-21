import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// More finders.
extension MoreFinders on Finder {
  /// Gets the widget represented by this page object.
  Finder takeOne() => _TakeOneFinder(this);

  /// Gets the first descendant widget matching the given [predicate].
  Finder firstDescendantWidgetMatching(WidgetPredicate predicate) => find
      .descendant(
          of: this,
          matching: find.byWidgetPredicate(predicate),
          matchRoot: true)
      .takeOne();
}

class _TakeOneFinder extends Finder {
  final Finder parent;

  _TakeOneFinder(this.parent);

  @override
  // ignore: deprecated_member_use
  String get description => parent.description;

  @override
  Iterable<Element> get allCandidates => parent.allCandidates;

  @override
  Iterable<Element> findInCandidates(Iterable<Element> candidates) =>
      parent.findInCandidates(candidates).take(1);
}
