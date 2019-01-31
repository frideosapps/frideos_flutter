import 'package:flutter/material.dart';

import 'receiver_widget.dart';
import '../frideos_dart/models/stage.dart';
import '../frideos_dart/staged_object.dart';



///
///
/// This widget uses a [StagedObject] for the timing of the widgets
/// visualization.
/// 
/// It takes as a parameter a Map<int, Stage> and plays every [Stage].
/// 
/// By default to change the stage is used the relative time, so the time
/// parameter of the [Stage] indicates how much time the stage will lasts. Instead, 
/// to specify the absolute time, set to true the [absoluteTiming] flag, in this case
/// the time parameter indicates the absolute time when to show the widget.
///
/// The [onStart] is used to call a function when the StagesObject begins
/// to play the stages.
/// 
/// The [onEnd] callback is called at the end of the last stage when the timeing is relative 
/// (the [absoluteTiming] flag is set to false).
/// 
///
class StagedWidget extends StatefulWidget {
  StagedWidget(
      {@required this.stagesMap,
      this.absoluteTiming = false,
      this.onStart,
      this.onEnd});

  final Map<int, Stage> stagesMap;
  final bool absoluteTiming;
  final Function() onStart;
  final Function() onEnd;

  @override
  _StagedWidgetState createState() {
    return new _StagedWidgetState();
  }
}

class _StagedWidgetState extends State<StagedWidget> {
  final staged = StagedObject();

  @override
  void initState() {
    super.initState();
    if (widget.onStart != null) {
      staged.setCallback(widget.onStart);
    }
    if (widget.onEnd != null) {
      staged.setOnEndCallback(widget.onEnd);
    }
    staged.setStagesMap(widget.stagesMap);
    staged.startStages();
  }

  @override
  void dispose() {
    staged.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReceiverWidget(
      stream: staged.widgetStream,
    );
  }
}
