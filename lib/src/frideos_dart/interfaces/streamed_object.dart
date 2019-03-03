import 'dart:async';

///
/// Interface for all the StreamedObjects
///
abstract class StreamedObject<T> {
  Stream<T> get outStream;
  T get value;
}
