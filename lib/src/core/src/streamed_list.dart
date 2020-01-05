import 'dart:async';

import '../core.dart';

///
///
/// Used when T is a list, it works like [StreamedValue].
///
/// To modify the list (e.g. adding items) and update the stream automatically
/// use these methods:
///
/// - [addAll]
/// - [addElement]
/// - [clear]
/// - [removeAt]
/// - [removeElement]
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
class StreamedList<T> implements StreamedObject<List<T>> {
  StreamedList({List<T> initialData, this.onError}) {
    stream = StreamedValue<List<T>>()
      ..stream.listen((data) {
        if (_onChange != null) {
          _onChange(data);
        }
      }, onError: onError);

    if (initialData != null) {
      stream.value = initialData;
    }
  }

  StreamedValue<List<T>> stream;

  /// Callback to handle the errors
  final Function onError;

  /// Sink for the stream
  Function(List<T>) get inStream => stream.inStream;

  /// Stream getter
  @override
  Stream<List<T>> get outStream => stream.outStream;

  /// The initial event of the stream
  List<T> initialData;

  /// Last value emitted by the stream
  List<T> lastValue;

  /// timesUpdated shows how many times the stream got updated
  int timesUpdated = 0;

  @override
  List<T> get value => stream.value;

  int get length => stream.value.length;

  /// This function will be called every time the stream updates.
  void Function(List<T> data) _onChange;

  /// Set the new value and update the stream
  set value(List<T> list) {
    stream.value = list;
    if (_debugMode) {
      timesUpdated++;
    }
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

  /// Used to add an item to the list and update the stream.
  void addElement(T element) {
    stream.value.add(element);
    refresh();
  }

  /// Used to add a List of item to the list and update the stream.
  ///
  void addAll(Iterable<T> elements) {
    stream.value.addAll(elements);
    refresh();
  }

  /// Used to remove an item from the list and update the stream.
  bool removeElement(T element) {
    final result = value.remove(element);
    refresh();
    return result;
  }

  /// Used to remove an item from the list and update the stream.
  T removeAt(int index) {
    final removed = value.removeAt(index);
    refresh();
    return removed;
  }

  /// To replace an element at a given index
  void replaceAt(int index, T element) {
    stream.value[index] = element;
    refresh();
  }

  /// To replace an element
  void replace(T oldElement, T newElement) {
    final index = stream.value.indexOf(oldElement);
    replaceAt(index, newElement);
  }

  /// Used to clear the list and update the stream.
  void clear() {
    value.clear();
    refresh();
  }

  /// To refresh the stream when the list is modified without using the
  /// methods of this class.
  void refresh() {
    inStream(value);
    if (_debugMode) {
      timesUpdated++;
    }
  }

  /// Dispose the stream.
  void dispose() {
    if (_debugMode) {
      print('---------- Closing Stream ------ type: List<$T>');
      print('Value: $value');
      print('Updated times: $timesUpdated');
    }
    stream.dispose();
  }
}
