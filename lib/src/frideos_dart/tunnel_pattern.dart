import 'streamed_value.dart';
import 'streamed_list.dart';
import 'streamed_map.dart';

/// Used to make a one-way tunnel beetween two blocs (from blocA to a StremedValue on blocB).
/// 
/// #### Usage:
/// 
/// 1 - Define a [StreamedValueBase] derived object in the blocB
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
/// 3 - Set the receiver in the sender on the class the holds the instances of the blocs
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
  StreamedValue<T> _receiver;

  StreamedSender();

  StreamedSender.setReceiver(StreamedValue<T> receiver) {
    _receiver = receiver;
  }

  setReceiver(StreamedValue<T> receiver) {
    _receiver = receiver;
  }

  send(T data) {
    _receiver.value = data;
    if (T is List || T is Map) _receiver.refresh();
    //print(data);
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
  StreamedList<T> _receiver;

  ListSender();

  ListSender.setReceiver(StreamedList<T> receiver) {
    _receiver = receiver;
  }

  setReceiver(StreamedList<T> receiver) {
    _receiver = receiver;
  }

  send(List<T> data) {
    print('data: $data');
    _receiver.value.clear();
    _receiver.value.addAll(data);    
    _receiver.refresh();
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
  StreamedMap<K, V> _receiver;

  MapSender();

  MapSender.setReceiver(StreamedMap<K, V> receiver) {
    _receiver = receiver;
  }

  setReceiver(StreamedMap<K, V> receiver) {
    _receiver = receiver;
  }

  send(Map<K, V> data) {
    print('data: $data');
    _receiver.value.clear();
    _receiver.value.addAll(data);
    _receiver.refresh();     
  }
}
