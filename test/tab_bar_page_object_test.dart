import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  TabBarPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).tabBar(aFinder);

  group('select', () {
    testWidgets('not selected --> selected', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 1));
      final pageObject = createPageObject(t);

      await pageObject.select(2);

      expect(pageObject.selectedIndex, 2);
    });

    testWidgets('selected --> selected', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 1));
      final pageObject = createPageObject(t);

      await pageObject.select(1);

      expect(pageObject.selectedIndex, 1);
    });
  });

  group('selectedIndex', () {
    testWidgets('after init --> initialIndex', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 1));
      final pageObject = createPageObject(t);
      expect(pageObject.selectedIndex, 1);
    });

    testWidgets('after select --> initialIndex', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 1));
      final pageObject = createPageObject(t);

      await pageObject.select(2);

      expect(pageObject.selectedIndex, 2);
    });
  });
}

class _Widget extends StatelessWidget {
  final int length;
  final int initialIndex;

  const _Widget({required this.length, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: DefaultTabController(
        initialIndex: initialIndex,
        length: length,
        child: TabBar(key: aKey, tabs: _tabs()),
      ),
    );
  }

  List<Tab> _tabs() => List.generate(length, (i) => Tab(child: Text('Tab $i')));
}
