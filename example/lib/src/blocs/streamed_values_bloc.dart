import 'package:flutter/material.dart';

import 'package:frideos/frideos_dart.dart';

import '../blocs/bloc.dart';

class Counter {
  int counter;
  String text;
  Counter(this.counter, this.text);
}

class StreamedValuesBloc extends BlocBase {
  StreamedValuesBloc() {
    print('-------StreamedValues BLOC--------');

    // Activate the debug console messages on disposing
    count.debugMode();
    countMemory.debugMode();
    countHistory.debugMode();
    timerObject.debugMode();
    counterObj.debugMode();
  }

  final count = StreamedValue<int>();
  final countMemory = MemoryValue<int>();
  final countHistory = HistoryObject<int>();
  final timerObject = TimerObject();
  final counterObj = StreamedValue<Counter>();

  incrementCounter() {
    if (count.value != null) {
      count.value++;
      counterObj.value.counter++;
      counterObj.value.text = 'Counter: ${counterObj.value.counter}';
      counterObj.refresh();
    } else {
      count.value = 1;
      counterObj.value = Counter(1, 'First hit!');
    }
  }

  incrementCounterMemory() {
    if (countMemory.value != null) {
      countMemory.value++;
    } else {
      countMemory.value = 1;
    }
  }

  incrementCounterHistory() {
    if (countHistory.value != null) {
      countHistory.value++;
    } else {
      countHistory.value = 1;
    }
  }

  saveToHistory() {
    countHistory.saveValue();
  }

  startTimer() {
    timerObject.startTimer();
  }

  stopTimer() {
    timerObject.stopTimer();
  }

  getLapTime() {
    timerObject.getLapTime();
  }

  dispose() {
    print('-------StreamedValues BLOC DISPOSE--------');
    count.dispose();
    countMemory.dispose();
    countHistory.dispose();
    timerObject.dispose();
  }
}
