import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

enum _Type {
  switchWidget(Switch.new),
  switchListTile(SwitchListTile.new),
  ;

  final _Constructor constructor;

  const _Type(this.constructor);
}

void main() {
  for (final type in _Type.values) {
    group('$type', () => _SwitchTest(type).runTests());
  }
}

class _SwitchTest {
  final _Type type;

  _SwitchTest(this.type);

  SwitchPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).switch_(aFinder);

  _Widget createWidget({bool value = false, bool isEnabled = false}) =>
      _Widget(type: type, value: value, isEnabled: isEnabled);

  void runTests() {
    group('isDisabled', () {
      testWidgets('disabled --> true', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isTrue);
      });

      testWidgets('enabled --> false', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isFalse);
      });
    });

    group('value', () {
      testWidgets('on --> true', (t) async {
        await t.pumpWidget(createWidget(value: true));
        final pageObject = createPageObject(t);
        expect(pageObject.value, isTrue);
      });

      testWidgets('off --> false', (t) async {
        await t.pumpWidget(createWidget(value: false));
        final pageObject = createPageObject(t);
        expect(pageObject.value, isFalse);
      });
    });

    group('turnOn', () {
      testWidgets('enabled and turned on --> turned on', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, value: true));
        final pageObject = createPageObject(t);

        await pageObject.turnOn();

        expect(pageObject.value, isTrue);
      });

      testWidgets('enabled and turned off --> turned on', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, value: false));
        final pageObject = createPageObject(t);

        await pageObject.turnOn();

        expect(pageObject.value, isTrue);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        await expectLater(() => pageObject.turnOn(), throwsStateError);
      });
    });

    group('turnOff', () {
      testWidgets('enabled and turned off --> turned off', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, value: false));
        final pageObject = createPageObject(t);

        await pageObject.turnOff();

        expect(pageObject.value, isFalse);
      });

      testWidgets('enabled and turned on --> turned off', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, value: true));
        final pageObject = createPageObject(t);

        await pageObject.turnOff();

        expect(pageObject.value, isFalse);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        await expectLater(() => pageObject.turnOff(), throwsStateError);
      });
    });
  }
}

class _Widget extends StatefulWidget {
  final _Type type;
  final bool value;
  final bool isEnabled;

  const _Widget({
    required this.type,
    this.value = false,
    this.isEnabled = false,
  });

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  late var _value = widget.value;

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(child: _switch());
  }

  Widget _switch() {
    return widget.type.constructor(
      key: aKey,
      value: _value,
      onChanged: widget.isEnabled ? _onChanged : null,
    );
  }

  void _onChanged(bool v) {
    setState(() => _value = v);
  }
}

typedef _Constructor = Widget Function({
  Key? key,
  required ValueChanged<bool>? onChanged,
  required bool value,
});
