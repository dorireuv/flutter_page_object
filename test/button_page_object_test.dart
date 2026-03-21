import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

enum _Type {
  elevated(ElevatedButton.new),
  text(TextButton.new),
  icon(_buildIconButton),
  material(MaterialButton.new),
  cupertino(CupertinoButton.new),
  fab(FloatingActionButton.new),
  rawMaterial(RawMaterialButton.new),
  ;

  final _Constructor constructor;

  const _Type(this.constructor);
}

void main() {
  for (final type in _Type.values) {
    group('$type', () => _ButtonTest(type).runTests());
  }

  testWidgets('unsupported widget --> throws', (t) async {
    await t
        .pumpWidget(const MaterialApp(home: Scaffold(body: Column(key: aKey))));
    final pageObject = ButtonPageObject(t, aFinder);
    expect(() => pageObject.widget(), throwsStateError);
  });
}

class _ButtonTest {
  final _Type type;

  _ButtonTest(this.type);

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

    group('isDisabled', () {
      testWidgets('disabled --> true', (t) async {
        await t.pumpWidget(createWidget(isEnabled: false));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isTrue);
      });

      testWidgets('enabled --> false', (t) async {
        await t.pumpWidget(createWidget(isEnabled: true));
        final pageObject = createPageObject(t);
        expect(pageObject.isDisabled, isFalse);
      });
    });
  }
}

class _Widget extends StatelessWidget {
  final _Type type;
  final bool isEnabled;

  const _Widget({
    required this.type,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: _button()));
  }

  Widget _button() {
    return type.constructor(
      key: aKey,
      onPressed: isEnabled ? () {} : null,
      child: const Text('Button'),
    );
  }
}

typedef _Constructor = Widget Function({
  Key? key,
  required VoidCallback? onPressed,
  required Widget child,
});

Widget _buildIconButton({
  Key? key,
  required VoidCallback? onPressed,
  required Widget child,
}) {
  return IconButton(
    key: key,
    onPressed: onPressed,
    icon: child,
  );
}
