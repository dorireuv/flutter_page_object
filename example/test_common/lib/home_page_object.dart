import 'package:flutter/foundation.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

final _finder = find.byKey(const Key('home_page'));

class HomePageObject extends PageObject {
  late final greetingText = d.byKey.text(const Key('greeting_text'));

  HomePageObject(WidgetTester t) : super(t, _finder);
}
