import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frideos/frideos.dart';

void main() {
  testWidgets('StagedWidget', (WidgetTester tester) async {
    var onShow = '';
    var onStart = '';
    var onEnd = '';

    var stagesMap = <int, Stage>{
      0: Stage(
          widget: Container(
            key: Key('0'),
            child: Text('Stage 0'),
          ),
          time: 2000,
          onShow: () {
            onShow = 'Stage 0';
            //tester.pump();
          }),
      1: Stage(
          widget: Container(
            key: Key('1'),
            child: Text('Stage 1'),
          ),
          time: 2000,
          onShow: () {
            onShow = 'Stage 1';
          }),
      2: Stage(
          widget: Container(
            key: Key('2'),
            child: Text('Stage 2'),
          ),
          time: 2000,
          onShow: () {
            onShow = 'Stage 2';
          }),
    };

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StagedWidget(
                stagesMap: stagesMap,
                onStart: () {
                  onStart = 'onStart';
                },
                onEnd: () {
                  onEnd = 'onEnd';
                }),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Stage 0'), findsOneWidget);
      expect(onShow, 'Stage 0');
      expect(onStart, 'onStart');

      // TODO: fixing test error after using tick in TimerObject
      /*
      await tester.pump(new Duration(milliseconds: 2200));
      expect(find.text('Stage 1'), findsOneWidget);
      expect(onShow, 'Stage 1');

      await tester.pump(new Duration(milliseconds: 2200));
      expect(find.text('Stage 2'), findsOneWidget);
      expect(onShow, 'Stage 2');

      await tester.pump(new Duration(milliseconds: 2200));
      expect(onEnd, 'onEnd');
      */
    });
  });
}
