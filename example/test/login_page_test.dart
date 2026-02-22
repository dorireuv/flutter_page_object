import 'package:example/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/login_page_object.dart';

void main() {
  testWidgets('form completed --> login button enabled', (t) async {
    await t.pumpWidget(const MaterialApp(home: LoginPage()));
    final loginPage = LoginPageObject(t);

    await loginPage.completeForm();

    expect(loginPage.loginButton.isEnabled, isTrue);
  });

  testWidgets('username is empty --> login button disabled', (t) async {
    await t.pumpWidget(const MaterialApp(home: LoginPage()));
    final loginPage = LoginPageObject(t);
    await loginPage.completeForm();

    await loginPage.username.setText('');

    expect(loginPage.loginButton.isEnabled, isTrue);
  });

  testWidgets('password is empty --> login button disabled', (t) async {
    await t.pumpWidget(const MaterialApp(home: LoginPage()));
    final loginPage = LoginPageObject(t);
    await loginPage.completeForm();

    await loginPage.password.setText('');

    expect(loginPage.loginButton.isEnabled, isTrue);
  });

  testWidgets('tap login button and form completed --> logins', (t) async {
    await t.pumpWidget(const MaterialApp(home: LoginPage()));
    final loginPage = LoginPageObject(t);

    await loginPage.completeForm();
    final homePage = await loginPage.loginButton.tapNavAndSettle();

    expect(homePage, findsOne);
    expect(homePage.greetingText, findsOne);
  });
}
