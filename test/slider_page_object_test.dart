import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  SliderPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).slider(aFinder);

  testWidgets('value --> value', (t) async {
    await t.pumpWidget(const _Widget(value: 0.5));
    final pageObject = createPageObject(t);
    expect(pageObject.value, 0.5);
  });

  testWidgets('min --> min', (t) async {
    await t.pumpWidget(const _Widget(min: 0.2, value: 0.3));
    final pageObject = createPageObject(t);
    expect(pageObject.min, 0.2);
  });

  testWidgets('max --> max', (t) async {
    await t.pumpWidget(const _Widget(max: 0.8));
    final pageObject = createPageObject(t);
    expect(pageObject.max, 0.8);
  });

  group('divisions', () {
    testWidgets('null --> returns null', (t) async {
      await t.pumpWidget(const _Widget(divisions: null));
      final pageObject = createPageObject(t);
      expect(pageObject.divisions, isNull);
    });

    testWidgets('not null --> returns divisions', (t) async {
      await t.pumpWidget(const _Widget(divisions: 5));
      final pageObject = createPageObject(t);
      expect(pageObject.divisions, 5);
    });
  });

  group('isEnabled', () {
    testWidgets('enabled --> true', (t) async {
      await t.pumpWidget(const _Widget(isEnabled: true));
      final pageObject = createPageObject(t);
      expect(pageObject.isEnabled, isTrue);
    });

    testWidgets('disabled --> false', (t) async {
      await t.pumpWidget(const _Widget(isEnabled: false));
      final pageObject = createPageObject(t);
      expect(pageObject.isEnabled, isFalse);
    });
  });

  group('isDisabled', () {
    testWidgets('disabled --> true', (t) async {
      await t.pumpWidget(const _Widget(isEnabled: false));
      final pageObject = createPageObject(t);
      expect(pageObject.isDisabled, isTrue);
    });

    testWidgets('enabled --> false', (t) async {
      await t.pumpWidget(const _Widget(isEnabled: true));
      final pageObject = createPageObject(t);
      expect(pageObject.isDisabled, isFalse);
    });
  });

  group('drag', () {
    testWidgets('enabled --> drags', (t) async {
      await t.pumpWidget(const _Widget(value: 0.5, isEnabled: true));
      final pageObject = createPageObject(t);

      await pageObject.drag(const Offset(100, 0));

      expect(pageObject.value, greaterThan(0.5));
    });

    testWidgets('disabled --> throws', (t) async {
      await t.pumpWidget(const _Widget(value: 0.5, isEnabled: false));
      final pageObject = createPageObject(t);
      await expectLater(
          () => pageObject.drag(const Offset(100, 0)), throwsStateError);
    });
  });
}

class _Widget extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final bool isEnabled;

  const _Widget({
    this.value = 0.0,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.isEnabled = true,
  });

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  late double _value = widget.value;

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: Slider(
        key: aKey,
        value: _value,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        onChanged: widget.isEnabled ? (v) => setState(() => _value = v) : null,
      ),
    );
  }
}
