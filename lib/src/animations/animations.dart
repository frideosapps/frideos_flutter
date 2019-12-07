import 'package:flutter/material.dart';

typedef AnimationStatusCallback = Function(AnimationStatus status);

///
/// AnimationBaseClass
///
///
///
///
class AnimationBaseClass {
  AnimationBaseClass({
    this.duration,
    this.setState,
    this.tickerProvider,
    this.onAnimating,
  });

  final Duration duration;
  final dynamic setState;
  final TickerProvider tickerProvider;
  final AnimationStatusCallback onAnimating;

  // Controller and getters
  AnimationController baseController;
  AnimationStatus get status => baseController.status;

  bool get isAnimating => baseController.isAnimating;
  bool get isCompleted => baseController.isCompleted;
  bool get isDismissed => baseController.isDismissed;

  double get controllerValue => baseController.value;
  double get progress => controllerValue * 100.0;

  void init() {
    baseController = AnimationController(
      duration: duration,
      vsync: tickerProvider,
    );

    if (onAnimating != null) {
      baseController.addListener(() {
        setState(() {});
        onAnimating(status);
      });
    } else {
      baseController.addListener(() {
        setState(() {});
      });
    }
  }

  void forward() {
    baseController.forward();
  }

  void reverse() {
    baseController.reverse();
  }

  void dispose() {
    baseController.dispose();
  }
}

///
/// TweenAnimation
///
///
///
///
class TweenAnimation<T> extends AnimationBaseClass {
  TweenAnimation(
      {@required this.begin,
      @required this.end,
      dynamic setState,
      TickerProvider tickerProvider,
      Duration duration,
      this.controller,
      AnimationStatusCallback onAnimating})
      : assert(begin != null && end != null),
        super(
            duration: duration,
            setState: setState,
            tickerProvider: tickerProvider,
            onAnimating: onAnimating) {
    // If a controller is not provided, then is
    // called the `init` method of the AnimationBaseClass to initialize
    // its `baseController`
    if (controller == null) {
      super.init();
    }

    animation =
        Tween<T>(begin: begin, end: end).animate(controller ?? baseController);
  }

  final T begin;
  final T end;

  final AnimationController controller;
  Animation<T> animation;

  T get value => animation.value;
}

///
/// CurvedTween
///
///
///
///
class CurvedTween<T> extends AnimationBaseClass {
  CurvedTween({
    @required this.begin,
    @required this.end,
    @required this.curve,
    dynamic setState,
    TickerProvider tickerProvider,
    Duration duration,
    this.reverseCurve,
    this.controller,
    AnimationStatusCallback onAnimating,
  })  : assert(begin != null && end != null && curve != null),
        super(
            duration: duration,
            setState: setState,
            tickerProvider: tickerProvider,
            onAnimating: onAnimating) {
    // If a controller is not provided, then is
    // called the `init` method of the AnimationBaseClass to initialize
    // its `baseController`
    if (controller == null) {
      super.init();
    }
    animation = Tween<T>(begin: begin, end: end).animate(CurvedAnimation(
        parent: controller ?? baseController,
        curve: curve,
        reverseCurve: reverseCurve));
  }

  final T begin;
  final T end;

  final Curve curve;
  final Curve reverseCurve;

  final AnimationController controller;
  Animation<T> animation;

  T get value => animation.value;
}

///
/// CompositeAnimation
///
///
///
///
class CompositeAnimation extends AnimationBaseClass {
  CompositeAnimation({
    @required this.composite,
    @required dynamic setState,
    @required TickerProvider tickerProvider,
    @required Duration duration,
    AnimationStatusCallback onAnimating,
  })  : assert(composite != null &&
            composite.isNotEmpty &&
            setState != null &&
            tickerProvider != null &&
            duration != null),
        super(
            duration: duration,
            setState: setState,
            tickerProvider: tickerProvider,
            onAnimating: onAnimating) {
    // Init the AnimationBaseClass
    super.init();

    composite.values.forEach((tween) {
      if (tween.curve == null) {
        if (tween.begin.runtimeType == MaterialColor) {
          tween.animation = ColorTween(begin: tween.begin, end: tween.end)
              .animate(baseController);
        } else {
          tween.animation = Tween<dynamic>(begin: tween.begin, end: tween.end)
              .animate(baseController);
        }
      } else {
        if (tween.begin.runtimeType == MaterialColor) {
          tween.animation = ColorTween(begin: tween.begin, end: tween.end)
              .animate(baseController);
        } else {
          tween.animation = Tween<dynamic>(begin: tween.begin, end: tween.end)
              .animate(CurvedAnimation(
                  parent: baseController,
                  curve: tween.curve,
                  reverseCurve: tween.reverseCurve));
        }
      }
    });
  }

  final Map<String, CompositeTween<dynamic>> composite;

  dynamic value(String key) {
    return composite[key].animation.value;
  }
}

///
/// CompositeTween
///
///
///
///
class CompositeTween<T> {
  CompositeTween({
    @required this.begin,
    @required this.end,
    this.curve,
    this.reverseCurve,
  }) : assert(begin != null && end != null);

  final T begin;
  final T end;

  final Curve curve;
  final Curve reverseCurve;

  Animation<dynamic> animation;
}
