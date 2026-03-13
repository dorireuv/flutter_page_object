import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

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
    testWidgets('byKey', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject = factory.byKey.create(WidgetPageObject.new, _buttonKey);

      expect(pageObject, findsOne);
    });

    testWidgets('byIcon', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject = factory.byIcon.create(WidgetPageObject.new, _iconData);

      expect(pageObject, findsOne);
    });

    testWidgets('byType', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject = factory.byType.create(WidgetPageObject.new, Text);

      expect(pageObject, findsNWidgets(2));
    });

    testWidgets('byText', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject = factory.byText.create(WidgetPageObject.new, _text1);

      expect(pageObject, findsOne);
    });

    testWidgets('byTextContaining', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject =
          factory.byTextContaining.create(WidgetPageObject.new, _text);

      expect(pageObject, findsNWidgets(2));
    });

    testWidgets('byTooltip', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject =
          factory.byTooltip.create(WidgetPageObject.new, _tooltipMessage);

      expect(pageObject, findsOne);
    });

    testWidgets('bySemanticsLabel', (t) async {
      await t.pumpWidget(const _Widget());
      final factory = PageObjectFactory.root(t);

      final pageObject = factory.bySemanticsLabel
          .create(WidgetPageObject.new, _sematicLabelText);

      expect(pageObject, findsOne);
    });
  });
}

class _Widget extends StatelessWidget {
  const _Widget();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          key: _widgetKey,
          children: [
            _button(key: _buttonKey),
            _icon(iconData: _iconData),
            _text(text: _text1),
            _text(text: _text2),
            _tooltip(),
          ],
        ),
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

  Widget _icon({required IconData iconData}) =>
      Icon(iconData, semanticLabel: _sematicLabelText);

  Widget _text({required String text}) => Text(text);

  Widget _tooltip() =>
      const Tooltip(message: _tooltipMessage, child: SizedBox.shrink());
}

const _widgetKey = Key('key');
final _finder = find.byKey(_widgetKey);

const _buttonKey = Key('button');
const _iconData = Icons.widgets;
const _text = 'text';
const _text1 = '${_text}1';
const _text2 = '${_text}2';
const _tooltipMessage = 'message';
const _sematicLabelText = 'semantic label';
