import 'dart:async';

import 'package:test/test.dart';

import 'package:frideos/frideos_dart.dart';

void main() {
  group('StreamedObjects', () {
    //
    // StreamedValue test
    //
    test('StreamedValue', () {
      final streamedValue = StreamedValue<int>();

      streamedValue.value = 10;

      streamedValue.outStream.listen((value) {
        expect(value, 10);
      });

      streamedValue.dispose();
    });

    //
    // StreamedTransformed test
    //
    test('StreamedTransformed', () {
      final streamedTransformed = StreamedTransformed<String, int>();

      final validateKey =
          StreamTransformer<String, int>.fromHandlers(handleData: (key, sink) {
        var k = int.tryParse(key);
        if (k != null) {
          sink.add(k);
        } else {
          sink.addError('The key must be an integer.');
        }
      });

      streamedTransformed.setTransformer(validateKey);

      streamedTransformed.inStream('157');

      streamedTransformed.outTransformed.listen((value) {
        expect(value, 157);
      });

      streamedTransformed.dispose();
    });

    //
    // MemoryValue test
    //
    test('MemoryValue', () {
      final memoryValue = MemoryValue<int>();

      memoryValue.value = 10;
      memoryValue.value = 11;

      memoryValue.outStream.listen((value) {
        expect(value, 11);
        expect(memoryValue.oldValue, 10);
      });

      memoryValue.dispose();
    });

    //
    // HistoryObject test
    //
    test('HistoryObject', () {
      final historyObject = HistoryObject<String>();

      historyObject.value = 'Frideos';
      historyObject.saveValue();
      historyObject.value = 'Dart';
      historyObject.saveValue();
      historyObject.value = 'Flutter';
      historyObject.saveValue();

      historyObject.historyStream.listen((history) {
        expect(history.length, 3);
        expect(history.first, 'Frideos');
        expect(history.last, 'Flutter');
      });

      historyObject.dispose();
    });

    //
    // TimerObject test
    //
    test('TimerObject', () {
      final timerObject = TimerObject();

      int counter = 0;

      void incrementCounter(Timer t) {
        counter += 1;
        if (counter == 10) {
          timerObject.stopTimer();
        }
      }

      timerObject.startPeriodic(
          Duration(milliseconds: 10), (Timer t) => incrementCounter(t));

      checkCounter() {
        expect(counter, 10);
        timerObject.dispose();
      }

      Timer(Duration(milliseconds: 1000), expectAsync0(checkCounter));
    });
  });
}
