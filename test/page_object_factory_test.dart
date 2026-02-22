import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'localized_widget_wrapper_for_testing.dart';

void main() {
  testWidgets('root --> finds target in the widget tree', (t) async {
    await t.pumpWidget(const _Widget());
    final factory = PageObjectFactory.root(t);
    expect(factory.byType.widget(MaterialApp), findsOne);
  });

  testWidgets('descendantOf --> finds only descendants targets', (t) async {
    await t.pumpWidget(const _Widget());
    final factory = PageObjectFactory.descendantOf(t, _finder);
    expect(factory.byKey.widget(_buttonKey), findsOne);
    expect(factory.byType.widget(MaterialApp), findsNothing);
  });

  testWidgets('map --> maps key type and applies the mapping', (t) async {
    await t.pumpWidget(const _Widget());
    final initialFactory = PageObjectFactory.root(t);

    final mappedFactory = initialFactory.map<Key>((key) => find.byKey(key));

    expect(mappedFactory, isA<PageObjectFactory<Key>>());
    final pageObject = mappedFactory.create(WidgetPageObject.new, _widgetKey);
    expect(pageObject, findsOne);
  });

  testWidgets('create --> creates a PageObject', (t) async {
    await t.pumpWidget(const _Widget());
    final factory = PageObjectFactory.root(t);

    final pageObject = factory.create(WidgetPageObject.new, _finder);

    expect(pageObject, isA<WidgetPageObject>());
    expect(pageObject, findsOne);
  });

  testWidgets('createStatic --> creates a PageObject without finder',
      (t) async {
    await t.pumpWidget(const _Widget());
    final factory = PageObjectFactory.root(t);

    final pageObject =
        factory.createStatic((t) => WidgetPageObject(t, _finder));

    expect(pageObject, isA<WidgetPageObject>());
    expect(pageObject, findsOne);
  });

  group('PageObjectFactoryFinderExtension', () {
    testWidgets('byKey finds by Key', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject = factory.byKey.create(WidgetPageObject.new, _buttonKey);

      expect(pageObject, findsOne);
    });

    testWidgets('byIcon finds by IconData', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject = factory.byIcon.create(WidgetPageObject.new, _iconData);

      expect(pageObject, findsOne);
    });

    testWidgets('byType finds by Type', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject = factory.byType.create(WidgetPageObject.new, Text);

      expect(pageObject, findsNWidgets(2));
    });

    testWidgets('textContaining finds by text', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject =
          factory.textContaining.create(WidgetPageObject.new, 'text');

      expect(pageObject, findsNWidgets(2));
    });
  });
}

class _Widget extends StatelessWidget {
  const _Widget();

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: Column(
        key: _widgetKey,
        children: [
          _button(key: _buttonKey),
          _icon(iconData: _iconData),
          _text(text: _text1),
          _text(text: _text2),
        ],
      ),
    );
  }

  Widget _button({required Key key}) {
    return ElevatedButton(
      key: key,
      onPressed: () {},
      child: const SizedBox.shrink(),
    );
  }

  Widget _icon({required IconData iconData}) => Icon(iconData);

  Widget _text({required String text}) => Text(text);
}

const _widgetKey = Key('key');
final _finder = find.byKey(_widgetKey);

const _buttonKey = Key('button');
const _iconData = Icons.widgets;
const _text1 = 'text1';
const _text2 = 'text2';
