import 'dart:async';

import 'package:flutter/foundation.dart';

import 'interfaces/streamed_object.dart';
import 'streamed_value.dart';

///
/// Enum to handle the status of the animation.
///
enum AnimatedStatus { active, stop, pause }

///
/// Enum to specify the behavior of the animation for
/// the `startAnimation` method.
///
enum AnimatedType { increment, decrement }

///
///
/// This class is used to update a value over a period of time.
/// Useful to handle animations using the BLoC pattern.
///
/// From the AnimatedObject example:
///
/// #### Usage
///
/// #### In the BLoC:
///
///  ```dart
///  //Initial value 0.5, updating interval 20 milliseconds
///  final scaleAnimation =
///      AnimatedObject<double>(initialValue: 0.5, interval: 20);
///
///  start() {
///    scaleAnimation.start(updateScale);
///  }
///
///  updateScale(Timer t) {
///    scaleAnimation.animation.value += 0.02;
///
///    if (scaleAnimation.animation.value > 5.0) {
///      scaleAnimation.reset();
///    }
///  }
///
///  stop() {
///    scaleAnimation.stop();
/// }
///
///  reset() {
///   scaleAnimation.reset();
///  }
///```
///
///- #### In the view:
///
///```dart
///      Container(
///          color: Colors.blueGrey[100],
///          child: Column(
///            children: <Widget>[
///              Container(height: 20.0,),
///              ValueBuilder<AnimatedStatus>(
///                streamed: bloc.scaleAnimation.status,
///                builder: (context, snapshot) {
///                 return Row(
///                    mainAxisAlignment: MainAxisAlignment.center,
///                    children: <Widget>[
///                      snapshot.data == AnimatedStatus.active
///                          ? RaisedButton(
///                              color: Colors.lightBlueAccent,
///                              child: Text('Reset'),
///                              onPressed: () {
///                                bloc.reset();
///                              })
///                          : Container(),
///                      snapshot.data == AnimatedStatus.stop
///                         ? RaisedButton(
///                              color: Colors.lightBlueAccent,
///                              child: Text('Start'),
///                              onPressed: () {
///                                bloc.start();
///                              })
///                          : Container(),
///                      snapshot.data == AnimatedStatus.active
///                          ? RaisedButton(
///                              color: Colors.lightBlueAccent,
///                              child: Text('Stop'),
///                              onPressed: () {
///                                bloc.stop();
///                              })
///                          : Container(),
///                    ],
///                  );
///                },
///              ),
///              Expanded(
///                child: ValueBuilder<double>(
///                    streamed: bloc.scaleAnimation,
///                    builder: (context, snapshot) {
///                      return Transform.scale(
///                          scale: snapshot.data, child: FlutterLogo());
///                   }),
///              )
///            ],
///          ),
///        ),
///```
///
///
class AnimatedObject<T> implements StreamedObject<T> {
  AnimatedObject({@required this.initialValue, @required this.interval})
      : assert(initialValue != null, 'The initialValue argument is null.'),
        assert(interval != null, 'The interval argument is null.') {
    status.value = AnimatedStatus.stop;
  }

  /// It is the [StreamedValue] object that holds the animation value
  final StreamedValue<T> animation = StreamedValue<T>();

  /// Getter for stream of the [StreamedValue] that holds the animation
  /// value.
  @override
  Stream<T> get outStream => animation.outStream;

  /// Deprecated. use [outStream] instead, this is used by [ValueBuilder].
  ///
  /// Getter for stream of the [StreamedValue] that holds the animation
  /// value.
  @Deprecated('Used the outStream getter instead.')
  Stream<T> get animationStream => animation.outStream;

  /// Getter for the AnimatedObject value
  @override
  T get value => animation.value;

  /// Setter for the AnimatedObject value
  set value(T value) => animation.value = value;

  /// The initial value of the animation
  T initialValue;

  /// Timer to handle the timing
  final TimerObject timer = TimerObject();

  /// Interval in milliseconds
  int interval;

  ///
  /// AnimatedObject status
  ///
  final StreamedValue<AnimatedStatus> status = StreamedValue<AnimatedStatus>();

  /// Getter for the stream of the status of the animation
  Stream<AnimatedStatus> get statusStream => status.outStream;

  /// Status getter
  AnimatedStatus get getStatus => status.value;

  /// Method to check if the animation is playing or not.
  bool isAnimating() {
    if (getStatus == AnimatedStatus.active) {
      return true;
    } else {
      return false;
    }
  }

  /// In the callback increase the animation.value!
  void start(Function(Timer t) callback) {
    if (!timer.isTimerActive) {
      animation.value = initialValue;
      timer.startPeriodic(Duration(milliseconds: interval), callback);
      status.value = AnimatedStatus.active;
    }
  }

  ///
  /// Method to start animating the value.
  ///
  /// - `type`: with this parameter specify if the the value
  /// has to be incremented or decremented
  ///
  ///
  /// - `velocity`: entity of the increment/decrement
  ///
  ///
  /// - `minValue` and `maxValue`: if an [AnimatedType] of value `increment`
  /// is set, then a `maxValue` parameter must be given. If `decrement`, a
  /// `minValue` must be set. Once reached a min or a max value, the
  /// animation stops.
  ///
  void startAnimation(
      {@required AnimatedType type,
      @required dynamic velocity,
      dynamic minValue,
      dynamic maxValue}) {
    assert(type != null && velocity != null,
        'type and velocity parameters must be not null.');

    dynamic valueTmp = initialValue;

    switch (type) {
      case AnimatedType.increment:
        assert(maxValue != null, 'The parameter maxValue must be not null.');

        start((t) {
          if (valueTmp < maxValue) {
            valueTmp += velocity;
            value = valueTmp;
          }

          if (valueTmp >= maxValue) {
            value = maxValue;
            stop();
          }
        });
        break;
      case AnimatedType.decrement:
        assert(minValue != null, 'The parameter maxValue must be not null.');

        start((t) {
          if (valueTmp > minValue) {
            valueTmp -= velocity;
            value = valueTmp;
          }

          if (valueTmp <= minValue) {
            value = minValue;
            stop();
          }
        });
        break;
      default:
        break;
    }
  }

  /// Method to stop the animation-
  void stop() {
    timer.stopTimer();
    status.value = AnimatedStatus.stop;
  }

  /// Method to reset the animation. It doesn't stop the animation, it just
  /// sets the animation.value to the [initialValue].
  void reset() {
    animation.value = initialValue;
  }

  /// Method to pause the animation
  void pause() {
    status.value = AnimatedStatus.pause;
  }

  void dispose() {
    animation.dispose();
    timer.dispose();
  }
}
