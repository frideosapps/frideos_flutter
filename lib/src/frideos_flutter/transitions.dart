import 'dart:async';

import 'package:flutter/material.dart';

import 'extended_asyncwidgets.dart';
import '../frideos_dart/streamed_value.dart';
import '../frideos_dart/models/stage.dart';


///
///
/// Fade out transition widget.
///
///
class FadeOutWidget extends StatefulWidget {
  FadeOutWidget(
      {Key key,
      @required this.child,
      @required this.duration,
      this.curve = Curves.linear})
      : super(key: key);

  final Widget child;
  final int duration;
  final Curve curve;

  @override
  _FadeOutWidgetState createState() {
    return new _FadeOutWidgetState();
  }
}

class _FadeOutWidgetState extends State<FadeOutWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation animationCurve;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    animationCurve = CurvedAnimation(parent: controller, curve: widget.curve);

    animationCurve.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Opacity(
          opacity: 1.0 - animationCurve.value,
          child: widget.child,
        ),
      ],
    ));
  }
}


///
///
/// Fade in transition widget.
///
///
class FadeInWidget extends StatefulWidget {
  FadeInWidget(
      {Key key,
      @required this.child,
      @required this.duration,
      this.curve = Curves.linear})
      : super(key: key);

  final Widget child;
  final int duration;
  final Curve curve;

  @override
  _FadeInWidgetState createState() {
    return new _FadeInWidgetState();
  }
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation animationCurve;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    animationCurve = CurvedAnimation(parent: controller, curve: widget.curve);

    animationCurve.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Opacity(
          opacity: animationCurve.value,
          child: widget.child,
        ),
      ],
    ));
  }
}



///
/// Class used in the cross fading between two stages
///
class StageBridge {
  int currentStage;
  Stage old;
  Stage next;
  StageBridge(this.currentStage, this.old, this.next);
}

///
///
/// Linear cross fading transition between two widgets, it can be used with the [StagedObject].
///
///
class LinearTransition extends StatefulWidget {
  LinearTransition(
      {Key key,
      @required this.firstWidget,
      @required this.secondWidget,
      @required this.transitionDuration})
      : super(key: key);

  final Widget firstWidget;
  final Widget secondWidget;
  final int transitionDuration;

  @override
  _LinearTransitionState createState() {
    return new _LinearTransitionState();
  }
}

class _LinearTransitionState extends State<LinearTransition> {
  final opacity = StreamedValue<double>();
  Timer timer;
  int interval;
  double opacityVel;

  _updateOpacity(Timer t) {
    var newOpacity = opacity.value + opacityVel;
    if (newOpacity > 1.0) {
      newOpacity = 1.0;
      timer.cancel();
    }

    opacity.value = newOpacity;
  }

  @override
  void initState() {
    super.initState();
    opacity.value = 0.0;
    interval = 20;
    opacityVel = 1.0 / (widget.transitionDuration / interval);
    timer = Timer.periodic(Duration(milliseconds: interval), _updateOpacity);
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
      child: StreamedWidget<double>(
        initialData: 0,
        stream: opacity.outStream,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          return Stack(
            children: <Widget>[
              Opacity(
                opacity: 1.0 - snapshot.data,
                child: widget.firstWidget,
              ),
              Opacity(
                opacity: snapshot.data,
                child: widget.secondWidget,
              ),
            ],
          );
        },
        noDataChild: Text('NO DATA'),
      ),
    );
  }
}

///
///
/// Cross fading transition between two widgets. This uses the Flutter way to make an
/// animation.
///
///
class CurvedTransition extends StatefulWidget {
  CurvedTransition(
      {Key key,
      @required this.firstWidget,
      @required this.secondWidget,
      @required this.transitionDuration,
      this.curve})
      : super(key: key);

  final Widget firstWidget;
  final Widget secondWidget;
  final int transitionDuration;
  final Curve curve;

  @override
  _CurvedTransitionState createState() {
    return new _CurvedTransitionState();
  }
}

class _CurvedTransitionState extends State<CurvedTransition>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation animationCurve;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.transitionDuration),
        vsync: this);
    animationCurve = CurvedAnimation(parent: controller, curve: widget.curve);

    animationCurve.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        Opacity(
          opacity: 1.0 - animationCurve.value,
          child: widget.firstWidget,
        ),
        Opacity(
          opacity: animationCurve.value,
          child: widget.secondWidget,
        ),
      ],
    ));
  }
}
