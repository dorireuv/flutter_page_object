import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_page_object/src/typed_text_input_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

enum _Type {
  typedTextField,
  typedTextFormField,
}

void main() {
  for (final type in _Type.values) {
    group('$type', () => _TextInputTest(type).runTests());
  }
}

class _TextInputTest {
  final _Type type;

  _TextInputTest(this.type);

  TypedTextInputPageObject<bool?> createPageObject(WidgetTester t) {
    switch (type) {
      case _Type.typedTextField:
        return PageObjectFactory.root(t).typedTextField(aFinder,
            formatter: (v) => v.toString(), parser: bool.tryParse);

      case _Type.typedTextFormField:
        return PageObjectFactory.root(t).typedTextFormField(aFinder,
            formatter: (v) => v.toString(), parser: bool.tryParse);
    }
  }

  void runTests() {
    group('text', () {
      testWidgets('not set without initial value --> empty', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createPageObject(t);
        expect(pageObject.text, '');
      });

      testWidgets('not set with initial value --> initial value', (t) async {
        await t.pumpWidget(_Widget(type: type, initialValue: 'initialValue'));
        final pageObject = createPageObject(t);
        expect(pageObject.text, 'initialValue');
      });

      testWidgets('enterText', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createPageObject(t);

        await pageObject.enterText('text');

        expect(pageObject.text, 'text');
      });
    });

    group('submitText', () {
      testWidgets('without value --> submits current value', (t) async {
        String? submittedValue;
        await t.pumpWidget(_Widget(
          type: type,
          initialValue: 'initial',
          onSubmitted: (v) => submittedValue = v,
        ));
        final pageObject = createPageObject(t);

        await pageObject.tap();
        await pageObject.submitText();

        expect(submittedValue, 'initial');
      });

      testWidgets('with value --> enters and submits given value', (t) async {
        String? submittedValue;
        await t.pumpWidget(_Widget(
          type: type,
          onSubmitted: (v) => submittedValue = v,
        ));
        final pageObject = createPageObject(t);

        await pageObject.submitText('new value');

        expect(pageObject.text, 'new value');
        expect(submittedValue, 'new value');
      });
    });

    group('doAction', () {
      testWidgets('performs the given action', (t) async {
        String? submittedValue;
        await t.pumpWidget(_Widget(
          type: type,
          initialValue: 'initial',
          onSubmitted: (v) => submittedValue = v,
          textInputAction: TextInputAction.go,
        ));
        final pageObject = createPageObject(t);

        await pageObject.tapAndPump();
        await pageObject.doAction(TextInputAction.go);

        expect(submittedValue, 'initial');
      });
    });

    group('value', () {
      testWidgets('without initial value --> null', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createPageObject(t);

        expect(pageObject.value, null);
      });

      testWidgets('with valid initial value --> initial value', (t) async {
        await t.pumpWidget(_Widget(type: type, initialValue: true.toString()));
        final pageObject = createPageObject(t);

        expect(pageObject.value, true);
      });

      testWidgets('with invalid initial value --> null', (t) async {
        await t.pumpWidget(_Widget(type: type, initialValue: 'invalid'));
        final pageObject = createPageObject(t);

        expect(pageObject.value, null);
      });

      testWidgets('enterValue', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createPageObject(t);

        await pageObject.enterValue(true);

        expect(pageObject.value, true);
      });
    });

    testWidgets('submit -->  submits current value', (t) async {
      String? submittedValue;
      await t.pumpWidget(_Widget(
        type: type,
        initialValue: 'initial',
        onSubmitted: (v) => submittedValue = v,
      ));
      final pageObject = createPageObject(t);

      await pageObject.tap();
      await pageObject.submit();

      expect(submittedValue, 'initial');
    });

    testWidgets('submitValue --> enters and submits given value', (t) async {
      String? submittedValue;
      await t.pumpWidget(_Widget(
        type: type,
        onSubmitted: (v) => submittedValue = v,
      ));
      final pageObject = createPageObject(t);

      await pageObject.submitValue(true);

      expect(pageObject.value, true);
      expect(submittedValue, 'true');
    });

    group('doAction', () {
      testWidgets('performs the given action', (t) async {
        String? submittedValue;
        await t.pumpWidget(_Widget(
          type: type,
          initialValue: 'initial',
          onSubmitted: (v) => submittedValue = v,
          textInputAction: TextInputAction.go,
        ));
        final pageObject = createPageObject(t);

        await pageObject.tapAndPump();
        await pageObject.doAction(TextInputAction.go);

        expect(submittedValue, 'initial');
      });
    });

    group('hasFocus', () {
      testWidgets('initially --> false', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createPageObject(t);
        expect(pageObject.hasFocus, isFalse);
      });

      testWidgets('after tap --> true', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createPageObject(t);

        await pageObject.tapAndPump();

        expect(pageObject.hasFocus, isTrue);
      });

      testWidgets('after tap and unfocus --> false', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createPageObject(t);

        await pageObject.tapAndPump();
        FocusManager.instance.primaryFocus!.unfocus();

        expect(pageObject.hasFocus, isTrue);
      });
    });
  }
}

class _Widget extends StatelessWidget {
  final _Type type;
  final String? initialValue;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  const _Widget({
    required this.type,
    this.initialValue,
    this.onSubmitted,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (type) {
      case _Type.typedTextField:
        final ctrl = (initialValue != null
            ? TextEditingController(text: initialValue)
            : null);
        child = TextField(
          key: aKey,
          controller: ctrl,
          onSubmitted: onSubmitted,
          textInputAction: textInputAction,
        );
        break;
      case _Type.typedTextFormField:
        child = TextFormField(
          key: aKey,
          initialValue: initialValue,
          onFieldSubmitted: onSubmitted,
          textInputAction: textInputAction,
        );
        break;
    }

    return MaterialApp(home: Scaffold(body: child));
  }
}
