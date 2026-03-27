import 'package:flutter/foundation.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/home_page_object.dart';

final _finder = find.byKey(const Key('login_page'));
final _usernameFinder = find.byKey(const Key('username'));
final _passwordFinder = find.byKey(const Key('password'));
final _loginButtonFinder = find.byKey(const Key('login_button'));

class LoginPageObject extends PageObject {
  late final username = d.textFormField(_usernameFinder);
  late final password = d.textFormField(_passwordFinder);
  late final loginButton = d.navButton(_loginButtonFinder, HomePageObject.new);

  LoginPageObject(WidgetTester t) : super(t, _finder);

  Future<void> completeForm() async {
    await username.enterText('username');
    await password.enterText('password');
    await t.pump();
  }
}
