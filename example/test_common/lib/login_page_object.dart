import 'package:flutter/foundation.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/home_page_object.dart';

final _finder = find.byKey(const Key('login_page'));

class LoginPageObject extends PageObject {
  late final username = d.byKey.stringTextFormField(const Key('username'));
  late final password = d.byKey.stringTextFormField(const Key('password'));
  late final loginButton =
      d.byKey.navButton(const Key('login_button'), HomePageObject(t));

  LoginPageObject(WidgetTester t) : super(t, _finder);

  Future<void> completeForm() async {
    await username.setText('username');
    await password.setText('password');
    await t.pump();
  }
}
