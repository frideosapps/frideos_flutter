import 'streamed_list.dart';
import 'streamed_map.dart';
import 'streamed_value.dart';

/// Used to make a one-way tunnel beetween two blocs (from blocA to
/// a StremedValue on blocB).
///
/// #### Usage:
///
/// 1 - Define a streamed object (e.g. [StreamedValue]) in the blocB
///
/// ```dart
/// final receiverStr = StreamedValue<String>();
/// ```
///
/// 2 - Define a [StreamedSender] in the blocA
///
/// ```dart
/// final tunnelSenderStr = StreamedSender<String>();
/// ```
///
///
/// 3 - Set the receiver in the sender on the class the holds the instances
/// of the blocs
///
/// ```dart///
/// blocA.tunnelSenderStr.setReceiver(blocB.receiverStr);
/// ```
///
/// 4 - To send data from blocA to bloc B then:
///
/// ```dart
/// tunnelSenderStr.send("Text from blocA to blocB");
/// ```
class StreamedSender<T> {
  StreamedSender();

  StreamedSender.setReceiver(StreamedValue<T> receiver)
      : assert(receiver != null, 'The receiver argument is null.') {
    _receiver = receiver;
  }

  StreamedValue<T> _receiver;

  void setReceiver(StreamedValue<T> receiver) {
    assert(receiver != null, 'The receiver argument is null.');
    _receiver = receiver;
  }

  void send(T data) {
    _receiver.value = data;
    if (T is List || T is Map) {
      _receiver.refresh();
    }
  }
}

/// Like the StreamedSender, but used with lists.
///
/// #### Usage
///
/// 1 - Define a [StreamedList] object in the blocB
///
/// ```dart
///   final receiverList = StreamedList<int>();
/// ```
///
/// 2 - Define a [ListSender] in the blocA
///
/// ```dart
///   final tunnelList = ListSender<int>();
/// ```
///
/// 3 - Set the receiver in the sender on the class the holds
///   the instances of the blocs
///
/// ```dart
///   blocA.tunnelList.setReceiver(blocB.receiverList);
/// ```
///
/// 4 - To send data from blocA to bloc B then:
///
/// ```dart
///   tunnelList.send(list);
/// ```
///
class ListSender<T> {
  ListSender();

  ListSender.setReceiver(StreamedList<T> receiver)
      : assert(receiver != null, 'The receiver argument is null.') {
    _receiver = receiver;
  }

  StreamedList<T> _receiver;

  void setReceiver(StreamedList<T> receiver) {
    assert(receiver != null, 'The receiver argument is null.');
    _receiver = receiver;
  }

  void send(List<T> data) {
    _receiver.value = data;
  }
}

/// Like the StreamedList, but used with maps.
///
/// #### Usage
///
/// 1 - Define a [StreamedMap]object in the blocB
///
/// ```dart
///   final receiverMap = StreamedMap<int, String>();
/// ```
///
/// 2 - Define a [MapSender] in the blocA
///
/// ```dart
///   final tunnelMap = MapSender<int, String>();
/// ```
///
/// 3 - Set the receiver in the sender on the class the holds
///   the instances of the blocs
///
/// ```dart
///   blocA.tunnelMap.setReceiver(blocB.receiverMap);
/// ```
///
/// 4 - To send data from blocA to bloc B then:
///
/// ```dart
///   tunnelMap.send(map);
/// ```
///
class MapSender<K, V> {
  MapSender();

  MapSender.setReceiver(StreamedMap<K, V> receiver)
      : assert(receiver != null, 'The receiver argument is null.') {
    _receiver = receiver;
  }

  StreamedMap<K, V> _receiver;

  /// Method to set the [StreamedMap] on the other bloc where
  /// to send the data
  void setReceiver(StreamedMap<K, V> receiver) {
    assert(receiver != null, 'The receiver argument is null.');
    _receiver = receiver;
  }

  /// Method to send the data to the StreamedMap set by the [setReceiver]
  /// method.
  void send(Map<K, V> data) {
    _receiver.value = data;
  }
}
