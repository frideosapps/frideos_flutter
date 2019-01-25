import 'package:frideos/frideos_dart.dart';

import '../../blocs/bloc.dart';

class StagedPageTwoBloc extends BlocBase {
  StagedPageTwoBloc() {
    print('-------StagedPageTwo BLOC--------');
    receiverWidget.outStream.listen((map) {
      staged.setStagesMap(map);
    });
  }

  final receiverWidget = StreamedMap<int, Stage>();
  final receiverStr = StreamedValue<String>();

  // Create an instance with the setStagesMap constructor
  // or use the default constractor and the setStagesMap method
  final staged = StagedObject();

  final scrollingText = StreamedValue<String>();

  final timerObject = TimerObject();

  final map = Map<int, Stage>();

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
    print('-------StagedPageTwo BLOC DISPOSE--------');
    timerObject.dispose();
    staged.dispose();
    receiverWidget.dispose();
    receiverStr.dispose();
    scrollingText.dispose();
  }
}
