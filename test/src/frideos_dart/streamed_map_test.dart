import 'dart:async';

import 'package:test/test.dart';

import 'package:frideos/frideos_dart.dart';

void main() {
  group('StreamedMap', () {
    test('addKey', () {
      final streamedMap = StreamedMap<int, String>();
      streamedMap.value = Map();

      Timer.run(() {
        streamedMap.addKey(1, 'first');
        streamedMap.addKey(2, 'second');
        streamedMap.addKey(3, 'third');
      });

      expect(
        streamedMap.outStream,
        emits({1: 'first', 2: 'second', 3: 'third'}),
      );
    });

    test('addKey with initialData', () {
      final streamedMap =
          StreamedMap<int, String>(initialData: {33: '33', 66: '66'});

      Timer.run(() {
        streamedMap.addKey(1, 'first');
        streamedMap.addKey(2, 'second');
        streamedMap.addKey(3, 'third');
      });

      expect(
        streamedMap.outStream,
        emits({33: '33', 66: '66', 1: 'first', 2: 'second', 3: 'third'}),
      );
    });

    test('Clear, removeKey, length', () {
      final streamedMap = StreamedMap<int, String>();
      streamedMap.value = Map();

      streamedMap.addKey(1, 'first');
      expect(streamedMap.value[1], 'first');

      streamedMap.addKey(1, 'first');
      expect(streamedMap.removeKey(1), 'first');

      streamedMap.addKey(1, 'first');
      streamedMap.addKey(2, 'second');
      expect(streamedMap.length, 2);

      streamedMap.clear();
      expect(streamedMap.length, 0);
      expect(streamedMap.value.length, 0);

      streamedMap.dispose();
    });
  });
}
