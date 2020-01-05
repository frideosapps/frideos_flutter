import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/rendering.dart';

import 'package:frideos/frideos.dart';

void main() {
  testWidgets('FadeOutWidget', (WidgetTester tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FadeOutWidget(
            key: key,
            child: Text('test'),
            duration: 1000,
          ),
        ),
      ),
    );

    expect(find.text('test'), findsOneWidget);

    RenderOpacity renderOpacity = tester
        .renderObject(find.byKey(key))
        .debugDescribeChildren()
        .first
        .value;
    expect(renderOpacity.opacity, 1.0);
    print(renderOpacity.opacity);

    await tester.pump(new Duration(milliseconds: 500));
    renderOpacity = tester
        .renderObject(find.byKey(key))
        .debugDescribeChildren()
        .first
        .value;
    print(renderOpacity.opacity);

    await tester.pump(new Duration(milliseconds: 500));
    renderOpacity = tester
        .renderObject(find.byKey(key))
        .debugDescribeChildren()
        .first
        .value;
    print(renderOpacity.opacity);
    expect(renderOpacity.opacity, 0.0);
  });

  testWidgets('FadeInWidget', (WidgetTester tester) async {
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FadeInWidget(
            key: key,
            child: Text('test'),
            duration: 1000,
          ),
        ),
      ),
    );

    expect(find.text('test'), findsOneWidget);

    RenderOpacity renderOpacity = tester
        .renderObject(find.byKey(key))
        .debugDescribeChildren()
        .first
        .value;
    expect(renderOpacity.opacity, 0.0);
    print(renderOpacity.opacity);

    await tester.pump(new Duration(milliseconds: 500));
    renderOpacity = tester
        .renderObject(find.byKey(key))
        .debugDescribeChildren()
        .first
        .value;
    print(renderOpacity.opacity);

    await tester.pump(new Duration(milliseconds: 500));
    renderOpacity = tester
        .renderObject(find.byKey(key))
        .debugDescribeChildren()
        .first
        .value;
    print(renderOpacity.opacity);
    expect(renderOpacity.opacity, 1.0);
  });
}
