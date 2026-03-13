import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_page_object/flutter_page_object.dart';
import 'package:flutter_test/flutter_test.dart';

import 'common.dart';

void main() {
  ImagePageObject createPageObject(WidgetTester t) =>
      PageObjectFactory.root(t).image(aFinder);

  testWidgets('image --> image', (t) async {
    await t.pumpWidget(const _Widget());
    final pageObject = createPageObject(t);
    expect(pageObject.image, _image);
  });

  group('semanticLabel', () {
    testWidgets('null --> null', (t) async {
      await t.pumpWidget(const _Widget(semanticLabel: null));
      final pageObject = createPageObject(t);
      expect(pageObject.semanticLabel, isNull);
    });

    testWidgets('provided --> value', (t) async {
      await t.pumpWidget(const _Widget(semanticLabel: 'label'));
      final pageObject = createPageObject(t);
      expect(pageObject.semanticLabel, 'label');
    });
  });
}

class _Widget extends StatelessWidget {
  final String? semanticLabel;

  const _Widget({this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Image(
        key: aKey,
        image: _image,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

const _image = _TestImageProvider();

class _TestImageProvider extends ImageProvider<_TestImageProvider> {
  const _TestImageProvider();

  @override
  Future<_TestImageProvider> obtainKey(ImageConfiguration configuration) =>
      Future.value(this);

  @override
  ImageStreamCompleter loadImage(
          _TestImageProvider key, ImageDecoderCallback decode) =>
      OneFrameImageStreamCompleter(Completer<ImageInfo>().future);
}
