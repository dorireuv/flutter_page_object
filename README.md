# flutter_page_object [![codecov](https://codecov.io/github/dorireuv/flutter_page_object/graph/badge.svg?token=V0PNS1FO5W)](https://codecov.io/github/dorireuv/flutter_page_object)

Flutter library for writing page objects using the [PageObject](https://martinfowler.com/bliki/PageObject.html) pattern. Makes your tests easier to write, read, and maintain.

## 📖 Table of Contents

- [flutter\_page\_object ](#flutter_page_object-)
  - [📖 Table of Contents](#-table-of-contents)
  - [⚡ Quick Start](#-quick-start)
  - [📚 Common Patterns](#-common-patterns)
    - [Find by Key (Recommended)](#find-by-key-recommended)
    - [Descendant Search (recommended for complex pages)](#descendant-search-recommended-for-complex-pages)
    - [Common Interactions](#common-interactions)
  - [📋 Supported Widgets](#-supported-widgets)
    - [Base PageObject](#base-pageobject)
    - [Text Input Widgets](#text-input-widgets)
    - [Selection Widgets](#selection-widgets)
    - [Navigation Widgets](#navigation-widgets)
    - [Display Widgets](#display-widgets)
    - [Layout \& Scrolling](#layout--scrolling)
    - [Other](#other)
  - [🎯 Creating Your Own Page Object](#-creating-your-own-page-object)
  - [📖 Full Examples](#-full-examples)
  - [🤝 Contribution](#-contribution)

## ⚡ Quick Start

**Install:**
```yaml
dev_dependencies:
  flutter_page_object: ^1.0.0
```

**Your first page object:**
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

**Your first test:**
```dart
testWidgets('form completed and tap login button --> navigates to home page', (t) async {
  await t.pumpWidget(const App());
  final loginPage = LoginPageObject(t);

  await loginPage.completeForm();
  final homePage = await loginPage.loginButton.tapNavAndSettle();

  expect(homePage, findsOne);
});
```

**Why this is better** than raw finders:
- ✅ **Readable**: Tests read like user actions, not implementation details
- ✅ **Maintainable**: Change selector in one place; all tests automatically work
- ✅ **Reusable**: Define once, use across dozens of tests
- ✅ **Centralized**: All widget interactions in one place per page

## 📚 Common Patterns

### Find by Key (Recommended)
```dart
late final submitButton = d.byKey.button(const Key('submit_button'));
late final emailTextField = d.byKey.textFormField(const Key('email_text_field'));
```

### Descendant Search (recommended for complex pages)
```dart
// Find descendants of this page object (searches within this widget's subtree)
late final title = d.byKey.text(const Key('title'));

// Search from root instead of descendants
late final snackBar = r.byType.snackBar(SnackBar);
```

### Common Interactions
```dart
// Tap and wait for UI to settle
await button.tapAndSettle();

// Enter text
await textField.enterText('hello');

// Toggle switch/checkbox
await toggle.set(true);

// Select dropdown item
await dropdown.select(Category.food);

// Get values
final text = textField.text;
final isEnabled = button.isEnabled;
final isChecked = checkbox.value;
```

## 📋 Supported Widgets

### Base PageObject

All page objects extend [PageObject](lib/src/page_object.dart) and inherit these base interactions and properties:

```dart
// Interactions
Future<void> tap()
Future<void> tapAndPump()
Future<void> tapAndSettle()
Future<void> longPress()
Future<void> longPressAndPump()
Future<void> longPressAndSettle()
Future<void> drag(Offset offset)
Future<void> dragAndPump(Offset offset)

// Waiting
Future<void> waitUntilHitTestable({Duration timeout})
Future<void> waitWhileHitTestable({Duration timeout})

// Accessors
T widget<T extends Widget>()
T state<T extends State>()

// Properties
bool get isHitTestable
late final root           // Access page objects from root
late final descendant     // Access descendant page objects
```

**Shortcuts:**
- Use `r` as shorthand for `root`: `r.byKey.button(const Key('submit'))`
- Use `d` as shorthand for `descendant`: `d.byKey.textField(const Key('email'))`

### Text Input Widgets

* **[TextFieldPageObject](lib/src/text_field_page_object.dart)** (`TextField`)
  ```dart
  String get text
  Future<void> enterText(String)
  Future<void> submitText([String?])
  ```
* **[TextFormFieldPageObject](lib/src/text_form_field_page_object.dart)** (`TextFormField`)
  ```dart
  String get text
  Future<void> enterText(String)
  Future<void> submitText([String?])
  ```
* **[TypedTextFieldPageObject\<T\>](lib/src/typed_text_field_page_object.dart)** (`TextField` - typed)
  ```dart
  String get text
  T get value
  Future<void> enterText(String)
  Future<void> enterValue(T)
  Future<void> submitText([String?])
  Future<void> submit()
  Future<void> submitValue(T)
  ```
* **[TypedTextFormFieldPageObject\<T\>](lib/src/typed_text_form_field_page_object.dart)** (`TextFormField` - typed)
  ```dart
  String get text
  T get value
  Future<void> enterText(String)
  Future<void> enterValue(T)
  Future<void> submitText([String?])
  Future<void> submit()
  Future<void> submitValue(T)
  ```

### Selection Widgets

* **[CheckboxPageObject](lib/src/checkbox_page_object.dart)** (`Checkbox`, `CheckboxListTile`, `CupertinoCheckbox`)
  ```dart
  bool get value
  bool get isEnabled
  bool get isDisabled
  Future<void> check()
  Future<void> uncheck()
  Future<void> set(bool)
  ```
* **[TristateCheckboxPageObject](lib/src/tristate_checkbox_page_object.dart)** (`Checkbox`, `CheckboxListTile`, `CupertinoCheckbox` - tristate)
  ```dart
  bool? get value
  bool get isEnabled
  bool get isDisabled
  Future<void> check()
  Future<void> uncheck()
  Future<void> indeterminate()
  Future<void> set(bool?)
  ```
* **[RadioPageObject\<T\>](lib/src/radio_page_object.dart)** (`Radio<T>`, `RadioListTile<T>`, `CupertinoRadio<T>`)
  ```dart
  T get value
  T? get groupValue
  bool get isSelected
  bool get isEnabled
  bool get isDisabled
  Future<void> select()
  ```
* **[RadioGroupPageObject\<T\>](lib/src/radio_group_page_object.dart)** (Multiple `Radio` widgets)
  ```dart
  T? get groupValue
  bool isSelected(T value)
  Future<void> select(T)
  ```
* **[SwitchPageObject](lib/src/switch_page_object.dart)** (`Switch`, `SwitchListTile`, `CupertinoSwitch`)
  ```dart
  bool get value
  bool get isEnabled
  bool get isDisabled
  Future<void> turnOn()
  Future<void> turnOff()
  Future<void> set(bool)
  ```
* **[DropdownPageObject\<T\>](lib/src/dropdown_page_object.dart)** (`DropdownButton<T>`, `DropdownButtonFormField<T>`)
  ```dart
  T? get value
  bool get isOpen
  bool get isEnabled
  bool get isDisabled
  Future<void> select(T?)
  Future<void> open()
  Future<void> close()
  Future<List<T?>> values()
  ```
* **[ChipPageObject](lib/src/chip_page_object.dart)** (`ChoiceChip`, `FilterChip`, `InputChip`, `ActionChip`)
  ```dart
  bool get isSelected
  bool get isEnabled
  bool get isDisabled
  Future<void> select()
  Future<void> deselect()
  Future<void> set(bool)
  ```

### Navigation Widgets

* **[ButtonPageObject](lib/src/button_page_object.dart)** (`ElevatedButton`, `TextButton`, `IconButton`, `FloatingActionButton`, `CupertinoButton`)
  ```dart
  bool get isEnabled
  bool get isDisabled
  ```
* **[NavPageObject\<T\>](lib/src/nav_page_object.dart)** (widgets with navigation)
  ```dart
  Future<T> tapNav({bool expectTarget})
  Future<T> tapNavAndPump({bool expectTarget})
  Future<T> tapNavAndSettle({bool expectTarget})
  ```
* **[NavButtonPageObject\<T\>](lib/src/nav_button_page_object.dart)** (Button variants with navigation)
  ```dart
  Future<T> tapNav({bool expectTarget})
  Future<T> tapNavAndPump({bool expectTarget})
  Future<T> tapNavAndSettle({bool expectTarget})
  ```
* **[TabBarPageObject](lib/src/tab_bar_page_object.dart)** (`TabBar`)
  ```dart
  int get selectedIndex
  Future<void> select(int)
  ```
* **[DrawerPageObject](lib/src/drawer_page_object.dart)** (`Drawer`)
  ```dart
  bool get isOpen
  Future<void> open()
  Future<void> close()
  ```
* **[BottomNavigationBarPageObject](lib/src/bottom_navigation_bar_page_object.dart)** (`BottomNavigationBar`)
  ```dart
  int get selectedIndex
  Future<void> selectByIndex(int)
  Future<void> selectByIcon<T>(IconData)
  NavPageObject<T> item<T extends PageObject>({required IconData icon, required PageObjectStaticBuilder<T> targetBuilder})
  ```

### Display Widgets

* **[TextPageObject](lib/src/text_page_object.dart)** (`Text`, `RichText`)
  ```dart
  String get text
  ```
* **[TypedTextPageObject\<T\>](lib/src/typed_text_page_object.dart)** (`Text`, `RichText` - typed)
  ```dart
  String get text
  T get value
  ```
* **[ImagePageObject](lib/src/image_page_object.dart)** (`Image`)
  ```dart
  ImageProvider? get image
  String? get semanticLabel
  ```
* **[ProgressIndicatorPageObject](lib/src/progress_indicator_page_object.dart)** (`ProgressIndicator`, `LinearProgressIndicator`, `CircularProgressIndicator`)
  ```dart
  double? get value
  ```

### Layout & Scrolling

* **[ScrollablePageObject](lib/src/scrollable_page_object.dart)** (`SingleChildScrollView`, `ListView`, `CustomScrollView`)
  ```dart
  Future<void> scrollUpUntilVisible(Finder, {double delta, int maxScrolls})
  Future<void> scrollDownUntilVisible(Finder, {double delta, int maxScrolls})
  Future<void> fling({double dx, double dy, double speed})
  Future<void> pullToRefresh()
  ```
* **[ScrollableListPageObject\<T\>](lib/src/scrollable_list_page_object.dart)** (`ListView`, `GridView`)
  ```dart
  int get count
  List<T> get all
  T operator [](int index)
  T item(Finder itemFinder)
  // + all ScrollablePageObject methods
  ```
* **[WidgetListPageObject\<T\>](lib/src/widget_list_page_object.dart)** (`Column`, `Row`)
  ```dart
  int get count
  List<T> get all
  T operator [](int index)
  T item(Finder itemFinder)
  ```
* **[SlidablePageObject](lib/src/slidable_page_object.dart)** (`PageView`, `TabView`)
  ```dart
  Future<void> swipeToStart({double? dx, double? speed})
  Future<void> swipeToEnd({double? dx, double? speed})
  ```
* **[SliderPageObject](lib/src/slider_page_object.dart)** (`Slider`)
  ```dart
  double get value
  double get min
  double get max
  int? get divisions
  bool get isEnabled
  bool get isDisabled
  Future<void> drag(Offset, {bool warnIfMissed})
  ```

### Other

* **[SnackBarPageObject](lib/src/snack_bar_page_object.dart)** (`SnackBar`)
  ```dart
  late final actionButton
  Future<void> dismiss()
  ```
* **[WidgetPageObject](lib/src/widget_page_object.dart)** (Any `Widget`)
  ```dart
  // Inherits all base PageObject interactions and accessors
  ```

## 🎯 Creating Your Own Page Object

Extend [PageObject](lib/src/page_object.dart) to create custom page objects for your app's unique widgets:

```dart
class CustomButtonPageObject extends PageObject {
  CustomButtonPageObject(WidgetTester t, Finder finder)
      : super(t, finder);

  /// Gets the button label text
  String get label => widget<YourCustomButton>().label;

  /// Performs a custom interaction
  Future<void> longPressAndDrag(Offset offset) async {
    await longPress();
    await drag(offset);
  }
}

// Add it to a factory extension for easy access:
extension CustomButtonPageObjectExtension<K> on PageObjectFactory<K> {
  CustomButtonPageObject customButton(K key) =>
      create(CustomButtonPageObject.new, key);
}

// Use it:
late final customButton = d.byKey.customButton(const Key('my_widget'));
```

## 📖 Full Examples

- **Login Form** - See [example/test_common/lib/login_page_object.dart](example/test_common/lib/login_page_object.dart) and [example/test/login_page_test.dart](example/test/login_page_test.dart)
- **Product List & Detail** - See [example/lib/](example/lib/) with comprehensive form and list interactions

## 🤝 Contribution

Contributions are welcome! Feel free to reach out or submit a PR for:
- New page object types
- Documentation improvements
- Example apps
- Bug reports
