import 'dart:async';

///
/// Interface for all the StreamedObjects
///
abstract class StreamedObject<T> {
  /// Getter for the stream exposed by the classes that implement
  /// the StreamedObject interface.
  Stream<T> get outStream;

  /// Getter for the last value emitted by the stream
  T get value;
}
