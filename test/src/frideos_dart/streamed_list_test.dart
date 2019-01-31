import 'package:test/test.dart';

import 'package:frideos/frideos_dart.dart';

void main() {
  test('StreamedList', () {

    final streamedList = StreamedList<int>();

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

    streamedList.dispose();

  });
}