# flutter_page_object [![codecov](https://codecov.io/github/dorireuv/flutter_page_object/graph/badge.svg?token=V0PNS1FO5W)](https://codecov.io/github/dorireuv/flutter_page_object)

Flutter library allowing to write page objects for your application using the [PageObject](https://martinfowler.com/bliki/PageObject.html) pattern. Using it make your tests easier to write, read and maintain.

## Usage
See [example](example) for a complete example.

Let's take a look on an example of a login page in your app.

You can create a `LoginPageObject` which will look like [this](example/test_common/lib/login_page_object.dart):
```dart
class LoginPageObject extends PageObject {
  late final username = d.textFormField(_usernameFinder);
  late final password = d.textFormField(_passwordFinder);
  late final loginButton = d.navButton(_loginButtonFinder, HomePageObject.new);

  LoginPageObject(WidgetTester t) : super(t, _finder);
}
```

While your tests will look like [this](example/test/login_page_test.dart):
```dart
testWidgets('form completed and tap login button --> navigates to home page', (t) async {
  await t.pumpWidget(const App());
  final loginPage = LoginPageObject(t);

  await loginPage.username.enterText('username');
  await loginPage.password.enterText('password');
  await t.pump();
  final homePage = await loginPage.loginButton.tapNavAndSettle();

  expect(homePage, findsOne);
  expect(homePage.greetingText, findsOne);
});
```

## Creating your own page object
You can create your own page object by simply extending the [PageObject](lib/src/page_object.dart) base class.

## Supported page objects
 - [BottomNavigationBarPageObject](lib/src/bottom_navigation_bar_page_object.dart) - For `BottomNavigationBar` widget.
 - [ButtonPageObject](lib/src/button_page_object.dart) - For button widgets such as `ElevatedButton` / `TextButton` / `IconButton` / `CupertinoButton` / `FloatingActionButton`.
 - [CheckboxPageObject](lib/src/checkbox_page_object.dart) - For checkbox widgets such as `Checkbox` / `CheckboxListTile` / `CupertinoCheckbox`.
 - [ChipPageObject](lib/src/chip_page_object.dart) - For chip widgets such as `ChoiceChip` / `InputChip` / `FilterChip` / `RawChip`.
 - [DrawerPageObject](lib/src/drawer_page_object.dart) - For `Drawer` widget.
 - [DropdownPageObject](lib/src/dropdown_page_object.dart) - For dropdown widgets such as  `DropdownButton` / `DropdownButtonFormField`.
 - [ImagePageObject](lib/src/image_page_object.dart) - For `Image` widget.
 - [NavButtonPageObject](lib/src/nav_button_page_object.dart) - For button widgets which navigate to another route.
 - [ProgressIndicatorPageObject](lib/src/progress_indicator_page_object.dart) - For `ProgressIndicator` widget.
 - [RadioGroupPageObject](lib/src/radio_group_page_object.dart) - For radio group.
 - [RadioPageObject](lib/src/radio_page_object.dart) - For radio widgets such as `Radio` / `RadioListTile` / `CupertinoRadio`.
 - [ScrollableListPageObject](lib/src/scrollable_list_page_object.dart) - For scrollable list widgets such as `ListView` / `GridView`.
 - [ScrollablePageObject](lib/src/scrollable_page_object.dart) - For scrollable widgets such as `SingleChildScrollView` / `ListView`. The is also `IsScrollable` mixin if your page object is scrollable.
 - [SlidablePageObject](lib/src/slidable_page_object.dart) - For slidable widgets such as `PageView` / `TabView`. There is `IsSlidable` mixin if your page object is slidable.
 - [SliderPageObject](lib/src/slider_page_object.dart) - For `Slider` widget.
 - [SnackBarPageObject](lib/src/snack_bar_page_object.dart) - For `SnackBar` widget.
 - [SwitchPageObject](lib/src/switch_page_object.dart) - For switch widgets such as `Switch` / `SwitchListTile` / `CupertinoSwitch`.
 - [TabBarPageObject](lib/src/tab_bar_page_object.dart) - For `TabBar` widget.
 - [TextFieldPageObject](lib/src/text_field_page_object.dart) - For `TextField` widget.
 - [TextFormFieldPageObject](lib/src/text_form_field_page_object.dart) - For `TextFormField` widget.
 - [TextPageObject](lib/src/text_page_object.dart) - For `Text` / `RichText` widget.
 - [TristateCheckboxPageObject](lib/src/tristate_checkbox_page_object.dart) - For checkbox widgets which are in tristate mode such as `Checkbox` / `CheckboxListTile` / `CupertinoCheckbox`.
 - [`TypedTextFieldPageObject`](lib/src/typed_text_field_page_object.dart) - For `TextField` widgets whose text can be parsed into a typed value.
 - [`TypedTextFormFieldPageObject`](lib/src/typed_text_form_field_page_object.dart) - For `TextFormField` widgets whose text can be parsed into a typed value.
 - [`TypedTextPageObject`](lib/src/typed_text_page_object.dart) - For `Text` / `RichText` widgets whose text can be parsed into a typed value.
 - [WidgetListPageObject](lib/src/widget_list_page_object.dart) - For list of widgets such as `Column` / `Row`.
 - [WidgetPageObject](lib/src/widget_page_object.dart) - Generic page object for any widget.

## Contribution
Your contribution is more than welcome, feel free to contact me on any matter.
