import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  SlidablePageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).slidable(aFinder);

  group('swipeToTheStart', () {
    testWidgets('LTR --> swipes to the next page', (t) async {
      await t.pumpWidget(_Widget.ltr(
        pages: const [Text('0'), Text('1')],
        initialPage: 0,
      ));
      final pageObject = createPageObject(t);

      await pageObject.swipeToStart();

      expect(find.text('1'), findsOne);
    });

    testWidgets('RTL --> swipes to the next page', (t) async {
      await t.pumpWidget(_Widget.rtl(
        pages: const [Text('0'), Text('1')],
        initialPage: 0,
      ));
      final pageObject = createPageObject(t);

      await pageObject.swipeToStart();

      expect(find.text('1'), findsOne);
    });
  });

  group('swipeToTheEnd', () {
    testWidgets('LTR --> swipes to the previous page', (t) async {
      await t.pumpWidget(_Widget.ltr(
        pages: const [Text('0'), Text('1')],
        initialPage: 1,
      ));

      final pageObject = createPageObject(t);
      await pageObject.swipeToEnd();

      expect(find.text('0'), findsOne);
    });

    testWidgets('RTL --> swipes to the previous page', (t) async {
      await t.pumpWidget(_Widget.rtl(
        pages: const [Text('0'), Text('1')],
        initialPage: 1,
      ));

      final pageObject = createPageObject(t);
      await pageObject.swipeToEnd();

      expect(find.text('0'), findsOne);
    });
  });
}

class _Widget extends StatelessWidget {
  final Locale locale;
  final List<Widget> pages;
  final int initialPage;

  factory _Widget.ltr(
          {required List<Widget> pages, required int initialPage}) =>
      _Widget._(
          locale: const Locale('en'), pages: pages, initialPage: initialPage);

  factory _Widget.rtl(
          {required List<Widget> pages, required int initialPage}) =>
      _Widget._(
          locale: const Locale('he'), pages: pages, initialPage: initialPage);

  const _Widget._({
    required this.locale,
    required this.pages,
    required this.initialPage,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      locale: locale,
      child: SizedBox(
        width: 300,
        height: 300,
        child: PageView(
          key: aKey,
          controller: PageController(initialPage: initialPage),
          children: pages,
        ),
      ),
    );
  }
}
