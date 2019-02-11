import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:frideos/frideos_dart.dart';

import '../blocs/bloc.dart';

class StreamedMapBloc extends BlocBase with Validators {
  StreamedMapBloc() {
    print('-------StreamedMap BLOC--------');

    // Set the validation transformers for the textfields
    streamedText.setTransformer(validateText);
    streamedKey.setTransformer(validateKey);

    // Activate the debug console messages on disposing
    streamedKey.debugMode();
    streamedMap.debugMode();
  }

  final streamedMap = StreamedMap<int, String>();
  final streamedText = StreamedTransformed<String, String>();
  final streamedKey = StreamedTransformed<String, int>();

  Observable<bool> get isFilled => Observable.combineLatest2(
      streamedText.outTransformed, streamedKey.outTransformed, (a, b) => true);

  // Add to the streamed map the key/value pair put by the user
  addText() {
    var key = int.parse(streamedKey.value);
    var value = streamedText.value;

    streamedMap.addKey(key, value);

    // Or, as an alternative:
    //streamedMap.value[key] = value;
    //streamedMap.refresh();
  }

  dispose() {
    print('-------StreamedMap BLOC DISPOSE--------');
    streamedMap.dispose();
    streamedText.dispose();
    streamedKey.dispose();
  }
}

class Validators {
  final validateText =
      StreamTransformer<String, String>.fromHandlers(handleData: (str, sink) {
    if (str.isNotEmpty) {
      sink.add(str);
    } else {
      sink.addError('The text must not be empty.');
    }
  });

  final validateKey =
      StreamTransformer<String, int>.fromHandlers(handleData: (key, sink) {
    var k = int.tryParse(key);
    if (k != null) {
      sink.add(k);
    } else {
      sink.addError('The key must be an integer.');
    }
  });
}
