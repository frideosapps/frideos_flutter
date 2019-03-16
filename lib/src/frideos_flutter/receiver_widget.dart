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
  const ReceiverWidget({Key key, this.stream})
      : assert(stream != null, 'The strean argument is null.'),
        super(key: key);

  final Stream<Widget> stream;

  @override
  Widget build(BuildContext context) {
    return StreamedWidget<Widget>(
        stream: stream, builder: (context, snapshot) => snapshot.data);
  }
}
