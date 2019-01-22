import 'dart:async';

import 'package:rxdart/rxdart.dart';

///
///
/// Used when T is a list, it works like [StreamedValue].
///
/// To modify the list (e.g. adding items) and update the stream automatically
/// use these methods:
///
/// - [addElement]
/// - [removeElement]
/// - [removeAt]
/// - [clear]
///
/// For other direct actions on the list, to update the stream call
/// the [refresh] method instead.
///
/// #### Usage
///
/// e.g. adding an item:
///
/// ```dart
///   streamedList.addElement(item);
/// ```
///
/// it is the same as:
///
/// ```dart
///   streamedList.value.add(item);
///   streamedList.refresh();
/// ```
///
/// From the StreamedList example:
///
/// ```dart
/// final streamedList = StreamedList<String>();
///
///
/// // Add to the streamed list the string from the textfield
/// addText() {
///   streamedList.addElement(streamedText.value);
///
///   // Or, as an alternative:
///   // streamedList.value.add(streamedText.value);
///   // streamedList.refresh(); // To refresh the stream with the new value
/// }
/// ```
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

  int get length => stream.value.length;

  /// Clear the list, add all elements of the list passed
  /// and update the stream
  set value(List<T> list) {
    value.clear();
    value.addAll(list);
    inStream(list);
  }

  /// Used to add an item to the list and update the stream automatically
  addElement(element) {
    value.add(element);
    refresh();
    timesUpdated++;
  }

  /// Used to remove an item from the list and update the stream automatically
  bool removeElement(element) {
    var result = value.remove(element);
    refresh();
    timesUpdated++;
    return result;
  }

  /// Used to remove an item from the list and update the stream automatically
  T removeAt(int index) {
    T removed = value.removeAt(index);
    refresh();
    timesUpdated++;
    return removed;
  }

  /// Used to clear the list and update the stream automatically
  clear() {
    value.clear();
    refresh();
    timesUpdated++;
  }

  /// To refresh the stream when the list is modified without using the 
  /// methods of this class.
  refresh() {
    inStream(value);
  }

  dispose() {
    print('---------- Closing Stream ------ type: $T');
    stream.close();
  }
}
