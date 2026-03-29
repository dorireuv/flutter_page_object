import 'package:flutter/foundation.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/home_page_object.dart';

class LoginPageObject extends PageObject {
  late final usernameTextField = d.byKey.textFormField(const Key('username'));
  late final passwordTextField = d.byKey.textFormField(const Key('password'));
  late final loginButton = d.byKey
      .navButton(const Key('login_button'), targetBuilder: HomePageObject.new);

  LoginPageObject(WidgetTester t)
      : super(t, find.byKey(const Key('login_page')));

  Future<void> completeForm() async {
    await usernameTextField.enterText('test_user');
    await passwordTextField.enterText('password123');
    await t.pump();
  }

  Future<HomePageObject> login() async {
    await completeForm();
    return await loginButton.tapNavAndSettle();
  }
}
