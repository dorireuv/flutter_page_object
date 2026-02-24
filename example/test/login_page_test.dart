import 'package:example/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/login_page_object.dart';

void main() {
  testWidgets('form completed and tap login button --> navigates to home page',
      (t) async {
    await t.pumpWidget(const MaterialApp(home: LoginPage()));
    final loginPage = LoginPageObject(t);

    await loginPage.completeForm();
    expect(loginPage.loginButton.isEnabled, isTrue);
    final homePage = await loginPage.loginButton.tapNavAndSettle();

    expect(homePage, findsOne);
    expect(homePage.greetingText, findsOne);
  });

  testWidgets('username is empty --> login button disabled', (t) async {
    await t.pumpWidget(const MaterialApp(home: LoginPage()));
    final loginPage = LoginPageObject(t);
    await loginPage.completeForm();

    await loginPage.username.setText('');
    await t.pump();

    expect(loginPage.loginButton.isEnabled, isFalse);
  });

  testWidgets('password is empty --> login button disabled', (t) async {
    await t.pumpWidget(const MaterialApp(home: LoginPage()));
    final loginPage = LoginPageObject(t);
    await loginPage.completeForm();

    await loginPage.password.setText('');
    await t.pump();

    expect(loginPage.loginButton.isEnabled, isFalse);
  });
}
