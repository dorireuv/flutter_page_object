import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  TextPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).text(aFinder);

  group('text', () {
    testWidgets('Text non-empty --> text', (t) async {
      await t.pumpWidget(const _Widget(text: 'text'));
      final pageObject = createPageObject(t);
      expect(pageObject.text, 'text');
    });

    testWidgets('Text empty --> empty', (t) async {
      await t.pumpWidget(const _Widget(text: ''));
      final pageObject = createPageObject(t);
      expect(pageObject.text, isEmpty);
    });

    testWidgets('TextSpan non-empty --> content', (t) async {
      await t.pumpWidget(const _TextSpan(text: 'text'));
      final pageObject = createPageObject(t);
      expect(pageObject.text, 'text');
    });

    testWidgets('TextSpan empty --> empty', (t) async {
      await t.pumpWidget(const _TextSpan(text: ''));
      final pageObject = createPageObject(t);
      expect(pageObject.text, '');
    });

    testWidgets('RichText non-empty --> content', (t) async {
      await t.pumpWidget(const _RichText(text: 'text'));
      final pageObject = createPageObject(t);
      expect(pageObject.text, 'text');
    });

    testWidgets('RichText empty --> empty', (t) async {
      await t.pumpWidget(const _RichText(text: ''));
      final pageObject = createPageObject(t);
      expect(pageObject.text, '');
    });
  });
}

class _Widget extends StatelessWidget {
  final String text;

  const _Widget({this.text = 'foo'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Text(key: aKey, text));
  }
}

class _TextSpan extends StatelessWidget {
  final String text;

  const _TextSpan({this.text = 'foo'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Text.rich(key: aKey, TextSpan(text: text)));
  }
}

class _RichText extends StatelessWidget {
  final String text;

  const _RichText({this.text = 'foo'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RichText(key: aKey, text: TextSpan(text: text)));
  }
}
