import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  const aTargetKey = Key('target');

  NavButtonPageObject<WidgetPageObject> createPageObject(
          WidgetTester t, Key targetKey) =>
      PageObjectFactory.root(t).navButton(
          aFinder, PageObjectFactory.root(t).byKey.widget(targetKey));

  group('tapNavAndSettle', () {
    testWidgets('navigates to target and returns it', (t) async {
      await t.pumpWidget(const _Widget(targetKey: aTargetKey));

      final pageObject = createPageObject(t, aTargetKey);
      final res = await pageObject.tapNavAndSettle(expectTarget: false);

      expect(res, findsOne);
    });

    testWidgets('expectTarget is true, throws if target not found', (t) async {
      await t.pumpWidget(
          const _Widget(targetKey: aTargetKey, shouldNavigate: false));
      final pageObject = createPageObject(t, aTargetKey);
      await expectLater(() => pageObject.tapNavAndSettle(expectTarget: true),
          _throwsTestFailure);
    });
  });

  group('tapNavAndPump', () {
    testWidgets('tapNavAndPump navigates with a single pump', (t) async {
      await t.pumpWidget(const _Widget(targetKey: aTargetKey));

      final pageObject = createPageObject(t, aTargetKey);
      final res = await pageObject.tapNavAndPump(expectTarget: false);

      expect(res, findsNothing); // Animation is not finished yet
      await t.pump(); // Finish the animation
      expect(res, findsOne);
    });

    testWidgets('expectTarget is true, throws if target not found', (t) async {
      await t.pumpWidget(
          const _Widget(targetKey: aTargetKey, shouldNavigate: false));
      final pageObject = createPageObject(t, aTargetKey);
      await expectLater(() => pageObject.tapNavAndPump(expectTarget: true),
          _throwsTestFailure);
    });
  });

  group('tapNav', () {
    testWidgets('tapNav navigates', (t) async {
      await t.pumpWidget(const _Widget(targetKey: aTargetKey));

      final pageObject = createPageObject(t, aTargetKey);
      final res = await pageObject.tapNav(expectTarget: false);

      expect(res, findsNothing); // Animation is not finished yet
      await t.pump(); // Start the animation
      expect(res, findsNothing); // Animation is not finished yet
      await t.pump(); // Finish the animation
      expect(res, findsOne);
    });
  });

  testWidgets('expectTarget is true, throws if target not found', (t) async {
    await t.pumpWidget(
        const _Widget(targetKey: aTargetKey, shouldNavigate: false));
    final pageObject = createPageObject(t, aTargetKey);
    await expectLater(
        () => pageObject.tapNav(expectTarget: true), _throwsTestFailure);
  });
}

class _Widget extends StatelessWidget {
  final Key targetKey;
  final bool shouldNavigate;

  const _Widget({
    required this.targetKey,
    this.shouldNavigate = true,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: Builder(
        builder: (context) => ElevatedButton(
          key: aKey,
          onPressed: () {
            if (shouldNavigate) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => Scaffold(key: targetKey)));
            }
          },
          child: const Text('Navigate'),
        ),
      ),
    );
  }
}

final _throwsTestFailure = throwsA(isA<TestFailure>());
