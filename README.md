# flutter_page_object
flutter_page_object is a Flutter library allowing to write page objects for
your application using the [PageObject](https://martinfowler.com/bliki/PageObject.html) pattern.
Using it make your tests easier to write, read and maintain.

## Usage

See `example` for a complete example.

Your tests will look like [this](example/test/login_page_test.dart):

```dart
testWidgets('tap login button and form completed --> logins', (t) async {
  await t.pumpWidget(const MaterialApp(home: LoginPage()));
  final loginPage = LoginPageObject(t);

  await loginPage.completeForm();
  final homePage = await loginPage.loginButton.tapNavAndSettle();

  expect(homePage, findsOne);
  expect(homePage.greetingText, findsOne);
});
```

While the page object will look like [this](example/test_common/lib/login_page_object.dart):

```dart
class LoginPageObject extends PageObject {
  late final username = d.byKey.stringTextFormField(const Key('username'));
  late final password = d.byKey.stringTextFormField(const Key('password'));
  late final loginButton =
      d.byKey.navButton(const Key('login_button'), HomePageObject(t));

  LoginPageObject(WidgetTester t) : super(t, _finder);

  Future<void> completeForm(
      {String username = 'username', String password = 'password'}) async {
    await this.username.setText(username);
    await this.password.setText(password);
    await t.pump();
  }
}
```

## Creating your own page object
You can create your own page object by simply extending the [PageObject](lib/src/page_object.dart) base class.