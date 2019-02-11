import 'package:rxdart/rxdart.dart';

///
///
/// Used when T is a map, it works like [StreamedValue].
///
/// To modify the list (e.g. adding items) and update the stream automatically
/// use these methods:
///
/// - [addKey]
/// - [removeKey]
/// - [clear]
///
/// For other direct actions on the map, to update the stream call
/// the [refresh] method instead.
///
/// #### Usage
///
/// e.g. adding a key/value pair:
///
/// ```dart
///   streamedMap.addKey(1, 'first');
/// ```
///
/// it is the same as:
///
/// ```dart
///   streamedMap.value[1] = 'first';
///   streamedList.refresh();
/// ```
///
///
/// From the streamed map example:
///
/// ```dart
///  final streamedMap = StreamedMap<int, String>();
///
///
///  // Add to the streamed map the key/value pair put by the user
///  addText() {
///     var key = int.parse(streamedKey.value);
///     var value = streamedText.value;
///
///     streamedMap.addKey(key, value);
///
///     // Or, as an alternative:
///     //streamedMap.value[key] = value;
///     //streamedMap.refresh();
///   }
/// ```
///
///
class StreamedMap<K, V> {
  final stream = BehaviorSubject<Map<K, V>>();

  StreamedMap() {
    stream.value = Map<K, V>();
  }

  /// timesUpdate shows how many times the got updated
  int timesUpdated = 0;

  /// Sink for the stream
  Function(Map<K, V>) get inStream => stream.sink.add;

  /// Stream getter
  ValueObservable<Map<K, V>> get outStream => stream.stream;

  Map<K, V> get value => stream.value;

  int get length => stream.value.length;

  /// Clear the map, add all the key/value pairs of the map passed
  /// and update the stream
  set value(Map<K, V> map) {
    value.clear();
    value.addAll(map);
    inStream(map);
  }

  /// Debug mode (Default: false)
  bool _debugMode = false;

  /// To enable the debug mode
  void debugMode() {
    _debugMode = true;
  }

  /// Used to add key/value pair to the map and update the stream automatically
  addKey(K key, V val) {
    value[key] = val;
    refresh();
    timesUpdated++;
  }

  /// Used to remove a key from the map and update the stream automatically
  V removeKey(K key) {
    V removed = value.remove(key);
    refresh();
    timesUpdated++;
    return removed;
  }

  /// Used to clear the map and update the stream automatically
  clear() {
    value.clear();
    refresh();
    timesUpdated++;
  }

  /// To refresh the stream when the map is modified without using the
  /// methods of this class.
  refresh() {
    inStream(value);
  }

  dispose() {
    if (_debugMode) {
      print('---------- Closing Stream ------ type: Map<$K, $V>');
    }
    stream.close();
  }
}
