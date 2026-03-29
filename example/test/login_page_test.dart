import 'package:example/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/login_page_object.dart';

void main() {
  testWidgets('form completed --> login button enabled', (t) async {
    await t.pumpWidget(const App());
    final loginPage = LoginPageObject(t);

    await loginPage.completeForm();

    expect(loginPage.loginButton.isEnabled, isTrue);
  });

  testWidgets('form completed and tap login button --> navigates to home page',
      (t) async {
    await t.pumpWidget(const App());
    final loginPage = LoginPageObject(t);

    await loginPage.completeForm();
    final homePage = await loginPage.loginButton.tapNavAndSettle();

    expect(homePage, findsOne);
  });

  testWidgets('username is empty --> login button disabled', (t) async {
    await t.pumpWidget(const App());
    final loginPage = LoginPageObject(t);
    await loginPage.completeForm();

    await loginPage.usernameTextField.enterText('');
    await t.pump();

    expect(loginPage.loginButton.isEnabled, isFalse);
  });

  testWidgets('password is empty --> login button disabled', (t) async {
    await t.pumpWidget(const App());
    final loginPage = LoginPageObject(t);
    await loginPage.completeForm();

    await loginPage.passwordTextField.enterText('');
    await t.pump();

    expect(loginPage.loginButton.isEnabled, isFalse);
  });
}
