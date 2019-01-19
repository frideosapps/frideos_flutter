import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'streamed_collection.dart';

///
///
/// Base class for the streamed objects
///
///
class StreamedValueBase<T> {
  final stream = BehaviorSubject<T>();

  /// timesUpdate shows how many times the got updated
  int timesUpdated = 0;

  /// Sink for the stream
  Function(T) get inStream => stream.sink.add;

  /// Stream getter
  Stream<T> get outStream => stream.stream;

  T get value => stream.value;

  set value(T value) => inStream(value);

  refresh() {
    inStream(value);
  }

  dispose() {
    print('---------- Closing Stream ------ type: $T');
    stream.close();
  }
}

///
///
/// It's the simplest object derived from the [StreamValueBase] class.
///
/// When a value is set through the setter, if it's different from the one
/// alredy stored then the new value is stored and sent to stream by it's setter.
///
/// Then [timesUpdated] increases showing how many times the value has been updated.
///
/// For collections use the [add] method to add items to the collections and send to the stream
/// the updated collection. If it used the 'object.value.add' the stream doesn't get updated.
///
///
///
class StreamedValue<T> extends StreamedValueBase<T> {
  set value(T value) {
    if (stream.value != value) {
      inStream(value);
      timesUpdated++;
    }
  }
}

///
///
/// Object to use when there is the neeed to transform a stream.
///
///
///
///
class StreamedTransformed<T, S> {
  final stream = BehaviorSubject<T>();

  /// Sink for the stream
  Function(T) get inStream => stream.sink.add;

  /// Stream getter
  Stream<T> get outStream => stream.stream;

  T get value => stream.value;

  refresh() {
    inStream(value);
  }

  dispose() {
    print('---------- Closing Stream ------ type: $T');
    stream.close();
  }

  set value(T value) {
    if (stream.value != value) {
      inStream(value);
    }
  }

  StreamTransformer _transformer;
  setTransformer(StreamTransformer<T, dynamic> transformer) {
    _transformer = transformer;
  }

  Stream<S> get outTransformed => stream.transform(_transformer);
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
class MemoryValue<T> extends StreamedValueBase<T> {
  T oldValue;

  set value(T value) {
    if (stream.value != value) {
      oldValue = stream.value;
      stream.value = value;
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
/// HistoryObject extends the [MemoryValue] class, adding a [StreamedCollection].
///
/// When the current value needs to be stored, the [saveValue] function is called to save
/// it to the [_history] collection. The collection is sent to stream.
///
class HistoryObject<T> extends MemoryValue<T> {
  final _historyStream = StreamedList<T>();

  set value(T value) {
    if (stream.value != value) {
      oldValue = stream.value;
      stream.value = value;
      timesUpdated++;
      inStream(value);
    }
  }

  ///
  /// Getter for the collection [_History]
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

  @override
  dispose() {
    super.dispose();
    _historyStream.dispose();
  }
}

///
///
///
/// [TimerObject]
///
///
///
const updateTimerMilliseconds = 17;

///
///
///
class TimerObject extends StreamedValueBase<int> {
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
      stream.value = value;
      timesUpdated++;
      inStream(value);
    }
  }

  /// GETTERS
  ///
  get time => _time;

  get stopwatchStream => _stopwatchStreamed.stream;

  /// Start timer and stopwatch only if they aren't active
  ///
  startTimer() {
    if (!isTimerActive) {
      print('Starting timer');
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

  getLapTime() {
    if (isStopwatchActive) {
      var milliseconds = _stopwatch.elapsedMilliseconds;
      _stopwatchStreamed.value = milliseconds;
      print('Time: $_time');
      print(milliseconds);
      _stopwatch.reset();
      _stopwatch.start();
    }
  }

  /// Stop timer and stopwatch, and set to false the booleans
  stopTimer() {
    if (isTimerActive) {
      //print('Stop timer: $_time');
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

  resetTimer() {
    _time = 0;
    inStream(_time);
  }

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
