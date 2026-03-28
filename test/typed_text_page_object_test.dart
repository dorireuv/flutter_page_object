import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  TypedTextPageObject<bool?> createBoolPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).typedText(aFinder, parser: bool.tryParse);

  group('value', () {
    testWidgets('invalid --> null', (t) async {
      await t.pumpWidget(const _Text(text: 'invalid'));
      final pageObject = createBoolPageObject(t);
      expect(pageObject.value, isNull);
    });

    testWidgets('valid --> parsed value', (t) async {
      await t.pumpWidget(const _Text(text: 'true'));
      final pageObject = createBoolPageObject(t);
      expect(pageObject.value, isTrue);
    });
  });
}

class _Text extends StatelessWidget {
  final String text;

  const _Text({required this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Text(key: aKey, text));
  }
}
