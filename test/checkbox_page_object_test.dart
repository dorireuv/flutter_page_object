import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

enum _CheckboxType {
  checkbox(Checkbox.new),
  checkboxListTile(CheckboxListTile.new),
  ;

  final _CheckboxConstructor constructor;

  const _CheckboxType(this.constructor);
}

void main() {
  group('Checkbox', () {
    _CheckboxTestImpl().runTests();
  });

  group('CheckboxListTile', () {
    _CheckboxListTileTestImpl().runTests();
  });
}

class _CheckboxTestImpl extends _CheckboxTest {
  @override
  _CheckboxType get type => _CheckboxType.checkbox;
}

class _CheckboxListTileTestImpl extends _CheckboxTest {
  @override
  _CheckboxType get type => _CheckboxType.checkboxListTile;
}

abstract class _CheckboxTest {
  _CheckboxType get type;

  CheckboxPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).checkbox(aFinder);

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
      testWidgets('checked --> true', (t) async {
        await t.pumpWidget(createWidget(value: true));
        final pageObject = createPageObject(t);
        expect(pageObject.value, isTrue);
      });

      testWidgets('unchecked --> false', (t) async {
        await t.pumpWidget(createWidget(value: false));
        final pageObject = createPageObject(t);
        expect(pageObject.value, isFalse);
      });
    });

    group('check', () {
      testWidgets('enabled and checked --> checked', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, value: true));
        final pageObject = createPageObject(t);

        await pageObject.check();

        expect(pageObject.value, isTrue);
      });

      testWidgets('enabled and unchecked --> checked', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, value: false));
        final pageObject = createPageObject(t);

        await pageObject.check();

        expect(pageObject.value, isTrue);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        await expectLater(pageObject.check, throwsStateError);
      });
    });

    group('uncheck', () {
      testWidgets('enabled and unchecked --> unchecked', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, value: false));
        final pageObject = createPageObject(t);

        await pageObject.uncheck();

        expect(pageObject.value, isFalse);
      });

      testWidgets('enabled and checked --> unchecked', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true, value: true));
        final pageObject = createPageObject(t);

        await pageObject.uncheck();

        expect(pageObject.value, isFalse);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);

        await expectLater(pageObject.uncheck, throwsStateError);
      });
    });
  }
}

class _Widget extends StatefulWidget {
  final _CheckboxType type;
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
    return LocalizedWidgetWrapperForTesting(child: _checkbox());
  }

  Widget _checkbox() {
    return widget.type.constructor(
      key: aKey,
      value: _value,
      onChanged: widget.isEnabled ? _onChanged : null,
    );
  }

  void _onChanged(bool? v) {
    setState(() => _value = v!);
  }
}

typedef _CheckboxConstructor = Widget Function({
  Key? key,
  required ValueChanged<bool?>? onChanged,
  required bool? value,
});
