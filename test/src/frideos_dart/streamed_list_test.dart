import 'dart:async';

import 'package:test/test.dart';

import 'package:frideos/frideos.dart';

void main() {
  group('StreamedList', () {
    test('addElement', () {
      final streamedList = StreamedList<int>();
      streamedList.value = List<int>();

      Timer.run(() {
        streamedList.addElement(1);
        streamedList.addElement(2);
        streamedList.addElement(3);
        streamedList.addElement(4);
        streamedList.addElement(5);
      });

      expect(
        streamedList.outStream,
        emits([1, 2, 3, 4, 5]),
      );
    });

    test('addElement with initialData', () {
      final streamedList = StreamedList<int>(initialData: [33, 66, 99]);

      Timer.run(() {
        streamedList.addElement(1);
        streamedList.addElement(2);
        streamedList.addElement(3);
        streamedList.addElement(4);
        streamedList.addElement(5);
      });

      expect(
        streamedList.outStream,
        emits([33, 66, 99, 1, 2, 3, 4, 5]),
      );
    });

    test('Clear, removeAt, length', () {
      final streamedList = StreamedList<int>();
      streamedList.value = List<int>();

      streamedList.addElement(99);

      expect(streamedList.value.first, 99);

      expect(streamedList.value.remove(99), true);
      expect(streamedList.value.remove(99), false);

      streamedList.addElement(99);
      streamedList.removeAt(0);
      expect(streamedList.value.length, 0);

      streamedList.addElement(99);
      streamedList.clear();
      expect(streamedList.length, 0);
      expect(streamedList.value.length, 0);
    });
  });
}
