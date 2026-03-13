import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  TextFormFieldPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).textFormField(aFinder);

  group('textValue', () {
    testWidgets('not set without initial value --> empty', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);

      expect(pageObject.textValue, '');
    });

    testWidgets('not set with initial value --> initial value', (t) async {
      await t.pumpWidget(const _Widget(initialValue: 'initialValue'));
      final pageObject = createPageObject(t);

      expect(pageObject.textValue, 'initialValue');
    });

    testWidgets('setText without controller', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);

      await pageObject.setText('text');

      expect(pageObject.textValue, 'text');
    });

    testWidgets('setText with controller', (t) async {
      await t.pumpWidget(_Widget(controller: TextEditingController()));
      final pageObject = createPageObject(t);

      await pageObject.setText('text');

      expect(pageObject.textValue, 'text');
    });
  });
}

class _Widget extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;

  const _Widget({this.initialValue, this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TextFormField(
          key: aKey,
          initialValue: initialValue,
          controller: controller,
        ),
      ),
    );
  }
}
