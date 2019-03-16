import 'package:frideos/frideos_dart.dart';

import '../blocs/bloc.dart';

class TimerObjectBloc extends BlocBase {
  TimerObjectBloc() {
    print('-------TimerObject BLOC--------');
  }

  final timerObject = TimerObject();

  void startTimer() {
    timerObject.startTimer();
  }

  void stopTimer() {
    timerObject.stopTimer();
  }

  void getLapTime() {
    timerObject.getLapTime();
  }

  void dispose() {
    print('-------TimerObject BLOC DISPOSE--------');

    timerObject.dispose();
  }
}
