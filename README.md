# flutter_page_object [![codecov](https://codecov.io/github/dorireuv/flutter_page_object/graph/badge.svg?token=V0PNS1FO5W)](https://codecov.io/github/dorireuv/flutter_page_object)

Flutter library allowing to write page objects for your application using the [PageObject](https://martinfowler.com/bliki/PageObject.html) pattern. Using it make your tests easier to write, read and maintain.

## Usage
See [example](example) for a complete example.

Your tests will look like [this](example/test/login_page_test.dart):

```dart
testWidgets('form completed and tap login button --> navigates to home page', (t) async {
  await t.pumpWidget(const MaterialApp(home: LoginPage()));
  final loginPage = LoginPageObject(t);

  await loginPage.completeForm();
  expect(loginPage.loginButton.isEnabled, isTrue);
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

  Future<void> completeForm() async {
    await username.setText('username');
    await password.setText('password');
    await t.pump();
  }
}
```

## Creating your own page object
You can create your own page object by simply extending the [PageObject](lib/src/page_object.dart) base class.

## Supported page objects
 - [ButtonPageObject](lib/src/button_page_object.dart) - For button widgets such as `ElevatedButton` / `TextButton` / `IconButton`.
 - [CheckboxPageObject](lib/src/checkbox_page_object.dart) - For checkbox widgets such as `Checkbox` / `CheckboxListTile`.
 - [DropdownPageObject](lib/src/dropdown_page_object.dart) - For dropdown widgets such as  `DropdownButton` / `DropdownButtonFormField`.
 - [NavButtonPageObject](lib/src/nav_button_page_object.dart) - For button widgets which navigate to another route.
 - [RadioGroupPageObject](lib/src/radio_group_page_object.dart) - For radio group.
 - [RadioPageObject](lib/src/radio_page_object.dart) - For radio widgets such as `Radio` / `RadioListTile`.
 - [ScrollableListPageObject](lib/src/scrollable_list_page_object.dart) - For scrollable list widgets such as `ListView` / `GridView`.
 - [ScrollablePageObject](lib/src/scrollable_page_object.dart) - For scrollable widgets such as `SingleChildScrollView` / `ListView`. The is also `IsScrollable` mixin if your page object is scrollable.
 - [SlidablePageObject](lib/src/slidable_page_object.dart) - For slidable widgets such as `PageView` / `TabView`. There is `IsSlidable` mixin if your page object is slidable.
 - [SliderPageObject](lib/src/slider_page_object.dart) - For slider widgets such as `Slider`. 
 - [SwitchPageObject](lib/src/switch_page_object.dart) - For switch widgets such as `Switch` / `SwitchListTile`.
 - [TextFormFieldPageObject](lib/src/text_form_field_page_object.dart) - For `TextFormField` widget.
 - [TristateCheckboxPageObject](lib/src/tristate_checkbox_page_object.dart) - For checkbox widgets which are in tristate mode such as `Checkbox` / `CheckboxListTile`.
 - [WidgetListPageObject](lib/src/widget_list_page_object.dart) - For list of widgets such as `Column` / `Row`.
 - [WidgetPageObject](lib/src/widget_page_object.dart) - Generic page object for any widget.

## Contribution
Your contribution is more than welcome, feel free to contact me on any matter.
