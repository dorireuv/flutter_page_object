## 1.0.0

* Initial stable release of `flutter_page_object`.
* Comprehensive page object support for 25+ Flutter widget types.
* Full API documentation with examples.
* Typed page objects for type-safe widget testing.
* Navigation page objects for handling app navigation flows.
* Complete example app demonstrating real-world usage patterns.

## 0.2.2

* `WidgetListPageObject` - search for descendants items only.
* `NavPageObject` / `NavButtonPageObject` - make targetBuilder a named param.
* Documentation updates.
* Example - make it more comprehensive.

## 0.2.1

* Do not export `TextInputPageObject` / `TypedTextInputPageObject`.

## 0.2.0+1

* Documentation updates.

## 0.2.0

* Add typed text page objects for `Text` / `TextField` / `TextFormField`.

## 0.1.9

* `TextFormFieldPageObject` / `TextFieldPageObject` - rename setText to enterText and create `TextInputPageObject` base class to avoid code duplication.
* `PageObject` - rename `shown` to `hitTestable`.
* Update deps.

## 0.1.8

* `TextPageObject` - leave text field only (which will ignore semantic labels and placeholders).

## 0.1.7

* Allow widget specific page objects to search for their widget in their descendants - take 2.

## 0.1.6

* Allow widget specific page objects to search for their widget in their descendants.

## 0.1.5

* `TextFormFieldPageObject` - add custom text form field support.
* `TextFieldPageObject` - add custom text field support.
* Documentation updates.

## 0.1.4

* `NavButtonPageObject` - use `targetBuilder` instead of `target`.
* Documentation updates.

## 0.1.3+1

* Documentation updates.

## 0.1.3

* Added `ChipPageObject`.
* Added `DrawerPageObject`.
* Added `ImagePageObject`.
* Added `TextFieldPageObject`.
* `PageObject` - add `longPress`, `state` methods.
* `PageObjectFactory` - add byTooltip, byText, byTextContaining.
* `SwitchPageObject` - support `CupertinoSwitch`.
* `CheckboxPageObject` / `TristateCheckboxPageObject` - support `CupertinoCheckbox`.

## 0.1.2+1

* Rename `snackbar_page_object.dart` to `snack_bar_page_object.dart`.

## 0.1.2

* Added `SnackBarPageObject`.
* Refactor `RadioGroupPageObject` to re-use `RadioPageObject`.
* `ButtonPageObject` - support `RawMaterialButton`.

## 0.1.1

* `RadioPageObject` - support `CupertinoRadio`.
* `ButtonPageObject` - support `CupertinoButton` and `FloatingActionButton`.

## 0.1.0+1

* Documentation updates.

## 0.1.0

* `BottomNavigationBarPageObject` - add selectByIcon and item.

## 0.0.9+1

* `RadioPageObject` - ignore deprecated member use.

## 0.0.9

* Address some flaky tests.

## 0.0.8

* Added `SliderPageObject`.
* Added `ProgressIndicatorPageObject`.
* Added `TabBarPageObject`.
* Added `BottomNavigationBarPageObject`.
* `ScrollableListPageObject` / `WidgetListPageObject` - added `count` API.
* Simplify tests.

## 0.0.7

* `PageObject` - added `waitUntilShown`.
* `ButtonPageObject` - support `IconButton` and `MaterialButton`.
* Simplify tests.
* Documentation updates.

## 0.0.6

* Added `RadioPageObject`.
* Added `RadioGroupPageObject`.
* Added `SwitchPageObject`.
* Documentation updates.

## 0.0.5+2

* Documentation updates.

## 0.0.5+1

* Documentation updates.

## 0.0.5

* Rename `HasScrollable` mixin to `IsScrollable`.
* Add `IsSlidable` mixin.

## 0.0.4

* `ScrollablePageObject`: scroll the first `Scrollable` in the case of nested scrollables.

## 0.0.3

* Fixed link to repository.
* Minor tests improvements.

## 0.0.2

* Added GitHub Actions for CI/CD.
* Configured Codecov for test coverage tracking.
* Excluded example folder from coverage reports.
* Documentation updates.

## 0.0.1

* Initial release.
