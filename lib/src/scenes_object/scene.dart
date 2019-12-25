import 'package:flutter/material.dart';

///
/// This class is used to handle the scenes:
///
class Scene {
  Scene({this.widget, this.time, this.onShow});

  Widget widget;
  int time; // milliseconds
  Function onShow;
}

///
/// Class used in the cross fading between two scenes
///
class SceneBridge {
  SceneBridge(this.currentStage, this.old, this.next);

  int currentStage;
  Scene old;
  Scene next;
}
