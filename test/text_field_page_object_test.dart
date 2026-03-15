import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  TextFieldPageObject<String> createStringPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).textField(aFinder);

  TextFieldPageObject<bool> createBoolPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).customTextField(
        aFinder,
        formatter: (v) => v.toString(),
        parser: bool.tryParse,
      );

  group('textValue', () {
    testWidgets('not set without controller --> empty', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createStringPageObject(t);
      expect(pageObject.textValue, '');
    });

    testWidgets('not set with controller --> controller value', (t) async {
      await t.pumpWidget(
          _Widget(controller: TextEditingController(text: 'initial')));
      final pageObject = createStringPageObject(t);
      expect(pageObject.textValue, 'initial');
    });

    testWidgets('setText without controller', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createStringPageObject(t);

      await pageObject.setText('text');

      expect(pageObject.textValue, 'text');
    });

    testWidgets('setText with controller', (t) async {
      await t.pumpWidget(_Widget(controller: TextEditingController()));
      final pageObject = createStringPageObject(t);

      await pageObject.setText('text');

      expect(pageObject.textValue, 'text');
    });
  });

  group('value', () {
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
  final TextEditingController? controller;

  const _Widget({this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TextField(
          key: aKey,
          controller: controller,
        ),
      ),
    );
  }
}
