import 'dart:async';

import 'package:rxdart/rxdart.dart';

///
///
/// Used when T is a collection, it works like [StreamedValue].
///
///
class StreamedList<T> {
  final stream = BehaviorSubject<List<T>>();
  
  StreamedList() {
    stream.value = List<T>();
  }

  /// timesUpdate shows how many times the got updated
  int timesUpdated = 0;

  /// Sink for the stream
  Function(List<T>) get inStream => stream.sink.add;

  /// Stream getter
  Stream<List<T>> get outStream => stream.stream;


  List<T> get value => stream.value;

  ///  Clear the list, add all elements of the list passed and update the stream
  set value(List<T> value) {
    value.clear();
    value.addAll(value);
    inStream(value);
  }
  
  /// To refresh the stream when data is added without using addElement;
  refresh() {
    inStream(value);
  }

  /// Used when T is a collection, to add items and update the stream
  addElement(element) {
    value.add(element);
    refresh();
    timesUpdated++;
  }

  dispose() {
    print('---------- Closing Stream ------ type: $T');
    stream.close();
  }
}

