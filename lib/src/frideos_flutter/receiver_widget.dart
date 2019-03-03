import 'dart:async';

import 'package:flutter/material.dart';

import 'extended_asyncwidgets.dart';

///
/// Used with a StreamedValue when the type is a widget to
/// directly stream a widget to the view. Under the hood
/// a ValueBuilder handles the stream and shows
/// the widget.
///
///
class ReceiverWidget extends StatelessWidget {
  ReceiverWidget({this.stream});

  final Stream<Widget> stream;

  @override
  Widget build(BuildContext context) {
    return StreamedWidget(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) =>
            snapshot.data);
  }
}
