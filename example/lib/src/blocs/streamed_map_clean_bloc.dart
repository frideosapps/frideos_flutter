import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../blocs/bloc.dart';

class StreamedMapCleanBloc extends BlocBase with Validators {
  StreamedMapCleanBloc() {
    print('-------StreamedMapClean BLOC--------');
  }

  final _map = BehaviorSubject<Map<int, String>>();
  Stream<Map<int, String>> get outMap => _map.stream;
  Function(Map<int, String> map) get inMap => _map.sink.add;
  final map = Map<int, String>();

  final _text = BehaviorSubject<String>();
  Stream<String> get outText => _text.stream;
  Stream<String> get outTextTransformed => _text.stream.transform(validateText);
  Function(String text) get inText => _text.sink.add;

  final _key = BehaviorSubject<String>();
  Stream<String> get outKey => _key.stream;
  Stream<int> get outKeyTransformed => _key.stream.transform(validateKey);
  Function(String) get inKey => _key.sink.add;

  Observable<bool> get isFilled => Observable.combineLatest2(
      outTextTransformed, outKeyTransformed, (a, b) => true);

  // Add to the streamed map the key/value pair put by the user
  void addText() {
    final key = int.parse(_key.value);
    final value = _text.value;
    final streamMap = _map.value;

    if (streamMap != null) {
      map.addAll(streamMap);
    }

    map[key] = value;
    inMap(map);
  }

  @override
  void dispose() {
    print('-------StreamedMapClean BLOC DISPOSE--------');

    _map.close();
    _text.close();
    _key.close();
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
