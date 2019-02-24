import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'streamed_list.dart';

///
///
/// Base class for the streamed objects
///
///
class _StreamedValueBase<T> {
  final stream = BehaviorSubject<T>();

  /// timesUpdate shows how many times the stream got updated
  int timesUpdated = 0;

  /// Debug mode (Default: false)
  bool _debugMode = false;

  /// To enable the debug mode
  void debugMode() {
    _debugMode = true;
  }

  /// Sink for the stream
  Function get inStream => stream.sink.add;

  /// Stream getter
  ValueObservable<T> get outStream => stream.stream;

  T get value => stream.value;

  set value(T value) => inStream(value);

  /// Method to refresh the stream (e.g to use when the type it is not
  /// a basic type, and a property of an object has changed).
  refresh() {
    inStream(value);
    timesUpdated++;
  }

  dispose() {
    if (_debugMode) {
      print('---------- Closing Stream ------ type: $T');
    }
    stream.close();
  }
}

///
///
/// It's the simplest object derived from the [_StreamedValueBase] class.
///
/// When a value is set through the setter, if it's different from the one
/// alredy stored then the new value is stored and sent to stream by
/// it's setter. Used in tandem with the StreamedWidget/StreamBuilder,
/// it automatically triggers the refresh of the widget when a new
/// value is set.
///
/// This essentially does a simple thing: every time a new value is set,
/// this is compared to the oldest one and if it is different assigned to
/// the variable and sent to stream. Why this? So that when a new value
/// is set, it automatically triggers the StreamerBuilder of the widget
/// and it refreshes without the need to manually add the value to the
/// sink of the stream.
///
/// So for example, instead of doing something like this:
///
/// ```dart
/// counter += 1;
/// stream.sink.add(counter);
/// ```
///
/// It becomes just:
///
/// ```dart
/// counter.value += 1;
/// ```
///
/// Then the StreamedValue is used to drive a [StreamedWidget]/StreamBuilder
/// using the outStream getter.
///
///
/// N.B. when the type is not a basic type (e.g int, double, String etc.) and
/// the value of a property of the object is changed, it is necessary to call
/// the [refresh] method to update the stream.
///
///
/// #### Usage
///
/// ```dart
/// // In the BLoC
/// final counter = StreamedValue<int>();
///
/// incrementCounter() {
///   counter.value += 2.0;
/// }
///
///
/// // View
/// StreamedWidget<int>(
///     stream: bloc.count.outStream,
///     builder: (BuildContext context,
///         AsyncSnapshot<int> snapshot) => Text('Value: ${snapshot.data}',
///     noDataChild: Text('NO DATA'),
/// ),
/// RaisedButton(
///     color: buttonColor,
///     child: Text('+'),
///     onPressed: () {
///         bloc.incrementCounter();
///         },
/// ),
/// ```
///
/// On update the [timesUpdated] increases showing how many times the
/// value has been updated.
///
///
/// N.B. For collections use the [StreamedList] and [StreamedMap] instead.
///
///
class StreamedValue<T> extends _StreamedValueBase<T> {
  StreamedValue({T initialData}) {
    if (initialData != null) {
      value = initialData;
    }
  }

  set value(T value) {
    if (stream.value != value) {
      inStream(value);
      timesUpdated++;
    }
  }
}

///
///
/// A special StreamedValue that is used when there is the need to use
/// a StreamTransformer (e.g. stream transformation, validation of input
/// fields, etc.).
///
///
/// #### Usage
///
/// From the StreamedMap example:
///
/// ```dart
/// // In the BLoC class
///   final streamedKey = StreamedTransformed<String, int>();
///
///
/// // In the constructor of the BLoC class
///   streamedKey.setTransformer(validateKey);
///
///
/// // Validation (e.g. in the BLoC or in a mixin class)
/// final validateKey =
///       StreamTransformer<String, int>.fromHandlers(handleData: (key, sink) {
///     var k = int.tryParse(key);
///     if (k != null) {
///       sink.add(k);
///     } else {
///       sink.addError('The key must be an integer.');
///     }
///   });
///
///
/// // In the view:
/// StreamBuilder(
///             stream: bloc.streamedKey.outTransformed,
///             builder: (context, AsyncSnapshot<int> snapshot) {
///               return Column(
///                 children: <Widget>[
///                   Padding(
///                     padding: const EdgeInsets.symmetric(
///                       vertical: 12.0,
///                       horizontal: 20.0,
///                     ),
///                     child: TextField(
///                       style: TextStyle(
///                         fontSize: 18.0,
///                         color: Colors.black,
///                       ),
///                       decoration: InputDecoration(
///                         labelText: 'Key:',
///                         hintText: 'Insert an integer...',
///                         errorText: snapshot.error,
///                       ),
///                       // To avoid the user could insert text use the TextInputType.number
///                       // Here is commented to show the error msg.
///                       //keyboardType: TextInputType.number,
///                       onChanged: bloc.streamedKey.inStream,
///                     ),
///                   ),
///                 ],
///               );
///             }),
/// ```
///
///
class StreamedTransformed<T, S> {
  StreamedTransformed({T initialData}) {
    if (initialData != null) {
      value = initialData;
    }
  }

  final stream = BehaviorSubject<T>();

  /// timesUpdate shows how many times the stream got updated
  int timesUpdated = 0;

  /// Sink for the stream
  Function(T) get inStream => stream.sink.add;

  /// Stream getter
  ValueObservable<T> get outStream => stream.stream;

  T get value => stream.value;

  /// Streamtransformer
  StreamTransformer _transformer;

  /// Getter for the stream transformed
  Observable<S> get outTransformed => stream.transform(_transformer);

  /// Debug mode (Default: false)
  bool _debugMode = false;

  /// To enable the debug mode
  void debugMode() {
    _debugMode = true;
  }

  /// Method to refresh the stream (e.g to use when the type it is not
  /// a basic type, and a property of an object has changed).
  refresh() {
    inStream(value);
    timesUpdated++;
  }

  set value(T value) {
    if (stream.value != value) {
      inStream(value);
      timesUpdated++;
    }
  }

  /// Method to set the StreamTransformer for the stream
  setTransformer(StreamTransformer<T, dynamic> transformer) {
    _transformer = transformer;
  }

  dispose() {
    if (_debugMode) {
      print('---------- Closing Stream ------ type: $T');
    }
    stream.close();
  }
}

///
///
///
/// The MemoryObject has a property to preserve the previous value.
///
/// The setter checks for the new value, if it is different from the one already stored,
/// this one is given [oldValue] before storing and streaming the new one.
///
///
///
class MemoryValue<T> extends _StreamedValueBase<T> {
  MemoryValue({T initialData}) {
    if (initialData != null) {
      value = initialData;
    }
  }

  T _oldValue;

  T get oldValue => _oldValue;

  set value(T value) {
    if (stream.value != value) {
      _oldValue = stream.value;
      inStream(value);
      timesUpdated++;
    }
  }
}

///
///
///
///
///
/// HistoryObject extends the [MemoryValue] class, adding a [StreamedList].
///
/// When the current value needs to be stored, the [saveValue] function is called
/// to send it to the [_historyStream].
///
class HistoryObject<T> extends MemoryValue<T> {
  HistoryObject({T initialData}) {
    if (initialData != null) {
      value = initialData;
    }
  }

  final _historyStream = StreamedList<T>(initialData: []);

  set value(T value) {
    if (stream.value != value) {
      _oldValue = stream.value;
      inStream(value);
      timesUpdated++;
    }
  }

  ///
  /// Getter for the list
  ///
  List<T> get history => _historyStream.value;

  ///
  /// Getter for the stream
  ///
  BehaviorSubject<List<T>> get historyStream => _historyStream.stream;

  ///
  /// Function to store the current value to a collection and sending it to stream
  ///
  saveValue() {
    _historyStream.addElement(value);
  }

  /// To enable the debug mode
  @override
  void debugMode() {
    _debugMode = true;
    _historyStream.debugMode();
  }

  @override
  dispose() {
    super.dispose();
    _historyStream.dispose();
  }
}

///
///
/// Timer refresh time
const updateTimerMilliseconds = 17;

///
///
/// An object that embeds a timer and a stopwatch.
///
///
/// #### Usage
///
/// ```dart
/// final timerObject = TimerObject();
///
/// startTimer() {
///   timerObject.startTimer();
/// }
///
/// stopTimer() {
///   timerObject.stopTimer();
/// }
///
/// getLapTime() {
///   timerObject.getLapTime();
/// }
///
/// incrementCounter(Timer t) {
///   counter.value += 2.0;
/// }
///
/// startPeriodic() {
///   var interval = Duration(milliseconds: 1000);
///   timerObject.startPeriodic(interval, incrementCounter);
/// }
///
///```
///
class TimerObject extends _StreamedValueBase<int> {
  /// TIMER
  Timer _timer;

  Duration _interval = Duration(milliseconds: updateTimerMilliseconds);

  bool isTimerActive = false;

  int _time = 0; // milliseconds

  /// STOPWATCH
  final _stopwatch = Stopwatch();

  final _stopwatchStreamed = StreamedValue<int>();

  bool isStopwatchActive = false;

  /// SETTER
  ///
  set value(int value) {
    if (stream.value != value) {
      inStream(value);
      timesUpdated++;
    }
  }

  /// GETTERS
  ///
  int get time => _time;

  /// Getter for the stream of the stopwatch
  ValueObservable<int> get stopwatchStream => _stopwatchStreamed.stream;

  /// Start timer and stopwatch only if they aren't active
  ///
  startTimer() {
    if (!isTimerActive) {
      // print('Starting timer');
      _timer = Timer.periodic(_interval, (Timer t) => updateTime(t));
      isTimerActive = true;
    }

    if (!isStopwatchActive) {
      _stopwatch.start();
      isStopwatchActive = true;
    }
  }

  /// Update the time and send it to stream
  ///
  updateTime(Timer t) {
    _time += _interval.inMilliseconds;
    inStream(_time);
  }

  /// Method to start a periodic function and set the isTimerActive to true
  ///
  startPeriodic(Duration interval, Function(Timer) callback) {
    if (!isTimerActive) {
      _timer = Timer.periodic(interval, callback);
      _interval = interval;
      isTimerActive = true;
    }
  }

  /// Method to get the lap time
  getLapTime() {
    if (isStopwatchActive) {
      var milliseconds = _stopwatch.elapsedMilliseconds;
      _stopwatchStreamed.value = milliseconds;
      _stopwatch.reset();
      _stopwatch.start();
    }
  }

  /// Stop timer and stopwatch, and set to false the booleans
  stopTimer() {
    if (isTimerActive) {
      _timer.cancel();
      _time = 0;
      inStream(null);
      isTimerActive = false;
    }
    if (isStopwatchActive) {
      _stopwatch.reset();
      _stopwatch.stop();
      isStopwatchActive = false;
    }
  }

  /// Method to reset the timer
  resetTimer() {
    _time = 0;
    inStream(_time);
  }

  /// Method to cancel the current timer
  pauseTimer() {
    _timer.cancel();
  }

  @override
  dispose() {
    super.dispose();
    if (_timer != null) _timer.cancel();
    _stopwatchStreamed.dispose();
    _stopwatch.stop();
  }
}
