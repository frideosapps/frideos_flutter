import 'package:flutter/material.dart';

///
/// This class is used to handle the stages:
///
class Stage {
  Stage({this.widget, this.time, this.onShow});
  Widget widget;
  int time; // milliseconds
  Function onShow;
}
