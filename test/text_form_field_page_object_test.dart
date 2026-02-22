import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  TextFormFieldPageObject<String> createStringPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).stringTextFormField(aFinder);

  TextFormFieldPageObject<bool> createBoolPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).textFormField(
        aFinder,
        formatter: (v) => v.toString(),
        parser: bool.tryParse,
      );

  group('textValue', () {
    testWidgets('not set without initial value --> empty', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createStringPageObject(t);

      expect(pageObject.textValue, '');
    });

    testWidgets('not set with initial value --> initial value', (t) async {
      await t.pumpWidget(const _Widget(initialValue: 'initialValue'));
      final pageObject = createStringPageObject(t);

      expect(pageObject.textValue, 'initialValue');
    });

    testWidgets('set without controller', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createStringPageObject(t);

      await pageObject.set('text');

      expect(pageObject.textValue, 'text');
    });

    testWidgets('set with controller', (t) async {
      await t.pumpWidget(_Widget(controller: TextEditingController()));
      final pageObject = createStringPageObject(t);

      await pageObject.set('text');

      expect(pageObject.textValue, 'text');
    });
  });

  group('value', () {
    testWidgets('without initial value --> null', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createBoolPageObject(t);

      expect(pageObject.value, null);
    });

    testWidgets('with valid initial value --> initial value', (t) async {
      await t.pumpWidget(_Widget(initialValue: true.toString()));
      final pageObject = createBoolPageObject(t);

      expect(pageObject.value, true);
    });

    testWidgets('with invalid initial value --> null', (t) async {
      await t.pumpWidget(const _Widget(initialValue: 'invalid'));
      final pageObject = createBoolPageObject(t);

      expect(pageObject.value, null);
    });

    testWidgets('set', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createBoolPageObject(t);

      await pageObject.set(true);

      expect(pageObject.value, true);
    });

    testWidgets('setText with valid value --> value', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createBoolPageObject(t);

      await pageObject.setText(true.toString());

      expect(pageObject.value, true);
    });

    testWidgets('setText with invalid value --> null', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createBoolPageObject(t);

      await pageObject.setText('invalid');

      expect(pageObject.value, null);
    });
  });
}

class _Widget extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;

  const _Widget({this.initialValue, this.controller});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: TextFormField(
        key: aKey,
        initialValue: initialValue,
        controller: controller,
      ),
    );
  }
}
