import 'dart:async';

import 'package:flutter/material.dart';

import 'streamed_value.dart';

class Stage {
  Widget widget;
  int time; // milliseconds  
  Function onShow = () {};
  Stage({this.widget, this.time, this.onShow});
}

enum StageStatus { active, stop }

const updateTimeStaged = 100;

///
///
/// This class is used to show a series of widgets over a period of time.
///
///
class StagedObject {
  //Default constructor
  StagedObject({this.absoluteTiming = false, this.callbackOnStart = true}) {
    if (absoluteTiming) {
      periodic = checkAbsolute;
    } else {
      periodic = checkRelative;
    }
  }

  StagedObject.withMap(Map<int, Stage> widgetsMap,
      {this.absoluteTiming = false, this.callbackOnStart = true}) {
    if (absoluteTiming) {
      periodic = checkAbsolute;
    } else {
      periodic = checkRelative;
    }

    _widgetsMap = widgetsMap;

    // Extract the times
    widgetsMap.forEach((k, v) => _stages.add(v.time));

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
  Map<int, Stage> _widgetsMap;

  /// Every widget is sent to this stream
  ///
  final _widgetStream = StreamedValue<Widget>();

  /// WidgetStream getter
  ///
  Stream<Widget> get widgetStream => _widgetStream.outStream;

  /// Callback
  ///
  Function() _callback = () {};
  bool callbackOnStart = true;

  /// Type of timing, absolute or relative
  ///
  bool absoluteTiming;
  Function(Timer t) periodic;

  clearMap() {
    _widgetsMap.clear();
  }

  setStagesMap(Map<int, Stage> widgetsMap) {
    _widgetsMap = widgetsMap;

    // Extract the times
    if (_stages.length > 0) _stages.clear();
    widgetsMap.forEach((k, v) => _stages.add(v.time));
  }

  getMapLength() {
    return _widgetsMap.length;
  }

  setCallback(Function callback) {
    _callback = callback;
  }

  Stage getCurrentStage() {
    return _widgetsMap[stageIndex];
  }

  int getStageIndex() {
    return stageIndex;
  }

  Stage getNextStage() {
    var nextStage = stageIndex + 1;
    if (_widgetsMap.containsKey(nextStage)) {
      return _widgetsMap[nextStage];
    } else {
      return null;
    }
  }

  Stage getStage(int index) {
    // Adding check?
    return _widgetsMap[index];
  }

  startStages() {
    if (!_timerObject.isTimerActive && _widgetsMap != null) {
      // Buffer the list
      if (_stagesBuffer.length > 0) _stagesBuffer.clear();
      _stagesBuffer.addAll(_stages);

      // Show the first element of the list of widgets
      _widgetStream.value = _widgetsMap[0].widget;

      // Set the stage index to the first element
      stageIndex = 0;

      var interval = Duration(milliseconds: updateTimeStaged);

      // The implementation of the periodic function is set by setting
      // the absoluteTiming flag to true (absolute) or false (relative).
      _timerObject.startPeriodic(interval, periodic);

      _status.value = StageStatus.active;

      // Calling the callback on start if the flag isn't set to false
      if (callbackOnStart) {
        _callback();
      }
    }
  }

  resetStages() {
    print('Reset stages');
    // Refresh the buffer with the original list
    _stagesBuffer.clear();
    _stagesBuffer.addAll(_stages);

    // Set the stage to the first element
    stageIndex = 0;
    _widgetStream.value = _widgetsMap[0].widget;

    isLastStage = false;
  }

  stopStages() {
    print('Stop stages');
    _timerObject.stopTimer();
    lastStageTime = 0;
    _status.value = StageStatus.stop;
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
        print('MATCH ->  T:$currentTime, S:$stage');

        // Send to stream the new widget
        _widgetStream.value = _widgetsMap[stageIndex].widget;

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
        _widgetStream.value = _widgetsMap[stageIndex].widget;

        // To call the general callback and the onShow callback of the single windget
        _callCallbacks();

        // print(widgetStream.value);
        // print('MATCH ->  T:$currentTime, S:$stage');
        // print('Length: ${_stagesBuffer.length}');

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
    if (_widgetsMap[stageIndex].onShow != null) {
      _widgetsMap[stageIndex].onShow();
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
