import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  ScrollablePageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).scrollable(aFinder);

  testWidgets('nested scrollables --> scrolls the first', (t) async {
    await t.pumpWidget(const _NestedScrollables(itemCount: 20));
    final pageObject = createPageObject(t);

    await pageObject.scrollDownUntilVisible(_itemFinder(10));

    expect(_itemFinder(10), findsOne);
  });

  testWidgets('scrollDownUntilVisible --> scrolls', (t) async {
    await t.runWithViewHeight(_kDefaultItemHeight * 6, () async {
      await t.pumpWidget(const _Widget(itemCount: 20));
      final pageObject = createPageObject(t);
      expect(_itemFinder(0), findsOne);
      expect(_itemFinder(5), findsOne);
      expect(_itemFinder(6), findsNothing);

      await pageObject.scrollDownUntilVisible(_itemFinder(10));

      expect(_itemFinder(10), findsOne);
    });
  });

  testWidgets('scrollUpUntilVisible --> scrolls', (t) async {
    await t.runWithViewHeight(_kDefaultItemHeight * 6, () async {
      await t.pumpWidget(const _Widget(itemCount: 20));
      final pageObject = createPageObject(t);
      await pageObject.scrollDownUntilVisible(_itemFinder(10));
      expect(_itemFinder(0), findsNothing);
      expect(_itemFinder(10), findsOne);

      await pageObject.scrollUpUntilVisible(_itemFinder(0));

      expect(_itemFinder(0), findsOne);
      expect(_itemFinder(10), findsNothing);
    });
  });

  testWidgets('fling --> scrolls by a given delta', (t) async {
    await t.runWithViewHeight(_kDefaultItemHeight * 6, () async {
      await t.pumpWidget(const _Widget(itemCount: 20));
      final pageObject = createPageObject(t);
      expect(_itemFinder(0), findsOne);
      expect(_itemFinder(5), findsOne);
      expect(_itemFinder(6), findsNothing);

      await pageObject.fling(dy: -300.0);

      expect(_itemFinder(0), findsNothing);
      expect(_itemFinder(6), findsOne);
    });
  });

  testWidgets('pullToRefresh --> triggers RefreshIndicator', (t) async {
    await t.runWithViewHeight(_kDefaultItemHeight * 6, () async {
      await t.pumpWidget(const _Widget(itemCount: 20));
      final pageObject = createPageObject(t);
      expect(_refreshProgressIndicatorFinder, findsNothing);

      await pageObject.pullToRefresh();

      expect(_refreshProgressIndicatorFinder, findsOne);
      await t.pumpAndSettle();
      expect(_refreshProgressIndicatorFinder, findsNothing);
    });
  });
}

const _kDefaultItemHeight = 100.0;

class _Widget extends StatelessWidget {
  final int itemCount;

  const _Widget({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: RefreshIndicator(
        onRefresh: () => Future.delayed(const Duration(milliseconds: 100)),
        child: ListView.builder(
          key: aKey,
          itemCount: itemCount,
          itemBuilder: (_, i) => _item(i),
        ),
      ),
    );
  }

  Widget _item(int i) {
    return SizedBox(
      height: _kDefaultItemHeight,
      child: Text('$i', key: _itemKey(i)),
    );
  }
}

class _NestedScrollables extends StatelessWidget {
  final int itemCount;

  const _NestedScrollables({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: ListView.builder(
        key: aKey,
        itemCount: itemCount,
        itemBuilder: (_, i) => _item(i),
      ),
    );
  }

  Widget _item(int i) {
    return SizedBox(
      height: _kDefaultItemHeight,
      child: SingleChildScrollView(
        child: Text('$i', key: _itemKey(i)),
      ),
    );
  }
}

Key _itemKey(int i) => Key('item_key_$i');
Finder _itemFinder(int i) => find.byKey(_itemKey(i));
final _refreshProgressIndicatorFinder = find.byType(RefreshProgressIndicator);
