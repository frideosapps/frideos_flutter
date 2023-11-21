import 'dart:async';

import 'package:flutter/material.dart';

import '../core/core.dart';
import '../extended_asyncwidgets.dart';

///
///
/// Fade out transition widget.
///
///
class FadeOutWidget extends StatefulWidget {
  const FadeOutWidget(
      {required this.child, required this.duration, Key? key, this.curve = Curves.linear})
      : super(key: key);

  final Widget child;
  final int duration;
  final Curve curve;

  @override
  State<FadeOutWidget> createState() {
    return _FadeOutWidgetState();
  }
}

class _FadeOutWidgetState extends State<FadeOutWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation animationCurve;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    animationCurve = CurvedAnimation(parent: controller, curve: widget.curve)
      ..addListener(() {
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
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 1.0 - animationCurve.value,
          child: widget.child,
        ),
      ],
    );
  }
}

///
///
/// Fade in transition widget.
///
///
class FadeInWidget extends StatefulWidget {
  const FadeInWidget(
      {required this.child, required this.duration, Key? key, this.curve = Curves.linear})
      : super(key: key);

  final Widget child;
  final int duration;
  final Curve curve;

  @override
  State<FadeInWidget> createState() {
    return _FadeInWidgetState();
  }
}

class _FadeInWidgetState extends State<FadeInWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation animationCurve;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: widget.duration), vsync: this);
    animationCurve = CurvedAnimation(parent: controller, curve: widget.curve)
      ..addListener(() {
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
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: animationCurve.value,
          child: widget.child,
        ),
      ],
    );
  }
}

///
///
/// Linear cross fading transition between two widgets, it can be used
/// with the `StagedObject`.
///
///
class LinearTransition extends StatefulWidget {
  const LinearTransition({
    required this.firstWidget,
    required this.secondWidget,
    required this.transitionDuration,
    Key? key,
  }) : super(key: key);

  final Widget firstWidget;
  final Widget secondWidget;
  final int transitionDuration;

  @override
  State<LinearTransition> createState() {
    return _LinearTransitionState();
  }
}

class _LinearTransitionState extends State<LinearTransition> {
  final StreamedValue<double> opacity = StreamedValue<double>();
  Timer? timer;
  late int interval;
  late double opacityVel;

  void _updateOpacity(Timer t) {
    var newOpacity = opacity.value + opacityVel;
    if (newOpacity > 1.0) {
      newOpacity = 1.0;
      if (timer != null) {
        timer!.cancel();
      }
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
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<double>(
      streamed: opacity,
      builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            Opacity(
              opacity: 1.0 - snapshot.data!,
              child: widget.firstWidget,
            ),
            Opacity(
              opacity: snapshot.data!,
              child: widget.secondWidget,
            ),
          ],
        );
      },
      noDataChild: widget.firstWidget,
    );
  }
}

///
///
/// Cross fading transition between two widgets. This uses the Flutter
/// way to make an animation.
///
///
class CurvedTransition extends StatefulWidget {
  const CurvedTransition({
    required this.firstWidget,
    required this.secondWidget,
    required this.transitionDuration,
    Key? key,
    required this.curve,
  }) : super(key: key);

  final Widget firstWidget;
  final Widget secondWidget;
  final int transitionDuration;
  final Curve curve;

  @override
  State<CurvedTransition> createState() {
    return _CurvedTransitionState();
  }
}

class _CurvedTransitionState extends State<CurvedTransition> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation animationCurve;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: Duration(milliseconds: widget.transitionDuration), vsync: this);
    animationCurve = CurvedAnimation(parent: controller, curve: widget.curve)
      ..addListener(() {
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
    return Stack(
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
    );
  }
}
