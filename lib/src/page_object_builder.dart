import 'package:flutter_test/flutter_test.dart';

import 'page_object.dart';

/// A typedef for a function that builds a page object of type [T] given a
/// [WidgetTester] and a [Finder].
typedef PageObjectBuilder<T extends PageObject> = T Function(
    WidgetTester, Finder);
