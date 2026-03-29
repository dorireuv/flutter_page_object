import 'package:example/app.dart';
import 'package:example/models/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_common/browse_products_page_object.dart';
import 'package:test_common/login_page_object.dart';

void main() {
  testWidgets('displays all products', (t) async {
    await t.pumpWidget(const App());
    final browseProductsPage = await t.navToBrowseProductsPage();

    expect(browseProductsPage.itemsList.count, 5);

    expect(browseProductsPage.itemsList[0].name.text, 'Flutter Widget');
    expect(browseProductsPage.itemsList[0].price.value, Price.fromNum(9.99));
  });

  testWidgets('tap on product --> navigates to edit product page', (t) async {
    await t.pumpWidget(const App());
    final browseProductsPage = await t.navToBrowseProductsPage();

    final editProductPage =
        await browseProductsPage.itemsList[0].tapNavAndSettle();

    expect(editProductPage, findsOne);
    expect(editProductPage.nameTextField.text, 'Flutter Widget');
    expect(editProductPage.priceTextField.value, Price.fromNum(9.99));
  });
}

extension on WidgetTester {
  Future<BrowseProductsPageObject> navToBrowseProductsPage() async {
    final loginPage = LoginPageObject(this);
    final homePage = await loginPage.login();
    return await homePage.browseProductsButton.tapNavAndSettle();
  }
}
