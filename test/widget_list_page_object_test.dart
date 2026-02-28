import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  WidgetListPageObject<TextPageObject> createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t)
          .widgetList(aFinder, find.byType(Text), TextPageObject.new);

  testWidgets('all --> all items', (t) async {
    await t.pumpWidget(const _Widget(items: ['0', '1', '2']));
    final pageObject = createPageObject(t);
    expect(
        pageObject.all.map((e) => e.text), containsAllInOrder(['0', '1', '2']));
  });

  testWidgets('count --> number of items', (t) async {
    await t.pumpWidget(const _Widget(items: ['0', '1', '2']));
    final pageObject = createPageObject(t);
    expect(pageObject.count, 3);
  });

  group('operator []', () {
    testWidgets('in range --> finds', (t) async {
      await t.pumpWidget(const _Widget(items: ['0', '1', '2']));

      final pageObject = createPageObject(t);

      expect(pageObject[1], findsOne);
      expect(pageObject[1].text, '1');
    });

    testWidgets('out of range --> throws', (t) async {
      await t.pumpWidget(const _Widget(items: ['0', '1', '2']));
      final pageObject = createPageObject(t);
      expect(() => pageObject[3], throwsRangeError);
    });
  });

  group('item', () {
    testWidgets('exists --> finds', (t) async {
      await t.pumpWidget(const _Widget(items: ['0', '1', '2']));
      final pageObject = createPageObject(t);
      expect(pageObject.item(find.text('1')), findsOne);
    });

    testWidgets('does not exist --> finds nothing', (t) async {
      await t.pumpWidget(const _Widget(items: ['0', '1', '2']));
      final pageObject = createPageObject(t);
      expect(pageObject.item(find.text('3')), findsNothing);
    });
  });
}

class _Widget extends StatelessWidget {
  final List<String> items;

  const _Widget({required this.items});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      key: aKey,
      child: Column(
        children: items.map((item) => Text(item)).toList(),
      ),
    );
  }
}
