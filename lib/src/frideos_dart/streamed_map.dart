import 'package:rxdart/rxdart.dart';

///
///
/// Class for the streamed Maps
///
///
class StreamedMap<K, V> {
  final stream = BehaviorSubject<Map<K, V>>();
  //final _value = Map<K, V>();

  StreamedMap() {
    stream.value = Map<K, V>();
  }

  /// timesUpdate shows how many times the got updated
  int timesUpdated = 0;

  /// Sink for the stream
  Function(Map<K, V>) get inStream => stream.sink.add;

  /// Stream getter
  Stream<Map<K, V>> get outStream => stream.stream;

  //Map<K, V> get value => _value;
  Map<K, V> get value => stream.value;

  set value(Map<K, V> value) { 
    value.clear();
    value.addAll(value);
    inStream(value);
  }

  refresh() {
    inStream(value);
  }

  
  dispose() {
    print('---------- Closing Stream ------ type: $K, $V');
    stream.close();
  }
}

