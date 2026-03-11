import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';
import 'localized_widget_wrapper_for_testing.dart';

void main() {
  _WidgetPageObject createPageObject(WidgetTester t) =>
      _WidgetPageObject(t, find.byType(_Widget));

  testWidgets('tap actionButton --> executes action', (t) async {
    var actionExecuted = false;
    await t.pumpWidget(_Widget(action: () => actionExecuted = true));
    final pageObject = createPageObject(t);
    await pageObject.button.tapAndSettle();
    expect(pageObject.snackBar, findsOne);

    await pageObject.snackBar.actionButton.tapAndSettle();

    expect(actionExecuted, isTrue);
  });

  testWidgets('dismiss --> dismisses snack bar', (t) async {
    await t.pumpWidget(const _Widget());
    final pageObject = createPageObject(t);
    await pageObject.button.tapAndSettle();
    expect(pageObject.snackBar, findsOne);

    await pageObject.snackBar.dismiss();

    expect(pageObject.snackBar, findsNothing);
  });
}

class _WidgetPageObject extends PageObject {
  late final button = d.byType.button(ElevatedButton);
  late final snackBar = r.byKey.snackBar(aKey);

  _WidgetPageObject(super.t, super.finder);
}

class _Widget extends StatelessWidget {
  final VoidCallback? action;

  const _Widget({this.action});

  @override
  Widget build(BuildContext context) {
    return LocalizedWidgetWrapperForTesting(
      child: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => _showSnackBar(context),
          child: const Text('Show SnackBar'),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(key: aKey, content: const Text('Message'), action: _action()));
  }

  SnackBarAction? _action() {
    final onPressed = action;
    return onPressed == null
        ? null
        : SnackBarAction(label: 'Action', onPressed: onPressed);
  }
}
