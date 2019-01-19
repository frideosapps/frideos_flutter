import 'dart:async';

import 'package:flutter/material.dart';

import 'package:frideos/frideos_dart.dart';

import '../extended_asyncwidgets.dart';

///
/// A simple widget that animates a input string making a scrolling text
/// over a given time.
///
class ScrollingText extends StatefulWidget {
  ScrollingText(
      {@required this.text, @required this.scrollingDuration, this.style});

  final String text;
  final int scrollingDuration;
  final TextStyle style;

  @override
  ScrollingTextState createState() {
    return new ScrollingTextState();
  }
}

class ScrollingTextState extends State<ScrollingText> {
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
    // TODO: implement dispose
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: StreamedWidget<String>(
        initialData: '',
        stream: textStream.outStream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Text(snapshot.data, style: widget.style);
        },
        noDataChild: Text('NO DATA'),
      ),
    );
  }
}


