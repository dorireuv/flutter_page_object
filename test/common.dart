import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const aKey = Key('key');
final aFinder = find.byKey(aKey);

extension RestoreViewSize on WidgetTester {
  Future<void> restoreViewSize(Future<void> Function() testBody) async {
    addTearDown(() => view.reset());
    await testBody();
  }

  Future<void> runWithViewSize(
      Size size, Future<void> Function() testBody) async {
    view.physicalSize = size;
    view.devicePixelRatio = 1.0;
    await restoreViewSize(testBody);
  }

  Future<void> runWithViewHeight(
          double height, Future<void> Function() testBody) =>
      runWithViewSize(Size(view.physicalSize.width, height), testBody);
}
