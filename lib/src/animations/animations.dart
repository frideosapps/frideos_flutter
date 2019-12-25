import 'package:flutter/material.dart';

///
///
///

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

  void stop({bool canceled}) {
    baseController.stop(canceled: canceled);
  }

  void reset() {
    baseController.reset();
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
    this.controller,
    @required this.begin,
    @required this.end,
    @required this.curve,
    this.reverseCurve,
    dynamic setState,
    TickerProvider tickerProvider,
    Duration duration,
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
///
///

typedef AnimationWidgetBuilder = Widget Function(
    BuildContext context, CurvedTween animation);

///
/// AnimationWidget
///
///
///
///
class AnimationWidget<T> extends StatefulWidget {
  const AnimationWidget({
    Key key,
    @required this.begin,
    @required this.end,
    this.curve = Curves.linear,
    this.reverseCurve = Curves.linear,
    this.duration = 1000,
    this.repeat = false,
    this.reverse = false,
    this.onAnimating,
    this.onStart,
    this.onCompleted,
    this.builder,
  }) : super(key: key);

  final T begin;
  final T end;
  final Curve curve;
  final Curve reverseCurve;
  final int duration;
  final Function onAnimating;
  final Function onCompleted;
  final Function onStart;
  final AnimationWidgetBuilder builder;
  final bool repeat;
  final bool reverse; // TODO

  @override
  _AnimationWidgetState<T> createState() => _AnimationWidgetState<T>();
}

class _AnimationWidgetState<T> extends State<AnimationWidget<T>>
    with SingleTickerProviderStateMixin {
  CurvedTween<T> animation;

  @override
  void initState() {
    super.initState();

    animation = CurvedTween(
      begin: widget.begin,
      end: widget.end,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
      duration: Duration(milliseconds: widget.duration),
      setState: setState,
      tickerProvider: this,
      onAnimating: _onAnimating,
    )..forward();

    if (widget.onStart != null) {
      widget.onStart();
    }
  }

  @override
  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

/*
  void _onAnimating(AnimationStatus status) {
    if (widget.repeat) {
      if (animation.status == AnimationStatus.completed) {
        animation.reverse();
        if (widget.onCompleted != null) {
          widget.onCompleted();
        }
      } else if (animation.status == AnimationStatus.dismissed) {
        animation.forward();
        if (widget.onStart != null) {
          widget.onStart();
        }
      }
    } else {
      if (animation.status == AnimationStatus.completed) {
        if (widget.reverse) {
          animation.reverse();
        }
        if (widget.onCompleted != null) {
          widget.onCompleted();
        }
      }
    }
    

    if (widget.onAnimating != null) {
      widget.onAnimating();
    }
  }
*/
  void _onAnimating(AnimationStatus status) {
    if (widget.repeat) {
      if (animation.status == AnimationStatus.completed) {
        animation.reverse();
        if (widget.onCompleted != null) {
          widget.onCompleted();
        }
      } else if (animation.status == AnimationStatus.dismissed) {
        animation.forward();
        if (widget.onStart != null) {
          widget.onStart();
        }
      }
    } else {
      if (animation.status == AnimationStatus.completed) {
        if (widget.onCompleted != null) {
          widget.onCompleted();
        }
      }
    }

    if (widget.onAnimating != null) {
      widget.onAnimating();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, animation);
  }
}

///
/// CompositeAnimation
///
///
///
///
/*
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
*/

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

  final Map<dynamic, CompositeTween<dynamic>> composite;

  dynamic value(dynamic key) => composite[key].animation.value;

  int valueInt(dynamic key) => composite[key].animation.value.toInt();

  dynamic animation(dynamic key) => composite[key].animation;

  AnimationStatus animationStatus(dynamic key) =>
      composite[key].animation.status;
}

///
///
///
///

typedef CompositeWidgetBuilder = Widget Function(
    BuildContext context, CompositeAnimation compositeAnimation);

///
/// CompositeAnimationWidget
///
///
///
///
class CompositeAnimationWidget extends StatefulWidget {
  const CompositeAnimationWidget({
    Key key,
    this.duration = 1000,
    this.compositeMap,
    this.repeat = false,
    this.onAnimating,
    this.onStart,
    this.onCompleted,
    this.builder,
  }) : super(key: key);

  final int duration;
  final Map<dynamic, CompositeTween> compositeMap;
  final Function onAnimating;
  final Function onCompleted;
  final Function onStart;
  final CompositeWidgetBuilder builder;
  final bool repeat;

  @override
  _CompositeAnimationWidgetState createState() =>
      _CompositeAnimationWidgetState();
}

class _CompositeAnimationWidgetState extends State<CompositeAnimationWidget>
    with TickerProviderStateMixin {
  CompositeAnimation compositeAnimation;

  @override
  void initState() {
    super.initState();

    compositeAnimation = CompositeAnimation(
      duration: Duration(milliseconds: widget.duration),
      setState: setState,
      tickerProvider: this,
      onAnimating: _onAnimating,
      composite: widget.compositeMap,
    )..forward();

    if (widget.onStart != null) {
      widget.onStart();
    }
  }

  @override
  @override
  void dispose() {
    compositeAnimation.dispose();
    super.dispose();
  }

  void _onAnimating(AnimationStatus status) {
    if (widget.repeat) {
      if (compositeAnimation.status == AnimationStatus.completed) {
        compositeAnimation.reverse();
        if (widget.onCompleted != null) {
          widget.onCompleted();
        }
      } else if (compositeAnimation.status == AnimationStatus.dismissed) {
        compositeAnimation.forward();
        if (widget.onStart != null) {
          widget.onStart();
        }
      }
    } else {
      if (compositeAnimation.status == AnimationStatus.completed) {
        if (widget.onCompleted != null) {
          widget.onCompleted();
        }
      }
    }

    if (widget.onAnimating != null) {
      widget.onAnimating();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, compositeAnimation);
  }
}
