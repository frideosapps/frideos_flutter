import 'package:flutter/material.dart';

import 'package:frideos/frideos_dart.dart';
import 'package:frideos/frideos_flutter.dart';

import '../../blocs/bloc.dart';

import 'staged_page_one_bloc.dart';
import 'staged_page_two_bloc.dart';

class StagedObjectBloc extends BlocBase {
  final blocA = StagedPageOneBloc();
  final blocB = StagedPageTwoBloc();

  // Create an instance with the setStagesMap constructor
  // or use the default constractor and the setStagesMap method
  // final staged = StagedObject.withMap(stagesMap, absoluteTiming: false);

  final staged = StagedObject();

  final text = StreamedValue<String>();
  final widget = StreamedValue<Widget>();

  final stage = StreamedValue<StageBridge>();

  StagedObjectBloc() {
    print('-------STAGEDOBJECT BLOC--------');

    // Used to send the map with the stages
    blocA.tunnelSender.setReceiver(blocB.receiverWidget);

    //to send the message to the blocB
    blocA.tunnelSenderStr.setReceiver(blocB.receiverStr);
  }

  // The map can be set through the constructor of the StagedObject
  // or by the setStagesMap method like in this case.
  setMap(Map<int, Stage> stagesMap) {
    staged.setStagesMap(stagesMap);
  }

  start() {
    if (staged.getMapLength() > 0) {
      staged.setCallback(sendNextStageText);
      staged.startStages();
    }
  }

  sendNextStageText() {
    print('change stage');

    var nextStage = staged.getNextStage();
    if (nextStage != null) {
      text.value = "Next stage:";
      widget.value = nextStage.widget;
      stage.value = StageBridge(
          staged.getStageIndex(), staged.getCurrentStage(), nextStage);
    } else {
      text.value = "This is the last stage";
      widget.value = Container();
    }
  }

  dispose() {
    print('-------STAGEDOBJECT BLOC DISPOSE--------');

    blocA.dispose();
    blocB.dispose();
    staged.dispose();
    text.dispose();
    widget.dispose();
    stage.dispose();
  }
}
