# Flutter Page Object Library Example

This example demonstrates how to use `flutter_page_object` in your Flutter application tests.

## Basic Usage
Let's take a look on an example of a login page in your app.

You can create a `LoginPageObject` which will look like [this](test_common/lib/login_page_object.dart):
```dart
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
}
```

While your tests will look like [this](test/login_page_test.dart):
```dart
testWidgets('form completed and tap login button --> navigates to home page', (t) async {
  await t.pumpWidget(const App());
  final loginPage = LoginPageObject(t);

  await loginPage.completeForm();
  final homePage = await loginPage.loginButton.tapNavAndSettle();

  expect(homePage, findsOne);
});
```
