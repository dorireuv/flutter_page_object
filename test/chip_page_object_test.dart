import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

enum _Type {
  choiceChip(_buildChoiceChip),
  filterChip(_buildFilterChip),
  inputChip(_buildInputChip),
  rawChip(_buildRawChip),
  ;

  final _ChipBuilder builder;

  const _Type(this.builder);
}

void main() {
  for (final type in _Type.values) {
    group('$type', () => _Test(type).runTests());
  }

  testWidgets('unsupported widget --> throws', (t) async {
    await t.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox(key: aKey))));
    final pageObject = PageObjectFactory.root(t).byKey.chip(aKey);
    expect(() => pageObject.widget(), throwsStateError);
  });
}

class _Test {
  final _Type type;

  _Test(this.type);

  ChipPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).byKey.chip(aKey);

  _Widget createWidget({bool selected = false, bool isEnabled = true}) =>
      _Widget(type: type, selected: selected, isEnabled: isEnabled);

  void runTests() {
    group('isEnabled', () {
      testWidgets('enabled --> true', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
        final pageObject = createPageObject(t);
        expect(pageObject.isEnabled, isTrue);
      });

      testWidgets('disabled --> false', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        expect(pageObject.isEnabled, isFalse);
      });
    });

    group('isDisabled', () {
      testWidgets('enabled --> false', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isFalse);
      });

      testWidgets('disabled --> true', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isTrue);
      });
    });

    group('isSelected', () {
      testWidgets('selected --> true', (t) async {
        await t.pumpWidget(createWidget(selected: true));
        final pageObject = createPageObject(t);
        expect(pageObject.isSelected, isTrue);
      });

      testWidgets('not selected --> false', (t) async {
        await t.pumpWidget(createWidget(selected: false));
        final pageObject = createPageObject(t);
        expect(pageObject.isSelected, isFalse);
      });
    });

    group('select', () {
      testWidgets('not selected --> selected', (t) async {
        await t.pumpWidget(createWidget(selected: false, isEnabled: true));
        final pageObject = createPageObject(t);

        await pageObject.select();

        expect(pageObject.isSelected, isTrue);
      });

      testWidgets('selected --> selected (noop)', (t) async {
        await t.pumpWidget(createWidget(selected: true, isEnabled: true));
        final pageObject = createPageObject(t);

        await pageObject.select();

        expect(pageObject.isSelected, isTrue);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        await expectLater(pageObject.select, throwsStateError);
      });
    });

    group('deselect', () {
      testWidgets('selected --> not selected', (t) async {
        await t.pumpWidget(createWidget(selected: true, isEnabled: true));
        final pageObject = createPageObject(t);

        await pageObject.deselect();

        expect(pageObject.isSelected, isFalse);
      });

      testWidgets('not selected --> not selected (noop)', (t) async {
        await t.pumpWidget(createWidget(selected: false, isEnabled: true));
        final pageObject = createPageObject(t);

        await pageObject.deselect();

        expect(pageObject.isSelected, isFalse);
      });

      testWidgets('disabled --> throws', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        await expectLater(pageObject.deselect, throwsStateError);
      });
    });
  }
}

class _Widget extends StatefulWidget {
  final _Type type;
  final bool selected;
  final bool isEnabled;

  const _Widget({
    required this.type,
    this.selected = false,
    this.isEnabled = true,
  });

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  late bool _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: _chip()));
  }

  Widget _chip() {
    return widget.type.builder(
      key: aKey,
      label: const Text('label'),
      selected: _selected,
      isEnabled: widget.isEnabled,
      onSelected:
          widget.isEnabled ? (v) => setState(() => _selected = v) : null,
    );
  }
}

typedef _ChipBuilder = Widget Function({
  Key? key,
  required Widget label,
  required bool selected,
  required bool isEnabled,
  required ValueChanged<bool>? onSelected,
});

Widget _buildChoiceChip({
  Key? key,
  required Widget label,
  required bool selected,
  required bool isEnabled,
  required ValueChanged<bool>? onSelected,
}) =>
    ChoiceChip(
      key: key,
      label: label,
      selected: selected,
      onSelected: onSelected,
    );

Widget _buildFilterChip({
  Key? key,
  required Widget label,
  required bool selected,
  required bool isEnabled,
  required ValueChanged<bool>? onSelected,
}) =>
    FilterChip(
      key: key,
      label: label,
      selected: selected,
      onSelected: onSelected,
    );

Widget _buildInputChip({
  Key? key,
  required Widget label,
  required bool selected,
  required bool isEnabled,
  required ValueChanged<bool>? onSelected,
}) =>
    InputChip(
      key: key,
      label: label,
      selected: selected,
      isEnabled: isEnabled,
      onSelected: onSelected,
    );

Widget _buildRawChip({
  Key? key,
  required Widget label,
  required bool selected,
  required bool isEnabled,
  required ValueChanged<bool>? onSelected,
}) =>
    RawChip(
      key: key,
      label: label,
      selected: selected,
      isEnabled: isEnabled,
      onSelected: onSelected,
    );
