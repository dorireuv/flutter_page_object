import 'package:example/models/price.dart';
import 'package:flutter_page_object/flutter_page_object.dart';

extension PageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [TextFormFieldPageObject] with the given [key].
  TypedTextFormFieldPageObject<Price?> priceTextField(K key) =>
      typedTextFormField(key,
          formatter: (v) => v?.toDisplayString() ?? '',
          parser: Price.fromDisplayString);

  TypedTextPageObject<Price?> priceText(K key) =>
      typedText(key, parser: Price.fromDisplayString);
}
