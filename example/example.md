# Flutter Page Object Library Example

This example demonstrates how to use `flutter_page_object` in your Flutter application tests.

## Basic Usage
Let's take a look on an example of a login page in your app.

You can create a `LoginPageObject` which will look like [this](test_common/lib/login_page_object.dart):
```dart
class LoginPageObject extends PageObject {
  late final username = d.textFormField(_usernameFinder);
  late final password = d.textFormField(_passwordFinder);
  late final loginButton = d.navButton(_loginButtonFinder, HomePageObject.new);

  LoginPageObject(WidgetTester t) : super(t, _finder);
}
```

While your tests will look like [this](test/login_page_test.dart):
```dart
testWidgets('form completed and tap login button --> navigates to home page', (t) async {
  await t.pumpWidget(const App());
  final loginPage = LoginPageObject(t);

  await loginPage.username.setText('username');
  await loginPage.password.setText('password');
  await t.pump();
  final homePage = await loginPage.loginButton.tapNavAndSettle();

  expect(homePage, findsOne);
  expect(homePage.greetingText, findsOne);
});
```
