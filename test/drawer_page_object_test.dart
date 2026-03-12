import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  DrawerPageObject createPageObject(WidgetTester t) =>
      _WidgetPageObject(t, aFinder).drawer;

  group('isOpen', () {
    testWidgets('initially --> false', (t) async {
      await t.pumpWidget(const _Widget());

      final pageObject = createPageObject(t);

      expect(pageObject.isOpen, isFalse);
      expect(pageObject, findsNothing);
    });

    testWidgets('open --> true', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);

      await pageObject.open();

      expect(pageObject.isOpen, isTrue);
      expect(pageObject, findsOne);
    });

    testWidgets('open and close --> false', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = createPageObject(t);

      await pageObject.open();
      await pageObject.close();

      expect(pageObject.isOpen, isFalse);
      expect(pageObject, findsNothing);
    });
  });

  group('close', () {
    testWidgets('drawer covers the screen --> throws', (t) async {
      await t.restoreViewSize(() async {
        await t.pumpWidget(const _Widget());
        final pageObject = createPageObject(t);

        await pageObject.open();

        t.view.physicalSize = const Size(1, 1);
        t.view.devicePixelRatio = 1.0;

        await expectLater(
          () => pageObject.close(),
          throwsA(isA<TestFailure>().having(
            (e) => e.message,
            'message',
            contains('Could not find a tap location outside the drawer'),
          )),
        );
      });
    });
  });

  group('DrawerPageObjectFactoryExtension.drawer', () {
    testWidgets('non null key --> finds drawer', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject =
          PageObjectFactory.root(t).drawer(find.byKey(_drawerKey));

      await pageObject.open();

      expect(pageObject, findsOne);
    });

    testWidgets('null key --> fallbacks to default drawer', (t) async {
      await t.pumpWidget(const _Widget());
      final pageObject = PageObjectFactory.root(t).drawer(null);

      await pageObject.open();

      expect(pageObject, findsOne);
    });
  });
}

class _WidgetPageObject extends PageObject with HasDrawer {
  _WidgetPageObject(super.t, super.finder);
}

class _Widget extends StatelessWidget {
  const _Widget();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: aKey,
        body: const Text('data'),
        drawer: const Drawer(key: _drawerKey),
        appBar: AppBar(),
      ),
    );
  }
}

const _drawerKey = Key('drawer');
