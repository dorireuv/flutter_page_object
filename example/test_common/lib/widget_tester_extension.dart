import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExtension on WidgetTester {
  void expectAnErrorMessage() => expect(_inputs().any(_hasError), isTrue);

  void expectNoErrorMessage() => expect(_inputs().every(_hasNoError), isTrue);

  bool _hasError(InputDecorator e) =>
      e.decoration.errorText?.isNotEmpty ?? false;

  bool _hasNoError(InputDecorator e) => !_hasError(e);

  List<InputDecorator> _inputs() =>
      widgetList<InputDecorator>(find.byType(InputDecorator)).toList();
}
