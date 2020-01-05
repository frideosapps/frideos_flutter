import 'dart:async';

import 'package:test/test.dart';

import 'package:frideos/frideos.dart';

void main() {
  group('StreamedObjects', () {
    //
    // StreamedValue test
    //
    test('StreamedValue', () async {
      final streamedValue = StreamedValue<int>();

      Timer.run(() {
        streamedValue.value = 1;
        streamedValue.value = 2;
        streamedValue.value = 8;
      });

      expect(
        streamedValue.outStream,
        emitsInOrder(<int>[1, 2, 8]),
      );
    });

    test('StreamedValue initialData', () async {
      final streamedValue = StreamedValue<int>(initialData: 99);

      Timer.run(() {
        streamedValue.value = 2;
        streamedValue.value = 8;
      });

      expect(
        streamedValue.outStream,
        emitsInOrder(<int>[99, 2, 8]),
      );
    });

    test('onChange', () {
      final streamedValue = StreamedValue<int>();

      streamedValue.value = 123;

      streamedValue.onChange((value) {
        expect(value, 123);
      });
    });

    //
    // StreamedTransformed test
    //
    test('StreamedTransformed', () {
      final streamedTransformed = StreamedTransformed<String, int>();

      final validateKey =
          StreamTransformer<String, int>.fromHandlers(handleData: (key, sink) {
        final k = int.tryParse(key);
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

      streamedTransformed.onChange((value) {
        expect(value, '157');
      });
    });

    test('StreamedTransformed initialValue', () {
      final streamedTransformed =
          StreamedTransformed<String, int>(initialData: '159');

      final validateKey =
          StreamTransformer<String, int>.fromHandlers(handleData: (key, sink) {
        final k = int.tryParse(key);
        if (k != null) {
          sink.add(k);
        } else {
          sink.addError('The key must be an integer.');
        }
      });

      streamedTransformed.setTransformer(validateKey);

      streamedTransformed.outTransformed.listen((value) {
        expect(value, 159);
      });

      streamedTransformed.onChange((value) {
        expect(value, '159');
      });
    });

    //
    // MemoryValue test
    //
    test('MemoryValue', () async {
      final memoryValue = MemoryValue<int>();

      Timer.run(() {
        memoryValue.value = 111;
        memoryValue.value = 121;
      });

      expect(memoryValue.outStream, emitsInOrder([111, 121]));

      memoryValue.outStream.listen((memory) {
        print(memory);
        if (memory == 121) {
          expect(memoryValue.oldValue, 111);
        }
      });
    });

    //
    // HistoryObject test
    //
    test('HistoryObject', () {
      final historyObject = HistoryObject<String>();
      Timer.run(() {
        historyObject.value = 'Frideos';
        historyObject.saveValue();
        historyObject.value = 'Dart';
        historyObject.saveValue();
        historyObject.value = 'Flutter';
        historyObject.saveValue();
        expect(historyObject.history.length, 3);
      });

      expect(
        historyObject.outStream,
        emitsInOrder(['Frideos', 'Dart', 'Flutter']),
      );
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

      timerObject.startPeriodic(Duration(milliseconds: 10), incrementCounter);

      void checkCounter() {
        expect(counter, 10);
        timerObject.dispose();
      }

      Timer(Duration(milliseconds: 1000), expectAsync0(checkCounter));
    });
  });
}
