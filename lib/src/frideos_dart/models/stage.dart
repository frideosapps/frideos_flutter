import 'package:flutter/material.dart';

///
/// This class is used to handle the stages:
///
class Stage {
  Widget widget;
  int time; // milliseconds
  Function onShow = () {};
  Stage({this.widget, this.time, this.onShow});
}