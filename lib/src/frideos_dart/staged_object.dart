import 'dart:async';

import 'package:flutter/material.dart';

import 'streamed_value.dart';

///
/// This class is used to handle the stages:
///
class Stage {
  Widget widget;
  int time; // milliseconds
  Function onShow = () {};
  Stage({this.widget, this.time, this.onShow});
}

enum StageStatus { active, stop }

const updateTimeStaged = 100;

/// A complex class to hadle the rendering of widgets over the time.
/// It takes a collection of "Stages" and triggers the visualization of
/// the widgets at a given time (relative o absolute timing).
/// For example to make a demostration on how to use an application,
/// showing the widgets and pages along with explanations.
///
///
/// Every stage is handled by using the Stage class:
///
/// class Stage {
///   Widget widget;
///   int time; // milliseconds
///   Function onShow = () {};
///   Stage({this.widget, this.time, this.onShow});
/// }
/// ```
///
/// ##### N.B. The onShow callback is used to trigger an action when the stage shows
///
/// #### Usage
///
/// From the StagedObject example:
///
/// 1. #### Declare a map <int, Stage>
///    Here the map is in the view and is set in the BLoC class by the setStagesMap.
///
/// ```dart
/// Map<int, Stage> get stagesMap => <int, Stage>{
///   0: Stage(
///       widget: Container(
///         width: 200.0,
///         height: 200.0,
///         color: Colors.indigo[200],
///         alignment: Alignment.center,
///         key: Key('0'),
///         child: ScrollingText(
///           text:
///             'This stage will last 8 seconds. By the onShow call back it is possibile to assign an action when the widget shows.',
///           scrollingDuration: 2000,
///           style: TextStyle(
///             color: Colors.blue,
///             fontSize: 18.0,
///             fontWeight: FontWeight.w500)),
///         ),
///       time: 8000,
///       onShow: () {}),
///  1: Stage(
///       widget: Container(
///         width: 200.0,
///         height: 200.0,
///         color: Colors.indigo[200],
///         alignment: Alignment.center,
///         key: Key('00'),
///         child: ScrollingText(
///               text: 'The next widgets will cross      fade.',
///               scrollingDuration: 2000,
///             ),
///           ),
///       time: 8000,
///       onShow: () {}),
///
/// }
/// ```
/// 2. #### In the BLoC
///
/// ```dart
///   final text = StreamedValue<String>();
///   final staged = StagedObject();
///
///   // The map can be set through the constructor of the StagedObject
///   // or by the setStagesMap method like in this case.
///   setMap(Map<int, Stage> stagesMap) {
///     staged.setStagesMap(stagesMap);
///   }
///
///   start() {
///     if (staged.getMapLength() > 0) {
///       staged.setCallback(sendNextStageText);
///       staged.startStages();
///     }
///   }
///
///
///   sendNextStageText() {
///     var nextStage = staged.getNextStage();
///     if (nextStage != null) {
///       text.value = "Next stage:";
///       widget.value = nextStage.widget;
///       stage.value = StageBridge(
///           staged.getStageIndex(), staged.getCurrentStage(), nextStage);
///     } else {
///       text.value = "This is the last stage";
///       widget.value = Container();
///     }
///   }
/// ```
///
/// 3. #### In the view:
///
/// ```dart
///   // Setting the map in the build method
///   StagedObjectBloc bloc = BlocProvider.of(context);
///   bloc.setMap(stagesMap);
///
///
///   // To show the current widget on the view using the ReceiverWidget.
///   // As an alternative it can be used the StreamedWidget/StreamBuilder.
///   ReceiverWidget(
///     stream: bloc.staged.widgetStream,
///   ),
/// ```
///
///
class StagedObject {
  // Default constructor
  StagedObject(
      {this.absoluteTiming = false, this.callbackOnStart = true}) {
    if (absoluteTiming) {
      periodic = checkAbsolute;
    } else {
      periodic = checkRelative;
    }
  }

  StagedObject.withMap(Map<int, Stage> stagesMap,
      {this.absoluteTiming = false, this.callbackOnStart = true}) {
    if (absoluteTiming) {
      periodic = checkAbsolute;
    } else {
      periodic = checkRelative;
    }

    _stagesMap = stagesMap;

    // Extract the times
    stagesMap.forEach((k, v) => _stages.add(v.time));

    // Buffering the list
    _stagesBuffer.addAll(_stages);

    // Status of the object at the beginning
    _status.value = StageStatus.stop;
  }

  ///
  /// Stage status
  ///
  final _status = StreamedValue<StageStatus>();

  Stream<StageStatus> get statusStream => _status.outStream;

  get getStatus => _status;

  ///
  /// Used for timing the stages
  ///
  final _timerObject = TimerObject();

  ///
  /// Stages, every value is a relative or an absolute time
  ///
  final _stages = List<int>();

  /// The list is buffered to let the original one inalterated
  ///
  final _stagesBuffer = List<int>();

  /// The stage to show
  ///
  int stageIndex = 0;

  /// To check if the widget shown is the last
  ///
  bool isLastStage = false;

  /// Used in relative timing to calculate the time passed
  /// between two stages
  ///
  int lastStageTime = 0;

  /// Time margin error between the current time and the time
  /// set for the stage
  ///
  int stageTimeMargin = 100;

  /// Map of widgets
  ///
  Map<int, Stage> _stagesMap;

  /// Every widget is sent to this stream
  ///
  final _widgetStream = StreamedValue<Widget>();

  /// WidgetStream getter
  ///
  Stream<Widget> get widgetStream => _widgetStream.outStream;

  /// This callback it is not stage specific and it is called
  /// everytime the stage changes. Setting the [callbackOnStart]
  /// to false, the callback it is not called at the stage 0.
  ///
  Function() _callback = () {};

  /// By default the callback it is called at the beginning
  /// and on every stage change, set to false to disable the
  /// call of the callback at the stage 0. Default is true.
  bool callbackOnStart = true;

  /// This callback is called at the end.
  Function() _onEnd = () {};

  /// Type of timing, absolute or relative
  ///
  bool absoluteTiming;

  /// By this function is set the type of timing: absolute or relative
  Function(Timer t) periodic;

  clearMap() {
    _stagesMap.clear();
  }

  /// To se the map of the stages
  setStagesMap(Map<int, Stage> stagesMap) {
    _stagesMap = stagesMap;

    // Extract the times
    if (_stages.length > 0) _stages.clear();
    stagesMap.forEach((k, v) => _stages.add(v.time));
  }

  getMapLength() {
    return _stagesMap.length;
  }

  /// To set the callback non widget specific (this is called
  /// on every stage change and at the beginning if the flag [callbackOnStart]
  /// it is not set to false, default is true).
  setCallback(Function callback) {
    _callback = callback;
  }

  setOnEndCallback(Function callback) {
    _onEnd = callback;
  }

  Stage getCurrentStage() {
    return _stagesMap[stageIndex];
  }

  int getStageIndex() {
    return stageIndex;
  }

  Stage getNextStage() {
    var nextStage = stageIndex + 1;
    if (_stagesMap.containsKey(nextStage)) {
      return _stagesMap[nextStage];
    } else {
      return null;
    }
  }

  Stage getStage(int index) {
    // Adding check?
    return _stagesMap[index];
  }

  startStages() {
    if (!_timerObject.isTimerActive && _stagesMap != null) {
      // Buffer the list
      if (_stagesBuffer.length > 0) _stagesBuffer.clear();
      _stagesBuffer.addAll(_stages);

      // Show the first element of the list of widgets
      _widgetStream.value = _stagesMap[0].widget;

      // Set the stage index to the first element
      stageIndex = 0;

      var interval = Duration(milliseconds: updateTimeStaged);

      // The implementation of the periodic function is set by setting
      // the absoluteTiming flag to true (absolute) or false (relative).
      _timerObject.startPeriodic(interval, periodic);

      _status.value = StageStatus.active;

      // Call the onShow function
      if (_stagesMap[stageIndex].onShow != null) {
        _stagesMap[stageIndex].onShow();
      }

      // Calling the callback on start if the flag isn't set to false
      if (callbackOnStart) {
        _callback();
      }
    }
  }

  resetStages() {
    // print('Reset stages');
    // Refresh the buffer with the original list
    _stagesBuffer.clear();
    _stagesBuffer.addAll(_stages);

    // Set the stage to the first element
    stageIndex = 0;
    _widgetStream.value = _stagesMap[0].widget;

    isLastStage = false;
  }

  stopStages() {
    // print('Stop stages');
    _timerObject.stopTimer();
    lastStageTime = 0;
    _status.value = StageStatus.stop;

    // Calling the onEnd callback if the timing is relative
    if (!absoluteTiming) {
      var time = _stagesMap[stageIndex].time;
      Timer(Duration(milliseconds: time), _onEnd);
    }
  }

  // check for absolute time position
  checkAbsolute(Timer t) {
    if (_stagesBuffer.length > 0) {
      // Updating the timer
      _timerObject.updateTime(t);

      var currentTime = _timerObject.time;

      // Time in milliseconds of the current stage
      var stage = _stagesBuffer.first;

      // If the current time is between +/- 100ms of an item of the stages
      if (currentTime >= stage - stageTimeMargin &&
          currentTime <= stage + stageTimeMargin) {
        // Send to stream the new widget
        _widgetStream.value = _stagesMap[stageIndex].widget;

        // To call the general callback and the onShow callback of the single windget
        _callCallbacks();

        // Remove the current item
        _stagesBuffer.removeAt(0);

        // Set the new index so the next time is shown the next widget
        // on the list
        stageIndex++;
      }
    } else {
      isLastStage = true;
      stopStages();
    }
  }

  checkRelative(Timer t) {
    // Check if there are items in the stages list
    // and go on until
    if (_stagesBuffer.length > 1) {
      // Updating the timer
      _timerObject.updateTime(t);

      var currentTime = _timerObject.time;

      // Time in milliseconds of the current stage
      var stage = _stagesBuffer.first;

      // Being relative time the cutoff is the time passed
      // from the time of the last stage and the current one
      //
      int timePassed = currentTime - lastStageTime;

      // If the current time is between +/- 100ms of an item of the stages
      if (timePassed >= stage - stageTimeMargin &&
          timePassed <= stage + stageTimeMargin) {
        // Set the new index so the next time is shown the next widget
        // on the list
        stageIndex++;

        // Send to stream the new widget
        _widgetStream.value = _stagesMap[stageIndex].widget;

        // To call the general callback and the onShow callback of the single windget
        _callCallbacks();

        // Remove the current item
        _stagesBuffer.removeAt(0);

        // The next time the current stage will be used to calculate
        // the time passed.
        lastStageTime = currentTime;
      }
    } else {
      isLastStage = true;
      stopStages();
    }
  }

  _callCallbacks() {
    // Call the onShow function
    if (_stagesMap[stageIndex].onShow != null) {
      _stagesMap[stageIndex].onShow();
    }

    // Calling the callback
    // If no callback is set then this is -> () {}
    _callback();    
  }

  dispose() {
    _timerObject.dispose();
    _widgetStream.dispose();
    _status.dispose();
  }
}
