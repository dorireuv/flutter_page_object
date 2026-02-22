import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

enum _ButtonType {
  elevated(ElevatedButton.new),
  text(TextButton.new),
  ;

  final _ButtonConstructor constructor;

  const _ButtonType(this.constructor);
}

void main() {
  group('ElevatedButton', () {
    _ElevatedButtonTestImpl().runTests();
  });

  group('TextButton', () {
    _TextButtonTestImpl().runTests();
  });
}

class _ElevatedButtonTestImpl extends _ButtonTest {
  @override
  _ButtonType get type => _ButtonType.elevated;
}

class _TextButtonTestImpl extends _ButtonTest {
  @override
  _ButtonType get type => _ButtonType.text;
}

abstract class _ButtonTest {
  _ButtonType get type;

  ButtonPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).button(aFinder);

  _Widget createWidget({required bool isEnabled}) =>
      _Widget(type: type, isEnabled: isEnabled);

  void runTests() {
    group('isEnabled', () {
      testWidgets('enabled --> true', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
        final pageObject = createPageObject(t);
        expect(pageObject.isEnabled, isTrue);
      });

      testWidgets('disabled --> false', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        expect(pageObject.isEnabled, isFalse);
      });
    });
  }
}

class _Widget extends StatelessWidget {
  final _ButtonType type;
  final bool isEnabled;

  const _Widget({
    required this.type,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(child: _button());
  }

  Widget _button() {
    return type.constructor(
      key: aKey,
      onPressed: isEnabled ? () {} : null,
      child: const Text('Button'),
    );
  }
}

typedef _ButtonConstructor = Widget Function({
  Key? key,
  required VoidCallback? onPressed,
  required Widget child,
});
