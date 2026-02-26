import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

enum _Type {
  checkbox(Checkbox.new),
  checkboxListTile(CheckboxListTile.new),
  ;

  final _Constructor constructor;

  const _Type(this.constructor);
}

void main() {
  for (final type in _Type.values) {
    group('$type', () => _TristateCheckboxTest(type).runTests());
  }
}

class _TristateCheckboxTest {
  final _Type type;

  _TristateCheckboxTest(this.type);

  TristateCheckboxPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).tristateCheckbox(aFinder);

  Widget createWidget({bool? value = false, bool isEnabled = true}) =>
      _Widget(type: type, value: value, isEnabled: isEnabled);

  void runTests() {
    group('value', () {
      testWidgets('checked --> true', (t) async {
        await t.pumpWidget(createWidget(value: true));
        final pageObject = createPageObject(t);

        final value = pageObject.value;

        expect(value, isTrue);
      });

      testWidgets('unchecked --> false', (t) async {
        await t.pumpWidget(createWidget(value: false));
        final pageObject = createPageObject(t);

        final value = pageObject.value;

        expect(value, isFalse);
      });

      testWidgets('indeterminate --> null', (t) async {
        await t.pumpWidget(createWidget(value: null));
        final pageObject = createPageObject(t);

        final value = pageObject.value;

        expect(value, isNull);
      });
    });

    group('check', () {
      testWidgets('enabled --> checked', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
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
      testWidgets('enabled --> unchecked', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
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

    group('indeterminate', () {
      testWidgets('enabled --> indeterminate', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
        final pageObject = createPageObject(t);

        await pageObject.indeterminate();

        expect(pageObject.value, isNull);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);

        await expectLater(pageObject.indeterminate, throwsStateError);
      });
    });
  }
}

class _Widget extends StatefulWidget {
  final _Type type;
  final bool? value;
  final bool isEnabled;

  const _Widget({
    required this.type,
    this.value,
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
      tristate: true,
      value: _value,
      onChanged: widget.isEnabled ? _onChanged : null,
    );
  }

  void _onChanged(bool? v) {
    setState(() => _value = v);
  }
}

typedef _Constructor = Widget Function({
  Key? key,
  bool tristate,
  required ValueChanged<bool?>? onChanged,
  required bool? value,
});
