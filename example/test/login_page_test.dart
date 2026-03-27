import 'package:example/app.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/login_page_object.dart';

void main() {
  testWidgets('form completed and tap login button --> navigates to home page',
      (t) async {
    await t.pumpWidget(const App());
    final loginPage = LoginPageObject(t);

    await loginPage.completeForm();
    expect(loginPage.loginButton.isEnabled, isTrue);
    final homePage = await loginPage.loginButton.tapNavAndSettle();

    expect(homePage, findsOne);
    expect(homePage.greetingText, findsOne);
  });

  testWidgets('username is empty --> login button disabled', (t) async {
    await t.pumpWidget(const App());
    final loginPage = LoginPageObject(t);
    await loginPage.completeForm();

    await loginPage.username.enterText('');
    await t.pump();

    expect(loginPage.loginButton.isEnabled, isFalse);
  });

  testWidgets('password is empty --> login button disabled', (t) async {
    await t.pumpWidget(const App());
    final loginPage = LoginPageObject(t);
    await loginPage.completeForm();

    await loginPage.password.enterText('');
    await t.pump();

    expect(loginPage.loginButton.isEnabled, isFalse);
  });
}
