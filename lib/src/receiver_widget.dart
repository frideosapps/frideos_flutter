import 'dart:async';

import 'package:flutter/material.dart';

import 'extended_asyncwidgets.dart';

///
/// Used with a [Stream] when the type is a widget to
/// directly stream a widget to the view. Under the hood
/// a [StreamedWidget] handles the stream and shows
/// the widget.
///
///
class ReceiverWidget extends StatelessWidget {
  const ReceiverWidget({
    super.key,
    required this.stream,
  });

  final Stream<Widget> stream;

  @override
  Widget build(BuildContext context) {
    return StreamedWidget<Widget>(stream: stream, builder: (context, snapshot) => snapshot.data!);
  }
}
