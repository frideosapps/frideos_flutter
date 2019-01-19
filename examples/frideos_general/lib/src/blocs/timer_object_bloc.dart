import 'package:frideos/frideos_dart.dart';

import 'package:frideos_general/src/blocs/bloc.dart';


class TimerObjectBloc extends BlocBase {
  TimerObjectBloc() {
    print('-------TimerObject BLOC--------');
  }

  final timerObject = TimerObject();

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
    print('-------TimerObject BLOC DISPOSE--------');

    timerObject.dispose();
  }
}
