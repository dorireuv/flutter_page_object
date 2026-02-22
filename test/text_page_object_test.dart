import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

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

    testWidgets('TextSpan --> null', (t) async {
      await t.pumpWidget(const _TextSpan());
      final pageObject = createPageObject(t);
      expect(pageObject.text, isNull);
    });
  });

  group('textOrEmpty', () {
    testWidgets('Text non-empty --> text', (t) async {
      await t.pumpWidget(const _Widget(text: 'text'));
      final pageObject = createPageObject(t);
      expect(pageObject.textOrEmpty, 'text');
    });

    testWidgets('Text empty --> empty', (t) async {
      await t.pumpWidget(const _Widget(text: ''));
      final pageObject = createPageObject(t);
      expect(pageObject.textOrEmpty, isEmpty);
    });

    testWidgets('TextSpan --> empty', (t) async {
      await t.pumpWidget(const _TextSpan());
      final pageObject = createPageObject(t);
      expect(pageObject.textOrEmpty, isEmpty);
    });
  });

  group('textSpanPlainText', () {
    testWidgets('Text --> null', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);
      expect(pageObject.textSpanPlainText, isNull);
    });

    testWidgets('TextSpan non-empty --> content', (t) async {
      await t.pumpWidget(const _TextSpan(text: 'text'));
      final pageObject = createPageObject(t);
      expect(pageObject.textSpanPlainText, 'text');
    });

    testWidgets('TextSpan empty --> empty', (t) async {
      await t.pumpWidget(const _TextSpan(text: ''));
      final pageObject = createPageObject(t);
      expect(pageObject.textSpanPlainText, '');
    });
  });

  group('textSpanPlainTextOrEmpty', () {
    testWidgets('Text --> empty', (t) async {
      await t.pumpWidget(const _Widget(text: ''));
      final pageObject = createPageObject(t);
      expect(pageObject.textSpanPlainTextOrEmpty, isEmpty);
    });

    testWidgets('TextSpan non-empty --> content', (t) async {
      await t.pumpWidget(const _TextSpan(text: 'text'));
      final pageObject = createPageObject(t);
      expect(pageObject.textSpanPlainTextOrEmpty, 'text');
    });

    testWidgets('TextSpan empty --> empty', (t) async {
      await t.pumpWidget(const _TextSpan(text: ''));
      final pageObject = createPageObject(t);
      expect(pageObject.textSpanPlainTextOrEmpty, '');
    });
  });
}

class _Widget extends StatelessWidget {
  final String text;

  const _Widget({this.text = 'foo'});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(child: Text(key: aKey, text));
  }
}

class _TextSpan extends StatelessWidget {
  final String text;

  const _TextSpan({this.text = 'foo'});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
        child: Text.rich(key: aKey, TextSpan(text: text)));
  }
}
