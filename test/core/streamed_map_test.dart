import 'package:test/test.dart';

import 'package:frideos/frideos.dart';

void main() {
  group('StreamedMap', () {
    test('addKey', () async {
      final streamedMap = StreamedMap<int, String>();
      streamedMap.value = {};

      streamedMap..addKey(1, 'first')..addKey(2, 'second')..addKey(3, 'third');

      await expectLater(
        streamedMap.outStream,
        emits({1: 'first', 2: 'second', 3: 'third'}),
      );
    });

    test('addKey with initialData', () async {
      final streamedMap =
          StreamedMap<int, String>(initialData: {33: '33', 66: '66'});

      streamedMap..addKey(1, 'first')..addKey(2, 'second')..addKey(3, 'third');

      await expectLater(
        streamedMap.outStream,
        emits({33: '33', 66: '66', 1: 'first', 2: 'second', 3: 'third'}),
      );
    });

    test('Clear, removeKey, length', () {
      final streamedMap = StreamedMap<int, String>();
      streamedMap.value = {};

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

    test('onChange', () {
      final streamedMap = StreamedMap<int, String>();

      streamedMap.value = {1: 'a', 3: 'b', 5: 'c'};

      streamedMap.onChange((map) {
        expect(map, {1: 'a', 3: 'b', 5: 'c'});
      });
    });
  });
}
