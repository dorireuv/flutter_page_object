import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'localized_widget_wrapper_for_testing.dart';

void main() {
  _TestPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).test(_finder);

  testWidgets('delegates Finder properties', (t) async {
    await t.pumpWidget(const _Widget());
    final pageObject = createPageObject(t);

    // ignore: deprecated_member_use
    expect(pageObject.description, _finder.description);
    expect(pageObject.allCandidates, _finder.allCandidates);
    expect(pageObject.findInCandidates(t.allElements),
        _finder.findInCandidates(t.allElements));
  });

  testWidgets('r=root finds target in the widget tree', (t) async {
    await t.pumpWidget(const _Widget());
    final pageObject = createPageObject(t);
    expect(pageObject.r.byType.widget(MaterialApp), findsOne);
  });

  testWidgets('d=descendantOf finds only descendants', (t) async {
    await t.pumpWidget(const _Widget());
    final pageObject = createPageObject(t);

    expect(pageObject.d.byKey.widget(_buttonKey), findsOne);
    expect(pageObject.d.byType.widget(MaterialApp), findsNothing);
  });

  testWidgets('tap --> taps', (t) async {
    await t.pumpWidget(const _Widget());
    final pageObject = createPageObject(t);

    await pageObject.button.tap();
    await t.pump();

    expect(pageObject.text, findsOne);
  });

  testWidgets('tapAndPump --> taps and pumps the widget tree', (t) async {
    await t.pumpWidget(const _Widget());
    final pageObject = createPageObject(t);

    await pageObject.button.tapAndPump();

    expect(pageObject.text, findsOne);
  });

  testWidgets('tapAndSettle --> taps and settles the widget tree', (t) async {
    await t.pumpWidget(const _Widget());
    final pageObject = createPageObject(t);

    await pageObject.button.tapAndSettle();

    expect(pageObject.text, findsOne);
  });

  group('waitWhileShown', () {
    testWidgets('waits until the widget is no longer shown', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);
      await pageObject.button.tap();
      await t.pump();
      expect(pageObject.text, findsOne);

      await pageObject.button.tap();
      await pageObject.text.waitWhileShown();

      expect(pageObject.text, findsNothing);
    });

    testWidgets('noop if the widget is already not shown', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);

      await pageObject.text.waitWhileShown();

      expect(pageObject.text, findsNothing);
    });

    testWidgets('throws on timeout if widget remains shown', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);

      await expectLater(
        () => pageObject.button
            .waitWhileShown(timeout: const Duration(milliseconds: 50)),
        throwsA(isA<TestFailure>()),
      );
    });
  });
}

class _TestPageObject extends PageObject {
  late final button = d.byKey.widget(_buttonKey);
  late final text = d.byKey.text(_textKey);

  _TestPageObject(super.t, super.finder);
}

extension _TestPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  _TestPageObject test(K key) => create(_TestPageObject.new, key);
}

class _Widget extends StatefulWidget {
  const _Widget();

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  var _isTextVisible = false;

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: Column(
        key: _widgetKey,
        children: [
          _button(),
          if (_isTextVisible) _text(),
        ],
      ),
    );
  }

  /// Used in order to verify pumping of the widget tree.
  Text _text() => const Text('text', key: _textKey);

  Widget _button() {
    return ElevatedButton(
      key: _buttonKey,
      onPressed: () {
        setState(() => _isTextVisible = !_isTextVisible);
      },
      child: const Text('tap'),
    );
  }
}

const _widgetKey = Key('key');
final _finder = find.byKey(_widgetKey);

const _buttonKey = Key('button');
const _textKey = Key('text');
