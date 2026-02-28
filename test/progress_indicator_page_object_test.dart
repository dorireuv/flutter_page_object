import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  ProgressIndicatorPageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).progressIndicator(aFinder);

  group('value', () {
    testWidgets('determinate --> returns value', (t) async {
      await t.pumpWidget(const _Widget(value: 0.5));
      final pageObject = createPageObject(t);
      expect(pageObject.value, 0.5);
    });

    testWidgets('indeterminate --> returns null', (t) async {
      await t.pumpWidget(const _Widget(value: null));
      final pageObject = createPageObject(t);
      expect(pageObject.value, isNull);
    });
  });
}

class _Widget extends StatelessWidget {
  final double? value;

  const _Widget({this.value = 0.0});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: LinearProgressIndicator(key: aKey, value: value),
    );
  }
}
