//import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../../frideos_dart.dart';

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
/// - [replace]
/// - [replaceAt]
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
class StreamedList<T> extends StreamedObject<List<T>> {
  StreamedList({List<T> initialData}) {
    stream = StreamedValue<List<T>>();

    if (initialData != null) {
      stream.value = initialData;
    }

    stream.onChange((data) {
      _onChange(data);
    });
  }

  /// Stream
  StreamedValue<List<T>> stream;

  /// Sink for the stream
  Function(List<T>) get inStream => stream.inStream;

  /// Stream getter
  Stream<List<T>> get outStream => stream.outStream;

  /// The initial event of the stream
  List<T> initialData;

  /// Last value emitted by the stream
  List<T> lastValue;

  /// timesUpdated shows how many times the stream got updated
  int timesUpdated = 0;

  List<T> get value => stream.value;

  int get length => stream.value.length;

  /// This function will be called every time the stream updates.
  void Function(List<T> data) _onChange = (list) {};

  /// Set the new value and update the stream
  set value(List<T> list) {
    stream.value = list;
    timesUpdated++;
  }

  /// Debug mode (Default: false)
  bool _debugMode = false;

  /// To enable the debug mode
  void debugMode() {
    _debugMode = true;
  }

  /// To set a function that will be called every time the stream updates.
  void onChange(Function(List<T>) onDataChanged) {
    _onChange = onDataChanged;
  }

  /// Used to add an item to the list and update the stream automatically
  void addElement(T element) {
    stream.value.add(element);
    refresh();
  }

  /// Used to remove an item from the list and update the stream automatically
  bool removeElement(element) {
    var result = value.remove(element);
    refresh();
    return result;
  }

  /// Used to remove an item from the list and update the stream automatically
  T removeAt(int index) {
    T removed = value.removeAt(index);
    refresh();
    return removed;
  }

  /// To replace an element at a given index
  replaceAt(int index, T element) {
    stream.value[index] = element;
    refresh();
  }

  /// To replace an element
  replace(T oldElement, T newElement) {
    var index = stream.value.indexOf(oldElement);
    replaceAt(index, newElement);
  }

  /// Used to clear the list and update the stream automatically
  clear() {
    value.clear();
    refresh();
  }

  /// To refresh the stream when the list is modified without using the
  /// methods of this class.
  refresh() {
    inStream(value);
    timesUpdated++;
  }

  /// Dispose the stream.
  dispose() {
    if (_debugMode) {
      print('---------- Closing Stream ------ type: List<$T>');
      print('Value: $value');
      print('Updated times: $timesUpdated');
    }
    stream.dispose();
  }
}
