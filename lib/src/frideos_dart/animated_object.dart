import 'dart:async';

import 'streamed_value.dart';

enum AnimatedStatus { active, stop, pause }

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
///              StreamedWidget<AnimatedStatus>(
///                initialData: AnimatedStatus.stop,
///                stream: bloc.scaleAnimation.statusStream,
///                builder: (context, AsyncSnapshot<AnimatedStatus> snapshot) {
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
///                child: StreamedWidget(
///                    stream: bloc.scaleAnimation.animationStream,
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
  T initialValue;

  /// Timer to handle the timing
  final timer = TimerObject();

  /// Interval in milliseconds
  int interval;

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
