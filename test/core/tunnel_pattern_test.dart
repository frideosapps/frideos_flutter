import 'package:test/test.dart';

import 'package:frideos/frideos.dart';

class BlocsHolder {
  BlocsHolder() {
    blocA.streamedSender.setReceiver(blocB.streamedValue);
    blocA.listSender.setReceiver(blocB.streamedList);
    blocA.mapSender.setReceiver(blocB.streamedMap);
  }

  final blocA = BlocA();
  final blocB = BlocB();

  void dispose() {
    blocB.dispose();
  }
}

class BlocA {
  final streamedSender = StreamedSender<String>();
  final listSender = ListSender<String>();
  final mapSender = MapSender<int, String>();
}

class BlocB {
  final streamedValue = StreamedValue<String>();
  final streamedList = StreamedList<String>();
  final streamedMap = StreamedMap<int, String>();

  void dispose() {
    streamedValue.dispose();
    streamedList.dispose();
    streamedMap.dispose();
  }
}

void main() {
  group('Tunnel Pattern', () {
    test('streamedSender', () async {
      final bloc = BlocsHolder();

      bloc.blocA.streamedSender.send('SENDING FROM BLOCA TO BLOCB');

      await expectLater(bloc.blocB.streamedValue.outStream,
          emits('SENDING FROM BLOCA TO BLOCB'));
    });

    test('listSender', () async {
      final bloc = BlocsHolder();

      bloc.blocA.listSender.send(['a', 'b', 'c']);

      await expectLater(
          bloc.blocB.streamedList.outStream, emits(['a', 'b', 'c']));
    });

    test('mapSender', () async {
      final bloc = BlocsHolder();

      bloc.blocA.mapSender.send({1: 'a', 2: 'b', 3: 'c'});

      await expectLater(
          bloc.blocB.streamedMap.outStream, emits({1: 'a', 2: 'b', 3: 'c'}));
    });
  });
}
