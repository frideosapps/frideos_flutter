import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frideos/frideos.dart';

void main() {
  testWidgets('StreamedWidget NoDataChild', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
          body: ScrollingText(
        text: 'scrolling',
        scrollingDuration: 1000,
      )),
    ));

    expect(find.text('scrolling'), findsNothing);
    await tester.pump(new Duration(milliseconds: 1500));
    expect(find.text('scrolling'), findsOneWidget);
  });
}
