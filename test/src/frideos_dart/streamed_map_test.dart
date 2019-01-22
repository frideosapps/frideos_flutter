import 'package:test/test.dart';

import 'package:frideos/frideos_dart.dart';

void main() {
  test('StreamedMap', () {

    final streamedMap = StreamedMap<int, String>();

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
}