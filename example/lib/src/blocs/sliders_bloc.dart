import 'dart:math' as math;

import 'package:frideos/frideos_dart.dart';

import 'package:frideos_general/src/blocs/bloc.dart';


class SlidersBloc extends BlocBase {
  SlidersBloc() {
    angle.value = initialAngle;
    scale.value = initialScale;
  }

  final angle = StreamedValue<double>();
  final scale = StreamedValue<double>();

  //double initialAngle = math.pi / 2;
  double initialAngle = 2.2;
  double initialScale = 1.8;

/*
  sendWidget() {
    var stage = streamedValuesBloc.staged.getCurrentStage();
    sendWidgetsBloc.stageStream.inStream(stage);
    tunnelWidget.send(stage.child);
  }  
*/

  horizontalSlider(value) {
    //var rad = value * (math.pi / 180.0);
    //angle.value = rad;
    angle.value = value;
    //widget.bloc.timeUnit += value * 0.001;
    //widget.bloc.incrementTimeUnit(value * 0.0001);
    //print(rad);
  }

  verticalSlider(value) {
    scale.value = value;
    //print(value);
  }

  void dispose() {
    angle.dispose();
    scale.dispose();
  }
}
