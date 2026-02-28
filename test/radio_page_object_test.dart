import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

enum _Type {
  radio(Radio.new),
  radioListTile(RadioListTile.new),
  ;

  final _Constructor constructor;

  const _Type(this.constructor);
}

void main() {
  for (final type in _Type.values) {
    group('$type', () => _RadioTest(type).runTests());
  }

  testWidgets('unsupported widget --> throws', (t) async {
    await t.pumpWidget(
        const LocalizedWidgetWrapperForTesting(child: SizedBox(key: aKey)));

    final pageObject = PageObjectFactory.root(t).radio<int>(aFinder);

    expect(() => pageObject.isEnabled, throwsA(isA<TestFailure>()));
    expect(() => pageObject.isDisabled, throwsA(isA<TestFailure>()));
    expect(() => pageObject.isSelected, throwsA(isA<TestFailure>()));
    expect(() => pageObject.value, throwsA(isA<TestFailure>()));
    expect(() => pageObject.groupValue, throwsA(isA<TestFailure>()));
  });
}

class _RadioTest {
  final _Type type;

  _RadioTest(this.type);

  RadioPageObject<int> createPageObject(WidgetTester t, {required Key key}) =>
      PageObjectFactory.root(t).byKey.radio(key);

  _Widget createWidget({
    bool isEnabled = true,
    int groupValue = 1,
    List<int> values = const [1, 2],
  }) =>
      _Widget(
        type: type,
        isEnabled: isEnabled,
        groupValue: groupValue,
        values: values,
      );

  void runTests() {
    group('isEnabled', () {
      testWidgets('enabled --> true', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
        final pageObject = createPageObject(t, key: _keyForRadio(1));
        expect(pageObject.isEnabled, isTrue);
      });

      testWidgets('disabled --> false', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t, key: _keyForRadio(1));
        expect(pageObject.isEnabled, isFalse);
      });
    });

    group('isDisabled', () {
      testWidgets('enabled --> false', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
        final pageObject = createPageObject(t, key: _keyForRadio(1));
        expect(pageObject.isDisabled, isFalse);
      });

      testWidgets('disabled --> true', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t, key: _keyForRadio(1));
        expect(pageObject.isDisabled, isTrue);
      });
    });

    group('isSelected', () {
      testWidgets('selected --> true', (t) async {
        await t.pumpWidget(createWidget(groupValue: 1, values: [1, 2]));
        final pageObject = createPageObject(t, key: _keyForRadio(1));
        expect(pageObject.isSelected, isTrue);
      });

      testWidgets('not selected --> false', (t) async {
        await t.pumpWidget(createWidget(groupValue: 2, values: [1, 2]));
        final pageObject = createPageObject(t, key: _keyForRadio(1));
        expect(pageObject.isSelected, isFalse);
      });
    });

    testWidgets('value --> value', (t) async {
      await t.pumpWidget(createWidget(values: [1]));
      final pageObject = createPageObject(t, key: _keyForRadio(1));
      expect(pageObject.value, 1);
    });

    testWidgets('groupValue --> group value', (t) async {
      await t.pumpWidget(createWidget(groupValue: 1, values: [2]));
      final pageObject = createPageObject(t, key: _keyForRadio(2));

      expect(pageObject.groupValue, 1);
    });

    group('select', () {
      testWidgets('enabled and not selected --> selected', (t) async {
        await t.pumpWidget(
            createWidget(isEnabled: true, groupValue: 1, values: [1, 2]));
        final pageObject1 = createPageObject(t, key: _keyForRadio(1));
        final pageObject2 = createPageObject(t, key: _keyForRadio(2));
        expect(pageObject1.isSelected, isTrue);
        expect(pageObject2.isSelected, isFalse);

        await pageObject2.select();

        expect(pageObject1.isSelected, isFalse);
        expect(pageObject2.isSelected, isTrue);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(
            createWidget(isEnabled: false, groupValue: 1, values: [1, 2]));
        final pageObject = createPageObject(t, key: _keyForRadio(1));
        await expectLater(() => pageObject.select(), throwsStateError);
      });
    });
  }
}

class _Widget extends StatefulWidget {
  final _Type type;
  final bool isEnabled;
  final int groupValue;
  final List<int> values;

  const _Widget({
    required this.type,
    required this.isEnabled,
    required this.groupValue,
    required this.values,
  });

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  late int? _groupValue = widget.groupValue;

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: Column(
        children: widget.values.map(_buildRadio).toList(),
      ),
    );
  }

  Widget _buildRadio(int value) {
    return widget.type.constructor(
      key: Key('radio$value'),
      value: value,
      groupValue: _groupValue,
      onChanged: widget.isEnabled ? _onChanged : null,
    );
  }

  void _onChanged(int? v) {
    setState(() => _groupValue = v);
  }
}

typedef _Constructor = Widget Function({
  Key? key,
  required int value,
  required int? groupValue,
  required ValueChanged<int?>? onChanged,
});

Key _keyForRadio(int value) => Key('radio$value');
