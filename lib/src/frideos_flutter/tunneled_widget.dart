import 'package:flutter/material.dart';

import 'package:frideos/frideos_dart.dart';

import 'extended_asyncwidgets.dart';

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
