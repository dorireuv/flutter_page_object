import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  BottomNavigationBarPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).bottomNavigationBar(aFinder);

  group('selectByIndex', () {
    testWidgets('not selected --> selected', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 0));
      final pageObject = createPageObject(t);

      await pageObject.selectByIndex(1);

      expect(pageObject.selectedIndex, 1);
      expect(_finderByIndex(1), findsOne);
    });
  });

  group('selectByIcon', () {
    testWidgets('not selected --> selected', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 0));
      final pageObject = createPageObject(t);

      await pageObject.selectByIcon(_iconByIndex(1));

      expect(pageObject.selectedIndex, 1);
      expect(_finderByIndex(1), findsOne);
    });
  });

  group('item', () {
    testWidgets('tapNav and not selected --> selected', (t) async {
      await t.pumpWidget(const _Widget(length: 3, initialIndex: 0));
      final pageObject = createPageObject(t);

      final target = await pageObject
          .item(_iconByIndex(1), _itemPageObjectBuilder(1))
          .tapNavAndPump();

      expect(pageObject.selectedIndex, 1);
      expect(target, findsOne);
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

      await pageObject.selectByIndex(1);

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
    return MaterialApp(
      home: Scaffold(
        body: Text('$_currentIndex', key: _keyByIndex(_currentIndex)),
        bottomNavigationBar: BottomNavigationBar(
          key: aKey,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: List.generate(widget.length, _item),
        ),
      ),
    );
  }

  BottomNavigationBarItem _item(int i) =>
      BottomNavigationBarItem(icon: Icon(_iconByIndex(i)), label: '$i');
}

Key _keyByIndex(int i) => Key('key_$i');
Finder _finderByIndex(int i) => find.byKey(_keyByIndex(i));
IconData _iconByIndex(int i) => _icons[i];

PageObjectStaticBuilder<TextPageObject> _itemPageObjectBuilder(int i) =>
    (t) => TextPageObject(t, _finderByIndex(i));

const _icons = [
  Icons.battery_0_bar,
  Icons.battery_1_bar,
  Icons.battery_2_bar,
];
