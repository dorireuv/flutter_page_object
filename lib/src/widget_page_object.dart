import 'page_object.dart';
import 'page_object_factory.dart';

/// A page object representing a generic widget.
class WidgetPageObject extends PageObject {
  /// Creates a [WidgetPageObject] with the given [finder].
  WidgetPageObject(super.t, super.finder);
}

/// Extension on [PageObjectFactory] to create [WidgetPageObject]s.
extension WidgetPageObjectFactoryExtension<K> on PageObjectFactory<K> {
  /// Creates a [WidgetPageObject] with the given [key].
  WidgetPageObject widget(K key) => create(WidgetPageObject.new, key);
}
