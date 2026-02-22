import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

enum _Type {
  dropdownButton(DropdownButton.new),
  dropdownButtonFormField(DropdownButtonFormField.new),
  ;

  final _DropdownConstructor constructor;

  const _Type(this.constructor);
}

void main() {
  group('DropdownButton', () {
    _DropdownButtonTestImpl().runTests();
  });

  group('DropdownButtonFormField', () {
    _DropdownButtonFormFieldButtonTestImpl().runTests();
  });
}

class _DropdownButtonTestImpl extends _DropdownTest {
  @override
  _Type get type => _Type.dropdownButton;
}

class _DropdownButtonFormFieldButtonTestImpl extends _DropdownTest {
  @override
  _Type get type => _Type.dropdownButtonFormField;
}

abstract class _DropdownTest {
  _Type get type;

  DropdownPageObject<int> createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).dropdown(aFinder);

  _Widget createWidget(
          {bool isEnabled = true,
          required Map<int?, String> items,
          int? initialValue}) =>
      _Widget(
          type: type,
          isEnabled: isEnabled,
          items: items,
          initialValue: initialValue);

  void runTests() {
    group('value', () {
      testWidgets('no items --> null', (t) async {
        await t.pumpWidget(createWidget(items: {}));
        final pageObject = createPageObject(t);

        final value = pageObject.value;

        expect(value, null);
      });

      testWidgets('not selected without initial value --> null', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One'}));
        final pageObject = createPageObject(t);

        final value = pageObject.value;

        expect(value, null);
      });

      testWidgets('not selected with initial value --> initial value',
          (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One'}, initialValue: 1));
        final pageObject = createPageObject(t);

        final value = pageObject.value;

        expect(value, 1);
      });

      testWidgets('selected without initial value --> value', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One'}));
        final pageObject = createPageObject(t);
        await pageObject.select(1);

        final value = pageObject.value;

        expect(value, 1);
      });

      testWidgets('selected with initial value --> value', (t) async {
        await t.pumpWidget(
            createWidget(items: {1: 'One', 2: 'Two'}, initialValue: 1));
        final pageObject = createPageObject(t);
        await pageObject.select(2);

        final value = pageObject.value;

        expect(value, 2);
      });
    });

    group('values', () {
      testWidgets('no items', (t) async {
        await t.pumpWidget(createWidget(items: {}));
        final pageObject = createPageObject(t);

        final values = await pageObject.values();

        expect(values, orderedEquals([]));
      });

      testWidgets('single item', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One'}));
        final pageObject = createPageObject(t);

        final values = await pageObject.values();

        expect(values, orderedEquals([1]));
      });

      testWidgets('multiple items', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One', 2: 'Two'}));
        final pageObject = createPageObject(t);

        final values = await pageObject.values();

        expect(values, orderedEquals([1, 2]));
      });
    });

    group('select', () {
      testWidgets('no items --> throws', (t) async {
        await t.pumpWidget(createWidget(items: {}));
        final pageObject = createPageObject(t);
        await expectLater(() => pageObject.select(1), throwsStateError);
      });

      testWidgets('single item', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One'}));
        final pageObject = createPageObject(t);

        await pageObject.select(1);

        expect(pageObject.value, 1);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false, items: {1: 'One'}));
        final pageObject = createPageObject(t);
        await expectLater(() => pageObject.select(1), throwsStateError);
      });

      testWidgets('multiple items', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One', 2: 'Two'}));
        final pageObject = createPageObject(t);

        await pageObject.select(2);

        expect(pageObject.value, 2);
      });
    });

    group('isDisabled', () {
      testWidgets('no items --> true', (t) async {
        await t.pumpWidget(createWidget(items: {}));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isTrue);
      });

      testWidgets('enabled and has items --> false', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, items: {1: 'One'}));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isFalse);
      });

      testWidgets('disabled and has items --> true', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false, items: {1: 'One'}));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isTrue);
      });
    });

    group('isOpen', () {
      testWidgets('initially closed --> false', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One', 2: 'Two'}));
        final pageObject = createPageObject(t);
        expect(pageObject.isOpen, isFalse);
      });

      testWidgets('opened --> true', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One', 2: 'Two'}));
        final pageObject = createPageObject(t);

        await pageObject.open();

        expect(pageObject.isOpen, isTrue);
      });

      testWidgets('opend and then closed --> false', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One', 2: 'Two'}));
        final pageObject = createPageObject(t);

        await pageObject.open();
        expect(pageObject.isOpen, isTrue);

        await pageObject.close();
        expect(pageObject.isOpen, isFalse);
      });

      testWidgets('opened and then item selected --> false', (t) async {
        await t.pumpWidget(createWidget(items: {1: 'One', 2: 'Two'}));
        final pageObject = createPageObject(t);

        await pageObject.select(2);

        expect(pageObject.isOpen, isFalse);
      });
    });

    group('close', () {
      testWidgets('popup menu covers the screen --> throws', (t) async {
        await t.restoreViewSize(() async {
          await t.pumpWidget(createWidget(items: {1: 'One', 2: 'Two'}));
          final pageObject = createPageObject(t);

          await pageObject.open();

          t.view.physicalSize = const Size(1, 1);
          t.view.devicePixelRatio = 1.0;

          await expectLater(
            () => pageObject.close(),
            throwsA(isA<TestFailure>().having(
              (e) => e.message,
              'message',
              contains(
                  'Could not find a tap location outside the dropdown menu'),
            )),
          );
        });
      });
    });
  }
}

class _Widget extends StatefulWidget {
  final _Type type;
  final bool isEnabled;
  final Map<int?, String> items;
  final int? initialValue;

  const _Widget({
    required this.type,
    this.isEnabled = true,
    required this.items,
    this.initialValue,
  });

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  late int? _value;

  @override
  void initState() {
    super.initState();

    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(child: _dropdown());
  }

  Widget _dropdown() {
    return widget.type.constructor(
      key: aKey,
      value: _value,
      onChanged: widget.isEnabled ? _onChange : null,
      items: _items(widget.items),
    );
  }

  void _onChange(int? v) {
    setState(() => _value = v);
  }

  static List<DropdownMenuItem<int>> _items(Map<int?, String> values) {
    return values.entries.map((e) => _item(e.key, e.value)).toList();
  }

  static DropdownMenuItem<int> _item(int? value, String text) =>
      DropdownMenuItem(value: value, child: Text(text));
}

typedef _DropdownConstructor = Widget Function({
  Key? key,
  required List<DropdownMenuItem<int>>? items,
  required ValueChanged<int?>? onChanged,
  required int? value,
});
