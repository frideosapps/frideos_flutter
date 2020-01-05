import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frideos/frideos.dart';

void main() {
  testWidgets('StreamedWidget NoDataChild', (WidgetTester tester) async {
    final streamedValue = StreamedValue<Widget>();

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ReceiverWidget(
          stream: streamedValue.outStream,
        ),
      ),
    ));

    expect(find.text('testwidget'), findsNothing);

    streamedValue.value = Text('testwidget');

    await tester.pumpAndSettle();

    expect(find.text('testwidget'), findsOneWidget);

    streamedValue.dispose();
  });
}
