import 'package:flutter/material.dart';

import 'package:frideos/frideos_dart.dart';

import '../blocs/bloc.dart';

class Counter {
  Counter(this.counter, this.text);

  int counter;
  String text;
}

class StreamedValuesBloc extends BlocBase {
  StreamedValuesBloc() {
    print('-------StreamedValues BLOC--------');

    // Activate the debug console messages on disposing
    count.debugMode();
    countMemory.debugMode();
    countHistory.debugMode();
    counterObj.debugMode();
  }

  final count = StreamedValue<int>(initialData: 0);
  final countMemory = MemoryValue<int>(initialData: 2);
  final countHistory = HistoryObject<int>(initialData: 4);
  final counterObj =
      StreamedValue<Counter>(initialData: Counter(1, 'First hit!'));

  void incrementCounter() {
    count.value++;
    counterObj.value.counter++;
    counterObj.value.text = 'Counter: ${counterObj.value.counter}';
    counterObj.refresh();
  }

  void incrementCounterMemory() => countMemory.value++;

  void incrementCounterHistory() => countHistory.value++;

  void saveToHistory() => countHistory.saveValue();

  void dispose() {
    print('-------StreamedValues BLOC DISPOSE--------');
    count.dispose();
    countMemory.dispose();
    countHistory.dispose();
  }
}
