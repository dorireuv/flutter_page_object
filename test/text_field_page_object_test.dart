import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  TextFieldPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).textField(aFinder);

  group('textValue', () {
    testWidgets('not set without controller --> empty', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);
      expect(pageObject.textValue, '');
    });

    testWidgets('not set with controller --> controller value', (t) async {
      await t.pumpWidget(
          _Widget(controller: TextEditingController(text: 'initial')));
      final pageObject = createPageObject(t);
      expect(pageObject.textValue, 'initial');
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
