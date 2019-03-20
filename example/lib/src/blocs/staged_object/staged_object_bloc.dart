import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import '../../blocs/bloc.dart';

import 'staged_page_one_bloc.dart';
import 'staged_page_two_bloc.dart';

class StagedObjectBloc extends BlocBase {
  StagedObjectBloc() {
    print('-------STAGEDOBJECT BLOC--------');

    // Used to send the map with the stages
    blocA.tunnelSender.setReceiver(blocB.receiverWidget);

    //to send the message to the blocB
    blocA.tunnelSenderStr.setReceiver(blocB.receiverStr);
  }

  final blocA = StagedPageOneBloc();
  final blocB = StagedPageTwoBloc();

  // Create an instance with the setStagesMap constructor
  // or use the default constractor and the setStagesMap method
  // final staged = StagedObject.withMap(stagesMap, absoluteTiming: false);

  final staged = StagedObject();

  final text = StreamedValue<String>();
  final widget = StreamedValue<Widget>();

  final stage = StreamedValue<StageBridge>();

  // The map can be set through the constructor of the StagedObject
  // or by the setStagesMap method like in this case.
  void setMap(Map<int, Stage> stagesMap) {
    staged.setStagesMap(stagesMap);
  }

  void start() {
    if (staged.getMapLength() > 0) {
      staged
        ..setCallback(sendNextStageText)
        ..startStages();
    }
  }

  void sendNextStageText() {
    print('change stage');

    final nextStage = staged.getNextStage();
    if (nextStage != null) {
      text.value = 'Next stage:';
      widget.value = nextStage.widget;
      stage.value = StageBridge(
          staged.getStageIndex(), staged.getCurrentStage(), nextStage);
    } else {
      text.value = 'This is the last stage';
      widget.value = Container();
    }
  }

  @override
  void dispose() {
    print('-------STAGEDOBJECT BLOC DISPOSE--------');

    blocA.dispose();
    blocB.dispose();
    staged.dispose();
    text.dispose();
    widget.dispose();
    stage.dispose();
  }
}
