import 'package:example/app.dart';
import 'package:example/models/product_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/edit_product_page_object.dart';
import 'package:test_common/login_page_object.dart';
import 'package:test_common/widget_tester_extension.dart';

void main() {
  group('tap save button', () {
    testWidgets('valid form --> updates product', (t) async {
      await t.pumpWidget(const App());
      final editProductPage = await t.navToEditProductPage();

      await editProductPage.nameTextField.enterText('New Product');
      final browseProductsPage =
          await editProductPage.saveButton.tapNavAndSettle();

      expect(browseProductsPage.itemsList[0].name.text, 'New Product');
    });

    testWidgets('invalid form --> shows error message', (t) async {
      await t.pumpWidget(const App());
      final editProductPage = await t.navToEditProductPage();

      await editProductPage.nameTextField.enterText('');
      await editProductPage.saveButton.tapAndSettle();

      t.expectAnErrorMessage();
    });
  });

  testWidgets('Switch can be toggled', (t) async {
    await t.pumpWidget(const App());
    final editProductPage = await t.navToEditProductPage();
    expect(editProductPage.availableSwitch.value, isTrue);

    await editProductPage.availableSwitch.turnOff();

    expect(editProductPage.availableSwitch.value, isFalse);
  });

  testWidgets('Checkbox can be toggled', (t) async {
    await t.pumpWidget(const App());
    final editProductPage = await t.navToEditProductPage();
    expect(editProductPage.featuredCheckbox.value, isFalse);

    await editProductPage.featuredCheckbox.check();

    expect(editProductPage.featuredCheckbox.value, isTrue);
  });

  testWidgets('Dropdown selection works', (t) async {
    await t.pumpWidget(const App());
    final editProductPage = await t.navToEditProductPage();
    expect(editProductPage.categoryDropdown.value, ProductCategory.software);

    await editProductPage.categoryDropdown.select(ProductCategory.tools);

    expect(editProductPage.categoryDropdown.value, ProductCategory.tools);
  });
}

extension on WidgetTester {
  Future<EditProductPageObject> navToEditProductPage() async {
    final loginPage = LoginPageObject(this);
    final homePage = await loginPage.login();
    final browseProductsPage =
        await homePage.browseProductsButton.tapNavAndSettle();
    return browseProductsPage.itemsList[0].tapNavAndSettle();
  }
}
