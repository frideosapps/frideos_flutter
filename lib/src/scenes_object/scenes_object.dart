import 'dart:async';

import 'package:flutter/material.dart';

import '../core/core.dart';

import 'scene.dart';

///
/// Enum to handle the Status of the ScenesObject
///
enum SceneStatus { active, stop }

///
/// Interval in millisecond to check for the next scene
///
const int updateTimeScenes = 100;

/// A complex class to hadle the rendering of scenes over the time.
/// It takes a collection of "Scenes" and triggers the visualization of
/// the widgets at a given time (relative o absolute timing).
/// For example to make a demostration on how to use an application,
/// showing the widgets and pages along with explanations.
///
/// Every scene is handled by using the Scene class:
///
///```dart
/// class Scene {
///   Widget widget;
///   int time; // milliseconds
///   Function onShow = () {};
///   Scene({this.widget, this.time, this.onShow});
/// }
/// ```
///
/// ##### N.B. The onShow callback is used to trigger an action when the scene shows
///
/// #### Usage
/// From the ScenesObject example:
///
/// #### 1 - Declare a list of scenes
///
/// ```dart
/// final ScenesObject scenesObject = ScenesObject();
/// ```
///
/// #### 2 - Add some scenes
///
/// ```dart
/// scenes.addAll([
///   Scene(
///     time: 4000,
///     widget: SingleScene(text: 'Scene 1', color: Colors.blueGrey),
///     onShow: () => print('Showing scene 1'),
///   ),
///   Scene(
///     time: 4000,
///     widget: SingleScene(text: 'Scene 2', color: Colors.orange),
///     onShow: () => print('Showing scene 1'),
///   )
/// ]);
///
///
/// // The singleScene widget:
///
/// class SingleScene extends StatelessWidget {
///   const SingleScene({Key key, this.text, this.color}) : super(key: key);
///
///   final String text;
///   final Color color;
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       alignment: Alignment.center,
///       color: color,
///       child: Text(text),
///     );
///   }
/// }
/// ```
/// #### 3 - Setup the ScenesObject and play the scenes
///
/// ```dart
/// scenesObject
///   ..setScenesList(scenes)
///   ..setCallback(() => print('Called on start'))
///   ..setOnEndCallback(scenesObject.startScenes); // Replay the scenes at the end
///
/// // For e.g. on tap on a button:
/// scenesObject.startScenes();
/// ```
///
///
class ScenesObject implements StreamedObject {
  // Default constructor
  ScenesObject({this.absoluteTiming = false, this.callbackOnStart = true}) {
    if (absoluteTiming) {
      periodic = checkAbsolute;
    } else {
      periodic = checkRelative;
    }
  }

  ScenesObject.withList(List<Scene> scenes,
      {this.absoluteTiming = false, this.callbackOnStart = true}) {
    if (absoluteTiming) {
      periodic = checkAbsolute;
    } else {
      periodic = checkRelative;
    }

    _scenes = scenes;

    // Extract the times
    scenes.forEach((scene) => _stages.add(scene.time));

    // Buffering the list
    _scenesBuffer.addAll(_stages);

    // Status of the object at the beginning
    _status.value = SceneStatus.stop;
  }

  ///
  /// Scene status
  ///
  final _status = StreamedValue<SceneStatus>(initialData: SceneStatus.stop);

  /// Getters for the stream of status
  Stream<SceneStatus> get statusStream => _status.outStream;

  /// Status of the ScenedObject
  StreamedValue<SceneStatus> get getStatus => _status;

  ///
  /// Used for timing the scenes
  ///
  final _timerObject = TimerObject();

  ///
  /// Scenes, every value is a relative or an absolute time
  ///
  final List<int> _stages = [];

  /// The list is buffered to let the original one inalterated
  ///
  final List<int> _scenesBuffer = [];

  /// The scene to show
  ///
  int sceneIndex = 0;

  /// To check if the widget shown is the last
  ///
  bool isLastScene = false;

  /// Used in relative timing to calculate the time passed
  /// between two scenes
  ///
  int lastSceneTime = 0;

  /// Time margin error between the current time and the time
  /// set for the scene
  ///
  int sceneTimeMargin = 100;

  /// List of scenes
  ///
  List<Scene> _scenes;

  /// Every widget is sent to this stream
  ///
  final _widgetStream = StreamedValue<Widget>();

  /// WidgetStream getter
  ///
  /// Implementation of the getter outStream for the [StreamedObject]
  /// interface. Used as default by the `ValueBuilder`.
  @override
  Stream<Widget> get outStream => _widgetStream.outStream;

  /// Getter
  Widget get value => _widgetStream.value;

  /// This callback it is not scene specific and it is called
  /// everytime the scene changes. Setting the [callbackOnStart]
  /// to false, the callback it is not called at the scene 0.
  ///
  Function _callback = () {};

  /// By default the callback it is called at the beginning
  /// and on every scene change, set to false to disable the
  /// call of the callback at the scene 0. Default is true.
  bool callbackOnStart = true;

  /// This callback is called at the end.
  Function _onEnd = () {};

  /// Type of timing, absolute or relative
  ///
  bool absoluteTiming;

  /// By this function is set the type of timing: absolute or relative
  Function(Timer t) periodic;

  void clearList() {
    _scenes.clear();
  }

  /// To set the list of the scenes
  void setScenesList(List<Scene> scenes) {
    _scenes = scenes;

    // Extract the times
    if (_stages.isNotEmpty) {
      _stages.clear();
    }
    scenes.forEach((scene) => _stages.add(scene.time));
  }

  /// To set the callback non widget specific (this is called
  /// on every scene change and at the beginning if the flag [callbackOnStart]
  /// it is not set to false, default is true).
  void setCallback(Function callback) {
    _callback = callback;
  }

  void setOnEndCallback(Function callback) {
    _onEnd = callback;
  }

  int getListLength() => _scenes.length;

  Scene getCurrentScene() => _scenes[sceneIndex];

  int getSceneIndex() => sceneIndex;

  Scene getNextScene() {
    final nextScene = sceneIndex + 1;
    if (nextScene < _scenes.length) {
      return _scenes[nextScene];
    } else {
      return null;
    }
  }

  Scene getScene(int index) {
    assert(_scenes[index] != null);
    return _scenes[index];
  }

  void startScenes() {
    if (_scenes != null) {
      if (!_timerObject.isTimerActive && _scenes.isNotEmpty) {
        // Buffer the list
        if (_scenesBuffer.isNotEmpty) {
          _scenesBuffer.clear();
        }
        _scenesBuffer.addAll(_stages);

        // Show the first element of the list of widgets
        _widgetStream.value = _scenes[0].widget;

        // Set the scene index to the first element
        sceneIndex = 0;

        final interval = Duration(milliseconds: updateTimeScenes);

        // The implementation of the periodic function is set by setting
        // the absoluteTiming flag to true (absolute) or false (relative).
        _timerObject.startPeriodic(interval, periodic);

        _status.value = SceneStatus.active;

        // Call the onShow function
        if (_scenes[sceneIndex].onShow != null) {
          _scenes[sceneIndex].onShow();
        }

        // Calling the callback on start if the flag isn't set to false
        if (callbackOnStart) {
          _callback();
        }
      }
    }
  }

  void resetScenes() {
    // print('Reset scenes');
    // Refresh the buffer with the original list
    _scenesBuffer
      ..clear()
      ..addAll(_stages);

    // Set the scene to the first element
    sceneIndex = 0;
    _widgetStream.value = _scenes[0].widget;

    isLastScene = false;
  }

  void stopScenes() {
    // print('Stop scenes');
    _timerObject.stopTimer();
    lastSceneTime = 0;
    _status.value = SceneStatus.stop;

    // Calling the onEnd callback if the timing is relative
    if (!absoluteTiming) {
      final time = _scenes[sceneIndex].time;
      Timer(Duration(milliseconds: time), _onEnd);
    }
  }

  // check for absolute time position
  void checkAbsolute(Timer t) {
    if (_scenesBuffer.isNotEmpty) {
      // Updating the timer
      _timerObject.updateTime(t);

      final currentTime = _timerObject.time;

      // Time in milliseconds of the current scene
      final scene = _scenesBuffer.first;

      // If the current time is between +/- 100ms of an item of the scenes
      if (currentTime >= scene - sceneTimeMargin &&
          currentTime <= scene + sceneTimeMargin) {
        // Send to stream the new widget
        _widgetStream.value = _scenes[sceneIndex].widget;

        // To call the general callback and the onShow callback
        // of the single windget
        _callCallbacks();

        // Remove the current item
        _scenesBuffer.removeAt(0);

        // Set the new index so the next time is shown the next scene
        // on the list
        sceneIndex++;
      }
    } else {
      isLastScene = true;
      stopScenes();
    }
  }

  void checkRelative(Timer t) {
    // Check if there are items in the scenes list
    // and go on until
    if (_scenesBuffer.length > 1) {
      // Updating the timer
      _timerObject.updateTime(t);

      final currentTime = _timerObject.time;

      // Time in milliseconds of the current scene
      final scene = _scenesBuffer.first;

      // Being relative time the cutoff is the time passed
      // from the time of the last scene and the current one
      //
      final timePassed = currentTime - lastSceneTime;

      // If the current time is between +/- 100ms of an item of the scenes
      if (timePassed >= scene - sceneTimeMargin &&
          timePassed <= scene + sceneTimeMargin) {
        // Set the new index so the next time is shown the next widget
        // on the list
        sceneIndex++;

        // Send to stream the new widget
        _widgetStream.value = _scenes[sceneIndex].widget;

        // To call the general callback and the onShow callback
        // of the single windget
        _callCallbacks();

        // Remove the current item
        _scenesBuffer.removeAt(0);

        // The next time the current scene will be used to calculate
        // the time passed.
        lastSceneTime = currentTime;
      }
    } else {
      isLastScene = true;
      stopScenes();
    }
  }

  void _callCallbacks() {
    // Call the onShow function
    if (_scenes[sceneIndex].onShow != null) {
      _scenes[sceneIndex].onShow();
    }

    // Calling the callback
    // If no callback is set then this is -> () {}
    _callback();
  }

  void dispose() {
    _timerObject.dispose();
    _widgetStream.dispose();
    _status.dispose();
  }
}
