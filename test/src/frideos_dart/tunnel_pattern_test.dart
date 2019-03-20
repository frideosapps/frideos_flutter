import 'package:test/test.dart';

import 'package:frideos/frideos_dart.dart';

import '../../../example/lib/src/blocs/bloc.dart';

class BlocsHolder {
  final blocA = BlocA();
  final blocB = BlocB();

  BlocsHolder() {
    blocA.sender.setReceiver(blocB.streamedValue);
  }

  void dispose() {
    blocB.dispose();
  }
}

class BlocA {
  final sender = StreamedSender<String>();
}

class BlocB {
  final streamedValue = StreamedValue<String>();

  void dispose() {
    streamedValue.dispose();
  }
}

void main() {
  test('TunnelPattern', () {
    var bloc = BlocsHolder();

    bloc.blocA.sender.send('SENDING FROM BLOCA TO BLOCB');

    bloc.blocB.streamedValue.outStream.listen((value) {
      expect(value, 'SENDING FROM BLOCA TO BLOCB');
      bloc.dispose();
    });
  });
}
