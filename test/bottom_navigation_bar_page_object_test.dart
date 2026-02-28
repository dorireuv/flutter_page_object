import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  BottomNavigationBarPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).bottomNavigationBar(aFinder);

  group('select', () {
    testWidgets('not selected --> selected', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 0));
      final pageObject = createPageObject(t);

      await pageObject.select(1);

      expect(pageObject.selectedIndex, 1);
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

    testWidgets('after select --> selectedIndex', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 0));
      final pageObject = createPageObject(t);

      await pageObject.select(1);

      expect(pageObject.selectedIndex, 1);
    });
  });
}

class _Widget extends StatefulWidget {
  final int length;
  final int initialIndex;

  const _Widget({required this.length, required this.initialIndex});

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: BottomNavigationBar(
        key: aKey,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: List.generate(widget.length, _item),
      ),
    );
  }

  BottomNavigationBarItem _item(int index) =>
      BottomNavigationBarItem(icon: const Icon(Icons.home), label: '$index');
}
