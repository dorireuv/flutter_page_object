import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  TextPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).text(aFinder);

  group('text', () {
    group('Text', () {
      testWidgets('null --> empty', (t) async {
        await t.pumpWidget(const MaterialApp(home: _NullText(key: aKey)));
        final pageObject = createPageObject(t);
        expect(pageObject.text, '');
      });

      testWidgets('non-null --> text', (t) async {
        await t.pumpWidget(const _Text(text: 'text'));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'text');
      });

      testWidgets('ignores semantics label', (t) async {
        await t.pumpWidget(
            const _Text(text: 'text', semanticsLabel: 'semanticsLabel'));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'text');
      });
    });

    group('TextSpan', () {
      testWidgets('null --> empty', (t) async {
        await t.pumpWidget(const _TextSpan(text: null));
        final pageObject = createPageObject(t);
        expect(pageObject.text, '');
      });

      testWidgets('non-null --> text', (t) async {
        await t.pumpWidget(const _TextSpan(text: 'text'));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'text');
      });

      testWidgets('ignores semantics label', (t) async {
        await t.pumpWidget(
            const _TextSpan(text: 'text', semanticsLabel: 'semanticsLabel'));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'text');
      });

      testWidgets('ignores placeholder', (t) async {
        await t.pumpWidget(const _TextSpan(text: null, children: [
          TextSpan(text: 'hello '),
          WidgetSpan(child: SizedBox()),
          TextSpan(text: 'world'),
        ]));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'hello world');
      });
    });

    group('RichText', () {
      testWidgets('null --> empty', (t) async {
        await t.pumpWidget(const _RichText(text: null));
        final pageObject = createPageObject(t);
        expect(pageObject.text, '');
      });

      testWidgets('non-null --> text', (t) async {
        await t.pumpWidget(const _RichText(text: 'text'));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'text');
      });

      testWidgets('ignores semantics label', (t) async {
        await t.pumpWidget(
            const _RichText(text: 'text', semanticsLabel: 'semanticsLabel'));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'text');
      });

      testWidgets('ignores placeholder', (t) async {
        await t.pumpWidget(const _RichText(text: null, children: [
          TextSpan(text: 'hello '),
          WidgetSpan(child: SizedBox()),
          TextSpan(text: 'world'),
        ]));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'hello world');
      });
    });
  });
}

class _Text extends StatelessWidget {
  final String text;
  final String? semanticsLabel;

  const _Text({this.text = 'foo', this.semanticsLabel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Text(key: aKey, text, semanticsLabel: semanticsLabel));
  }
}

class _TextSpan extends StatelessWidget {
  final String? text;
  final String? semanticsLabel;
  final List<InlineSpan>? children;

  const _TextSpan({this.text = 'foo', this.semanticsLabel, this.children});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Text.rich(
            key: aKey,
            TextSpan(
                text: text,
                semanticsLabel: semanticsLabel,
                children: children)));
  }
}

class _NullText extends Text {
  const _NullText({super.key}) : super('');

  @override
  String? get data => null;

  @override
  InlineSpan? get textSpan => null;
}

class _RichText extends StatelessWidget {
  final String? text;
  final String? semanticsLabel;
  final List<InlineSpan>? children;

  const _RichText({this.text = 'foo', this.semanticsLabel, this.children});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: RichText(
            key: aKey,
            text: TextSpan(
                text: text,
                semanticsLabel: semanticsLabel,
                children: children)));
  }
}
