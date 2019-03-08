import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'streamed_list.dart';

import '../frideos_dart/interfaces/streamed_object.dart';

/// It's the simplest class that implements the [StreamedObject] interface.
///
/// Every time a new value is set, this is compared to the oldest one and if
/// it is different, it is sent to stream.
///
/// Used in tandem with [ValueBuilder] it automatically triggers the rebuild
/// of the widgets returned by its builder.
///
///
/// So for example, instead of:
///
///
/// ```dart
/// counter += 1;
/// stream.sink.add(counter);
/// ```
///
///
/// It becomes just:
///
///
/// ```dart
/// counter.value += 1;
/// ```
///
///
/// It can be used even with [StreamedWidget] and [StreamBuilder] by using its
/// stream getter `outStream`. In this case, it is necessary to pass to the
/// `initialData` parameter the current value of the [StreamedValue]
/// (e.g. using the getter `value`).
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
/// ValueBuilder<int>(
///     stream: bloc.count, // no need of the outStream getter with ValueBuilder
///     builder: (BuildContext context,
///         AsyncSnapshot<int> snapshot) => Text('Value: ${snapshot.data}'),
///     noDataChild: Text('NO DATA'),
/// ),
/// RaisedButton(
///     color: buttonColor,
///     child: Text('+'),
///     onPressed: () {
///       bloc.incrementCounter();
///     },
/// ),
///
/// // As an alternative:
/// //
/// // StreamedWidget<int>(
/// //   initialData: bloc.count.value
/// //   stream: bloc.count.outStream,
/// //   builder: (BuildContext context,
/// //       AsyncSnapshot<int> snapshot) => Text('Value: ${snapshot.data}',
/// //   noDataChild: Text('NO DATA'),
/// //,
///
/// ```
///
///
/// On update the [timesUpdated] increases showing how many times the
/// value has been updated.
///
///
/// N.B. For collections use [StreamedList] and [StreamedMap] instead.
///
///
class StreamedValue<T> implements StreamedObject<T> {
  StreamedValue({this.initialData}) {
    stream = StreamController<T>.broadcast();

    stream.stream.listen((e) {
      _lastValue = e;
      _onChange(e);
    });

    if (initialData != null) {
      _lastValue = initialData;
      stream.add(_lastValue);
    }
  }

  /// The stream
  StreamController<T> stream;

  /// Stream getter
  Stream<T> get outStream => stream.stream;

  /// Sink for the stream
  Function get inStream => stream.sink.add;

  /// Last value emitted by the stream
  T _lastValue;

  /// The initial event of the stream
  T initialData;

  /// timesUpdate shows how many times the stream got updated
  int timesUpdated = 0;

  /// Debug mode (Default: false)
  bool _debugMode = false;

  /// This function will be called every time the stream updates.
  Function _onChange = (T data) {};

  /// Value getter
  T get value => _lastValue;

  /// Value setter
  set value(T value) {
    _lastValue = value;
    stream.add(value);
    timesUpdated++;
  }

  /// To set a function that will be called every time the stream updates.
  void onChange(Function(T data) onDataChanged) {
    _onChange = onDataChanged;
  }

  /// Method to refresh the stream (e.g to use when the type it is not
  /// a basic type, and a property of an object has changed).
  refresh() {
    inStream(value);
    timesUpdated++;
  }

  /// To enable the debug mode
  void debugMode() {
    _debugMode = true;
  }

  dispose() {
    if (_debugMode) {
      print('---------- Closing Stream ------ type: $T');
      print('Value: $value');
      print('Updated times: $timesUpdated');
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
class MemoryValue<T> extends StreamedValue<T> {
  MemoryValue({T initialData}) : super(initialData: initialData);

  T _oldValue;

  T get oldValue => _oldValue;

  set value(T value) {
    if (_lastValue != value) {
      _oldValue = _lastValue;
      _lastValue = value;
      stream.add(value);
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
  HistoryObject({T initialData}) : super(initialData: initialData);

  final _historyStream = StreamedList<T>(initialData: []);

  set value(T value) {
    if (_lastValue != value) {
      _oldValue = _lastValue;
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
  StreamedValue<List<T>> get historyStream => _historyStream.stream;

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
class TimerObject extends StreamedValue<int> {
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
    if (_lastValue != value) {
      inStream(value);
      timesUpdated++;
    }
  }

  /// GETTERS
  ///
  int get time => _time;

  /// Getter for the stream of the stopwatch
  Stream<int> get stopwatchStream => _stopwatchStreamed.outStream;

  /// Getter for the stopwatch object
  StreamedValue<int> get stopwatch => _stopwatchStreamed;

  /// Start timer and stopwatch only if they aren't active
  ///
  startTimer() {
    if (!isTimerActive) {
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

///
///
/// A particular class the implement the [StreamedObject] interface, to use when
/// there is the need of a StreamTransformer (e.g. stream transformation,
/// validation of input fields, etc.).
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
///
class StreamedTransformed<T, S> implements StreamedObject {
  StreamedTransformed({T initialData}) {
    stream = BehaviorSubject<T>(seedValue: initialData);

    stream.listen((e) {
      _lastValue = e;
      _onChange(e);
    });
  }

  T _lastValue;

  /// Value of the last event transformed
  S transformed;

  /// timesUpdate shows how many times the stream got updated
  int timesUpdated = 0;

  /// Debug mode (Default: false)
  bool _debugMode = false;

  /// Stream
  BehaviorSubject<T> stream;

  /// Sink for the stream
  Function get inStream => stream.sink.add;

  /// Stream getter
  Stream<T> get outStream => stream.stream;

  /// Streamtransformer
  StreamTransformer _transformer;

  /// Getter for the stream transformed
  Stream<S> get outTransformed => stream.stream.transform(_transformer);

  /// Value getter
  T get value => _lastValue;

  /// Value setter
  set value(T value) => inStream(value);

  /// This function will be called every time the stream updates.
  Function _onChange = (T data) {};

  /// This function will be called every time the stream updates.
  void onChange(Function(T data) onDataChanged) {
    _onChange = onDataChanged;
  }

  /// To set a function that will be called every time the stream updates.
  void setTransformer(StreamTransformer<T, S> transformer) {
    assert(transformer != null, 'Invalid transformer.');
    _transformer = transformer;
  }

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

  /// Dispose the stream.
  dispose() {
    if (_debugMode) {
      print('---------- Closing Stream ------ type: $T');
      print('Value: $value');
      print('Updated times: $timesUpdated');
    }
    stream.close();
  }
}
