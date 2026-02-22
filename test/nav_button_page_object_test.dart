import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  NavButtonPageObject<_TargetPageObject> createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).createStatic(_TestPageObject.new).button;

  group('tapNavAndSettle', () {
    testWidgets('navigates to target and returns it', (t) async {
      await t.pumpWidget(const _Widget());

      final pageObject = createPageObject(t);
      final res = await pageObject.tapNavAndSettle(expectTarget: false);

      expect(res, findsOne);
    });

    testWidgets('expectTarget is true, throws if target not found', (t) async {
      await t.pumpWidget(const _Widget(shouldNavigate: false));
      final pageObject = createPageObject(t);
      await expectLater(() => pageObject.tapNavAndSettle(expectTarget: true),
          _throwsTestFailure);
    });
  });

  group('tapNavAndPump', () {
    testWidgets('tapNavAndPump navigates with a single pump', (t) async {
      await t.pumpWidget(const _Widget());

      final pageObject = createPageObject(t);
      final res = await pageObject.tapNavAndPump(expectTarget: false);

      expect(res, findsNothing); // Animation is not finished yet
      await t.pump(); // Finish the animation
      expect(res, findsOne);
    });

    testWidgets('expectTarget is true, throws if target not found', (t) async {
      await t.pumpWidget(const _Widget(shouldNavigate: false));
      final pageObject = createPageObject(t);
      await expectLater(() => pageObject.tapNavAndPump(expectTarget: true),
          _throwsTestFailure);
    });
  });

  group('tapNav', () {
    testWidgets('tapNav navigates', (t) async {
      await t.pumpWidget(const _Widget());

      final pageObject = createPageObject(t);
      final res = await pageObject.tapNav(expectTarget: false);

      expect(res, findsNothing); // Animation is not finished yet
      await t.pump(); // Start the animation
      expect(res, findsNothing); // Animation is not finished yet
      await t.pump(); // Finish the animation
      expect(res, findsOne);
    });
  });

  testWidgets('expectTarget is true, throws if target not found', (t) async {
    await t.pumpWidget(const _Widget(shouldNavigate: false));
    final pageObject = createPageObject(t);
    await expectLater(
        () => pageObject.tapNav(expectTarget: true), _throwsTestFailure);
  });
}

class _TestPageObject extends PageObject {
  late final button = d.navButton(this, r.createStatic(_TargetPageObject.new));

  _TestPageObject(WidgetTester t) : super(t, aFinder);
}

class _TargetPageObject extends PageObject {
  _TargetPageObject(WidgetTester t) : super(t, _targetFinder);
}

class _Widget extends StatelessWidget {
  final bool shouldNavigate;

  const _Widget({this.shouldNavigate = true});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: Builder(
        builder: (context) => ElevatedButton(
          key: aKey,
          onPressed: () {
            if (shouldNavigate) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const Scaffold(key: _targetKey)));
            }
          },
          child: const Text('Navigate'),
        ),
      ),
    );
  }
}

const _targetKey = Key('target');
final _targetFinder = find.byKey(_targetKey);

final _throwsTestFailure = throwsA(isA<TestFailure>());
