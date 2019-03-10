import 'dart:async';

import 'package:flutter/material.dart';

import '../frideos_dart/streamed_value.dart';
import '../frideos_dart/utils.dart';

import 'extended_asyncwidgets.dart';

///
/// A simple widget that animates a input string making a scrolling text
/// over a given time.
///
class ScrollingText extends StatefulWidget {
  ScrollingText(
      {Key key,
      @required this.text,
      @required this.scrollingDuration,
      this.style})
      : assert(text != null, "The text argument is null."),
        assert(
            scrollingDuration != null, "The scrollDuration argument is null."),
        super(key: key);

  final String text;
  final int scrollingDuration;
  final TextStyle style;

  @override
  _ScrollingTextState createState() {
    return new _ScrollingTextState();
  }
}

class _ScrollingTextState extends State<ScrollingText> {
  final textStream = StreamedValue<String>();
  Timer timer;

  showText(String str) {
    if (timer != null) {
      if (timer.isActive) {
      } else {
        startShowingText(str);
      }
    } else {
      startShowingText(str);
    }
  }

  startShowingText(String str) {
    timer = Utils.sendText(str, textStream, null, widget.scrollingDuration);
  }

  @override
  void initState() {
    super.initState();
    showText(widget.text);
  }

  @override
  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: StreamedWidget<String>(
        initialData: '',
        stream: textStream.outStream,
        builder: (context, snapshot) {
          return Text(snapshot.data, style: widget.style);
        },
        noDataChild: Text('NO DATA'),
      ),
    );
  }
}
