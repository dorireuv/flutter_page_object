import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_page_object/src/text_input_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

enum _Type {
  textField,
  textFormField,
}

void main() {
  for (final type in _Type.values) {
    group('$type', () => _TextInputTest(type).runTests());
  }
}

class _TextInputTest {
  final _Type type;

  _TextInputTest(this.type);

  TextInputPageObject createPageObject(WidgetTester t) =>
      createPageObjectBuilder(t)(aFinder);

  _TextInputPageObjectBuilder createPageObjectBuilder(WidgetTester t) {
    switch (type) {
      case _Type.textField:
        return PageObjectFactory.root(t).textField;
      case _Type.textFormField:
        return PageObjectFactory.root(t).textFormField;
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

      testWidgets('enterText without controller', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createPageObject(t);

        await pageObject.enterText('text');

        expect(pageObject.text, 'text');
      });

      testWidgets('enterText with controller', (t) async {
        await t.pumpWidget(
            _Widget(type: type, controller: TextEditingController()));
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
  }
}

class _Widget extends StatelessWidget {
  final _Type type;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;

  const _Widget({
    required this.type,
    this.initialValue,
    this.controller,
    this.onSubmitted,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (type) {
      case _Type.textField:
        final ctrl = controller ??
            (initialValue != null
                ? TextEditingController(text: initialValue)
                : null);
        child = TextField(
          key: aKey,
          controller: ctrl,
          onSubmitted: onSubmitted,
          textInputAction: textInputAction,
        );
        break;
      case _Type.textFormField:
        child = TextFormField(
          key: aKey,
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onFieldSubmitted: onSubmitted,
          textInputAction: textInputAction,
        );
        break;
    }

    return MaterialApp(home: Scaffold(body: child));
  }
}

typedef _TextInputPageObjectBuilder = TextInputPageObject Function(Finder key);
