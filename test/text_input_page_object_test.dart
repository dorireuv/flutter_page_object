import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
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

  TextInputPageObject<String> createStringPageObject(WidgetTester t) =>
      createStringPageObjectBuilder(t)(aFinder);

  _StringTextInputPageObjectBuilder createStringPageObjectBuilder(
      WidgetTester t) {
    switch (type) {
      case _Type.textField:
        return PageObjectFactory.root(t).textField;
      case _Type.textFormField:
        return PageObjectFactory.root(t).textFormField;
    }
  }

  TextInputPageObject<bool> createBoolPageObject(WidgetTester t) =>
      createBoolPageObjectBuilder(t)(
        aFinder,
        formatter: (v) => v.toString(),
        parser: bool.tryParse,
      );

  _TextInputPageObjectBuilder createBoolPageObjectBuilder(WidgetTester t) {
    switch (type) {
      case _Type.textField:
        return PageObjectFactory.root(t).customTextField;

      case _Type.textFormField:
        return PageObjectFactory.root(t).customTextFormField;
    }
  }

  void runTests() {
    group('text / textValue', () {
      testWidgets('not set without initial value --> empty', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createStringPageObject(t);

        expect(pageObject.textValue, '');
        expect(pageObject.text, '');
      });

      testWidgets('not set with initial value --> initial value', (t) async {
        await t.pumpWidget(_Widget(type: type, initialValue: 'initialValue'));
        final pageObject = createStringPageObject(t);

        expect(pageObject.textValue, 'initialValue');
        expect(pageObject.text, 'initialValue');
      });

      testWidgets('enterText without controller', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createStringPageObject(t);

        await pageObject.enterText('text');

        expect(pageObject.textValue, 'text');
        expect(pageObject.text, 'text');
      });

      testWidgets('enterText with controller', (t) async {
        await t.pumpWidget(
            _Widget(type: type, controller: TextEditingController()));
        final pageObject = createStringPageObject(t);

        await pageObject.enterText('text');

        expect(pageObject.textValue, 'text');
        expect(pageObject.text, 'text');
      });
    });

    group('value', () {
      testWidgets('without initial value --> null', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createBoolPageObject(t);

        expect(pageObject.value, null);
      });

      testWidgets('with valid initial value --> initial value', (t) async {
        await t.pumpWidget(_Widget(type: type, initialValue: true.toString()));
        final pageObject = createBoolPageObject(t);

        expect(pageObject.value, true);
      });

      testWidgets('with invalid initial value --> null', (t) async {
        await t.pumpWidget(_Widget(type: type, initialValue: 'invalid'));
        final pageObject = createBoolPageObject(t);

        expect(pageObject.value, null);
      });

      testWidgets('setValue', (t) async {
        await t.pumpWidget(_Widget(type: type));
        final pageObject = createBoolPageObject(t);

        await pageObject.setValue(true);

        expect(pageObject.value, true);
      });
    });

    group('submit', () {
      testWidgets('without value --> submits current value', (t) async {
        String? submittedValue;
        await t.pumpWidget(_Widget(
          type: type,
          initialValue: 'initial',
          onSubmitted: (v) => submittedValue = v,
        ));
        final pageObject = createStringPageObject(t);

        await pageObject.tap();
        await pageObject.submit();

        expect(submittedValue, 'initial');
      });

      testWidgets('with value --> enters and submits given value', (t) async {
        String? submittedValue;
        await t.pumpWidget(_Widget(
          type: type,
          onSubmitted: (v) => submittedValue = v,
        ));
        final pageObject = createStringPageObject(t);

        await pageObject.submit('new value');

        expect(pageObject.textValue, 'new value');
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
        final pageObject = createStringPageObject(t);

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

typedef _StringTextInputPageObjectBuilder = TextInputPageObject<String>
    Function(Finder key);

typedef _TextInputPageObjectBuilder
    = TextInputPageObject<T> Function<T extends Object>(Finder key,
        {required String Function(T v) formatter,
        required T? Function(String v) parser});
