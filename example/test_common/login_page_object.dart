import 'package:example/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginPageObject extends PageObject {
  LoginPageObject(WidgetTester t) : super(t, find.byType(LoginPage));

  TextFormFieldPageObject<String> get username =>
      descendantOf.byKey.stringTextFormField(const Key('username'));

  TextFormFieldPageObject<String> get password =>
      descendantOf.byKey.stringTextFormField(const Key('password'));

  ButtonPageObject get loginButton =>
      descendantOf.byKey.button(const Key('login_button'));
}
