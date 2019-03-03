import 'dart:async';

import '../../frideos_dart.dart';

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
class StreamedMap<K, V> extends StreamedObject<Map<K, V>> {
  StreamedMap({Map<K, V> initialData}) {
    stream = StreamedValue<Map<K, V>>();

    if (initialData != null) {
      stream.value = initialData;
    }

    stream.onChange((data) {
      _onChange(data);
    });
  }

  StreamedValue<Map<K, V>> stream;

  /// Sink for the stream
  Function(Map<K, V>) get inStream => stream.inStream;

  /// Stream getter
  Stream<Map<K, V>> get outStream => stream.outStream;

  /// The initial event of the stream
  Map<K, V> initialData;

  /// Last value emitted by the stream
  Map<K, V> lastValue;

  /// timesUpdate shows how many times the got updated
  int timesUpdated = 0;

  Map<K, V> get value => stream.value;

  int get length => stream.value.length;

  /// This function will be called every time the stream updates.
  void Function(Map<K, V> data) _onChange = (map) {};

  /// Clear the map, add all the key/value pairs of the map passed
  /// and update the stream
  set value(Map<K, V> map) {
    stream.value = map;
    timesUpdated++;
  }

  /// Debug mode (Default: false)
  bool _debugMode = false;

  /// To enable the debug mode
  void debugMode() {
    _debugMode = true;
  }

  /// To set a function that will be called every time the stream updates.
  onChange(Function(Map<K, V>) onDataChanged) {
    _onChange = onDataChanged;
  }

  /// Used to add key/value pair to the map and update the stream automatically
  addKey(K key, V val) {
    value[key] = val;
    refresh();
  }

  /// Used to remove a key from the map and update the stream automatically
  V removeKey(K key) {
    V removed = value.remove(key);
    refresh();
    return removed;
  }

  /// Used to clear the map and update the stream automatically
  clear() {
    value.clear();
    refresh();
  }

  /// To refresh the stream when the map is modified without using the
  /// methods of this class.
  refresh() {
    inStream(value);
    timesUpdated++;
  }

  /// Dispose the stream.
  dispose() {
    if (_debugMode) {
      print('---------- Closing Stream ------ type: Map<$K, $V>');
      print('Value: $value');
      print('Updated times: $timesUpdated');
    }
    stream.dispose();
  }
}
