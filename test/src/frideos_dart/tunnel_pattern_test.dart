import 'package:test/test.dart';

import 'package:frideos/frideos_dart.dart';

import '../../../example/lib/src/blocs/bloc.dart';

class BlocHolder extends BlocBase {
  final blocA = BlocA();
  final blocB = BlocB();

  BlocHolder() {
    blocA.sender.setReceiver(blocB.streamedValue);
  }

  dispose() {
    blocA.dispose();
    blocB.dispose();
  }
}

class BlocA extends BlocBase {
  final sender = StreamedSender<String>();

  dispose() {}
}

class BlocB extends BlocBase {
  final streamedValue = StreamedValue<String>();

  dispose() {
    streamedValue.dispose();
  }
}

void main() {
  test('TunnelPattern', () {
    var bloc = BlocHolder();

    bloc.blocA.sender.send('SENDING FROM BLOCA TO BLOCB');

    bloc.blocB.streamedValue.outStream.listen((value) {
      expect(value, 'SENDING FROM BLOCA TO BLOCB');
      bloc.dispose();
    });
  });
}
