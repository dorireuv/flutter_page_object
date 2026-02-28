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
    group('$type', () => _RadioGroupTest(type).runTests());
  }
}

class _RadioGroupTest {
  final _Type type;

  _RadioGroupTest(this.type);

  RadioGroupPageObject<int> createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).byKey.radioGroup(aKey);

  _Widget createWidget(
          {bool isEnabled = true,
          int groupValue = 1,
          List<int> values = const [1, 2]}) =>
      _Widget(
          type: type,
          isEnabled: isEnabled,
          groupValue: groupValue,
          values: values);

  void runTests() {
    group('isSelected', () {
      testWidgets('selected --> true', (t) async {
        await t.pumpWidget(createWidget(groupValue: 1, values: [1, 2]));
        final pageObject = createPageObject(t);
        expect(pageObject.isSelected(1), isTrue);
      });

      testWidgets('not selected --> false', (t) async {
        await t.pumpWidget(createWidget(groupValue: 2, values: [1, 2]));
        final pageObject = createPageObject(t);
        expect(pageObject.isSelected(1), isFalse);
      });
    });

    group('groupValue', () {
      testWidgets('selected --> value', (t) async {
        await t.pumpWidget(createWidget(groupValue: 1, values: [1, 2]));
        final pageObject = createPageObject(t);
        expect(pageObject.groupValue, 1);
      });

      testWidgets('not selected --> null', (t) async {
        await t.pumpWidget(createWidget(groupValue: 3, values: [1, 2]));
        final pageObject = createPageObject(t);
        expect(pageObject.groupValue, isNull);
      });
    });

    group('select', () {
      testWidgets('enabled and not selected --> selected', (t) async {
        await t.pumpWidget(
            createWidget(isEnabled: true, groupValue: 1, values: [1, 2]));
        final pageObject = createPageObject(t);

        expect(pageObject.isSelected(1), isTrue);
        expect(pageObject.isSelected(2), isFalse);

        await pageObject.select(2);

        expect(pageObject.isSelected(1), isFalse);
        expect(pageObject.isSelected(2), isTrue);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(
            createWidget(isEnabled: false, groupValue: 1, values: [1, 2]));
        final pageObject = createPageObject(t);
        await expectLater(() => pageObject.select(2), throwsStateError);
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
      child:
          Column(key: aKey, children: widget.values.map(_buildRadio).toList()),
    );
  }

  Widget _buildRadio(int value) {
    return widget.type.constructor(
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
  required int value,
  required int? groupValue,
  required ValueChanged<int?>? onChanged,
});
