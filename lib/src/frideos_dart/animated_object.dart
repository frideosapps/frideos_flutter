import 'dart:async';

import 'streamed_value.dart';

enum AnimatedStatus { active, stop, pause }

///
///
/// This class is used to update a value over a period of time. Useful
/// to handle animations using the BLoC pattern.
///
///
class AnimatedObject<T> {
  AnimatedObject({this.initialValue, this.interval}) {
    _status.value = AnimatedStatus.stop;
  }

  /// [StreamedValue] object that holds the animation value
  final animation = StreamedValue<T>();

  /// Getter for stream of the [StreamedValue] that holds the animation
  /// value.
  get animationStream => animation.outStream;

  /// The initial value of the animation
  final T initialValue;

  /// Timer to handle the timing
  final timer = TimerObject();

  /// Interval in milliseconds
  final int interval;

  ///
  /// AnimatedObject status
  ///
  final _status = StreamedValue<AnimatedStatus>();

  /// Getter for the stream of the status of the animation
  get statusStream => _status.outStream;

  /// Status getter
  AnimatedStatus get getStatus => _status.value;

  bool isAnimating() {
    if (getStatus == AnimatedStatus.active) {
      return true;
    } else {
      return false;
    }
  }

  // In the callback increase the animation.value!
  start(Function(Timer t) callback) {
    print('start: ${timer.isTimerActive}');
    if (!timer.isTimerActive) {
      animation.value = initialValue;
      timer.startPeriodic(
          Duration(milliseconds: interval), (Timer t) => callback(t));
      // 
      _status.value = AnimatedStatus.active;
    }
  }

  stop() {
    timer.stopTimer();
    _status.value = AnimatedStatus.stop;
  }

  reset() {
    animation.value = initialValue;
  }

  pause() {
    _status.value = AnimatedStatus.pause;
  }

  dispose() {
    animation.dispose();
    timer.dispose();
  }
}
