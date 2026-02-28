import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  ScrollableListPageObject<TextPageObject> createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t)
          .scrollableList(aFinder, find.byType(Text), TextPageObject.new);

  group('scrollable', () {
    testWidgets('scrollDownUntilVisible --> scrolls', (t) async {
      await t.runWithViewHeight(_defaultItemHeight * 5, () async {
        await t.pumpWidget(const _Widget(itemCount: 20, itemKey: _itemKey));
        final pageObject = createPageObject(t);
        expect(pageObject.item(_itemFinder(0)), findsOne);
        expect(pageObject.item(_itemFinder(4)), findsOne);
        expect(pageObject.item(_itemFinder(5)), findsNothing);

        await pageObject
            .scrollDownUntilVisible(pageObject.item(_itemFinder(10)));

        expect(pageObject.item(_itemFinder(10)), findsOne);
      });
    });

    testWidgets('scrollUpUntilVisible --> scrolls', (t) async {
      await t.runWithViewHeight(_defaultItemHeight * 5, () async {
        await t.pumpWidget(const _Widget(itemCount: 20, itemKey: _itemKey));
        final pageObject = createPageObject(t);
        await pageObject
            .scrollDownUntilVisible(pageObject.item(_itemFinder(10)));
        expect(pageObject.item(_itemFinder(0)), findsNothing);
        expect(pageObject.item(_itemFinder(10)), findsOne);

        await pageObject.scrollUpUntilVisible(pageObject.item(_itemFinder(0)));

        expect(pageObject.item(_itemFinder(0)), findsOne);
        expect(pageObject.item(_itemFinder(10)), findsNothing);
      });
    });

    testWidgets('fling --> scrolls by a given delta', (t) async {
      await t.runWithViewHeight(_defaultItemHeight * 5, () async {
        await t.pumpWidget(const _Widget(itemCount: 20));
        final pageObject = createPageObject(t);
        expect(pageObject.item(_itemFinder(0)), findsOne);
        expect(pageObject.item(_itemFinder(4)), findsOne);
        expect(pageObject.item(_itemFinder(5)), findsNothing);

        await pageObject.fling(dy: -3 * _defaultItemHeight);

        expect(pageObject.item(_itemFinder(2)), findsNothing);
        expect(pageObject.item(_itemFinder(3)), findsOne);
      });
    });

    testWidgets('pullToRefresh --> triggers RefreshIndicator', (t) async {
      await t.runWithViewHeight(_defaultItemHeight * 5, () async {
        await t.pumpWidget(const _Widget(itemCount: 20));
        final pageObject = createPageObject(t);
        expect(_refreshProgressIndicatorFinder, findsNothing);

        await pageObject.pullToRefresh();

        expect(_refreshProgressIndicatorFinder, findsOne);
        await t.pumpAndSettle();
        expect(_refreshProgressIndicatorFinder, findsNothing);
      });
    });

    group('operator []', () {
      testWidgets('in range --> visible items by index', (t) async {
        await t.runWithViewHeight(_defaultItemHeight * 5, () async {
          await t.pumpWidget(const _Widget(itemCount: 20, itemKey: _itemKey));

          final pageObject = createPageObject(t);
          expect(pageObject[0], findsOne);
          expect(pageObject[0].text, '0');
          expect(pageObject[4], findsOne);
          expect(pageObject[4].text, '4');

          await pageObject
              .scrollDownUntilVisible(pageObject.item(_itemFinder(10)));
          await t.pumpAndSettle();
          expect(pageObject[0], findsOne);
          expect(pageObject[0].text, '10');
        });
      });

      testWidgets('out of range --> throws', (t) async {
        await t.runWithViewHeight(_defaultItemHeight * 5, () async {
          await t.pumpWidget(const _Widget(itemCount: 20, itemKey: _itemKey));
          final pageObject = createPageObject(t);
          expect(() => pageObject[5], throwsRangeError);
        });
      });
    });

    testWidgets('all --> visible items', (t) async {
      await t.runWithViewHeight(_defaultItemHeight * 5, () async {
        await t.pumpWidget(const _Widget(itemCount: 20, itemKey: _itemKey));
        final pageObject = createPageObject(t);

        final allItems = pageObject.all;

        expect(allItems, hasLength(5));
        expect(allItems[0].text, '0');
        expect(allItems[4].text, '4');
      });
    });
  });

  group('list', () {
    testWidgets('all --> all items', (t) async {
      await t.pumpWidget(const _Widget(itemCount: 3, itemText: _itemText));
      final pageObject = createPageObject(t);
      expect(pageObject.all.map((e) => e.text),
          containsAllInOrder(['0', '1', '2']));
    });

    testWidgets('count --> number of items', (t) async {
      await t.pumpWidget(const _Widget(itemCount: 3));
      final pageObject = createPageObject(t);
      expect(pageObject.count, 3);
    });

    group('operator []', () {
      testWidgets('in range --> finds', (t) async {
        await t.pumpWidget(const _Widget(itemCount: 3, itemText: _itemText));

        final pageObject = createPageObject(t);

        expect(pageObject[1], findsOne);
        expect(pageObject[1].text, '1');
      });

      testWidgets('out of range --> throws', (t) async {
        await t.pumpWidget(const _Widget(itemCount: 3));
        final pageObject = createPageObject(t);
        expect(() => pageObject[3], throwsRangeError);
      });
    });

    group('item', () {
      testWidgets('exists --> finds', (t) async {
        await t.pumpWidget(const _Widget(itemCount: 3, itemText: _itemText));
        final pageObject = createPageObject(t);
        expect(pageObject.item(find.text('1')), findsOne);
      });

      testWidgets('does not exist --> finds nothing', (t) async {
        await t.pumpWidget(const _Widget(itemCount: 3, itemText: _itemText));
        final pageObject = createPageObject(t);
        expect(pageObject.item(find.text('3')), findsNothing);
      });
    });
  });
}

const _defaultItemHeight = 100.0;

class _Widget extends StatelessWidget {
  final int itemCount;
  final Key Function(int)? itemKey;
  final String Function(int)? itemText;

  const _Widget({required this.itemCount, this.itemKey, this.itemText});

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
      height: _defaultItemHeight,
      child: Text((itemText ?? _itemText)(i), key: (itemKey ?? _itemKey)(i)),
    );
  }
}

Key _itemKey(int i) => Key('item_key_$i');
Finder _itemFinder(int i) => find.byKey(_itemKey(i));
String _itemText(int i) => '$i';
final _refreshProgressIndicatorFinder = find.byType(RefreshProgressIndicator);
