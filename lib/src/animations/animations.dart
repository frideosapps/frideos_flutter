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
    required this.duration,
    required this.setState,
    required this.tickerProvider,
    this.onAnimating,
  });

  final Duration duration;
  final dynamic setState;
  final TickerProvider tickerProvider;
  final AnimationStatusCallback? onAnimating;

  // Controller and getters
  late AnimationController baseController;
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
        onAnimating!(status);
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

  void stop({bool canceled = true}) {
    baseController.stop(canceled: canceled);
  }

  void reset() {
    baseController.reset();
  }
}

///
/// AnimationTween
///
///
///
///
class AnimationTween<T> extends AnimationBaseClass {
  AnimationTween({
    required TickerProvider tickerProvider,
    required Duration duration,
    this.begin,
    this.end,
    dynamic setState,
    this.controller,
    AnimationStatusCallback? onAnimating,
  })  : assert(begin != null && end != null),
        super(
          duration: duration,
          setState: setState,
          tickerProvider: tickerProvider,
          onAnimating: onAnimating,
        ) {
    // If a controller is not provided, then is
    // called the `init` method of the AnimationBaseClass to initialize
    // its `baseController`
    if (controller == null) {
      super.init();
    }

    animation = Tween<T>(begin: begin, end: end).animate(controller ?? baseController);
  }

  T? begin;
  T? end;

  AnimationController? controller;
  late Animation<T> animation;

  T get value => animation.value;
}

///
/// AnimationCurved
///
///
///
///
class AnimationCurved<T> extends AnimationBaseClass {
  AnimationCurved({
    required TickerProvider tickerProvider,
    required Duration duration,
    this.controller,
    this.begin,
    this.end,
    this.curve,
    this.reverseCurve,
    dynamic setState,
    AnimationStatusCallback? onAnimating,
  })  : assert(begin != null && end != null && curve != null),
        super(
          duration: duration,
          setState: setState,
          tickerProvider: tickerProvider,
          onAnimating: onAnimating,
        ) {
    // If a controller is not provided, then is
    // called the `init` method of the AnimationBaseClass to initialize
    // its `baseController`
    if (controller == null) {
      super.init();
    }
    animation = Tween<T>(begin: begin, end: end).animate(CurvedAnimation(
        parent: controller ?? baseController, curve: curve!, reverseCurve: reverseCurve));
  }

  T? begin;
  T? end;

  Curve? curve;
  Curve? reverseCurve;

  AnimationController? controller;
  late Animation<T> animation;

  T get value => animation.value;
}

///
///
///

typedef AnimationCreateBuilder = Widget Function(BuildContext context, AnimationCurved animation);

///
/// AnimationCreate
///
///
///
///
class AnimationCreate<T> extends StatefulWidget {
  const AnimationCreate({
    required this.begin,
    required this.end,
    required this.builder,
    this.onAnimating,
    this.onCompleted,
    this.onStart,
    super.key,
    this.curve = Curves.linear,
    this.reverseCurve = Curves.linear,
    this.duration = 1000,
    this.repeat = false,
    this.reverse = false,
  });

  final T begin;
  final T end;
  final Curve curve;
  final Curve reverseCurve;
  final int duration;
  final Function? onAnimating;
  final Function? onCompleted;
  final Function? onStart;
  final AnimationCreateBuilder builder;
  final bool repeat;
  final bool reverse;

  @override
  _AnimationCreateState<T> createState() => _AnimationCreateState<T>();
}

class _AnimationCreateState<T> extends State<AnimationCreate<T>>
    with SingleTickerProviderStateMixin {
  late AnimationCurved<T> animation;

  @override
  void initState() {
    super.initState();

    animation = AnimationCurved(
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
      widget.onStart!();
    }
  }

  @override
  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void _onAnimating(AnimationStatus status) {
    if (widget.repeat) {
      if (animation.status == AnimationStatus.completed) {
        if (widget.reverse) {
          animation.reverse();
        } else {
          animation.reset();
        }

        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
      } else if (animation.status == AnimationStatus.dismissed) {
        animation.forward();
        if (widget.onStart != null) {
          widget.onStart!();
        }
      }
    } else {
      if (animation.status == AnimationStatus.completed) {
        if (widget.reverse) {
          animation.reverse();
        }
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
      }
    }

    if (widget.onAnimating != null) {
      widget.onAnimating!();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, animation);
}

///
/// CompositeItem
///
///
///
///
class CompositeItem<T> {
  CompositeItem({
    required this.begin,
    required this.end,
    this.curve,
    this.reverseCurve,
  }) : assert(begin != null && end != null);

  final T begin;
  final T end;

  Curve? curve;
  Curve? reverseCurve;

  late Animation<dynamic> animation;
}

///
/// CompositeAnimation
///
///
///
///
class CompositeAnimation extends AnimationBaseClass {
  CompositeAnimation({
    required this.composite,
    required dynamic setState,
    required TickerProvider tickerProvider,
    required Duration duration,
    AnimationStatusCallback? onAnimating,
  })  : assert(
          composite.isNotEmpty && setState != null,
        ),
        super(
          duration: duration,
          setState: setState,
          tickerProvider: tickerProvider,
          onAnimating: onAnimating,
        ) {
    // Init the AnimationBaseClass
    super.init();

    composite.values.forEach((tween) {
      if (tween.curve == null) {
        if (tween.begin.runtimeType == MaterialColor) {
          tween.animation = ColorTween(begin: tween.begin, end: tween.end).animate(baseController);
        } else {
          tween.animation =
              Tween<dynamic>(begin: tween.begin, end: tween.end).animate(baseController);
        }
      } else {
        if (tween.begin.runtimeType == MaterialColor) {
          tween.animation = ColorTween(begin: tween.begin, end: tween.end).animate(baseController);
        } else {
          tween.animation = Tween<dynamic>(begin: tween.begin, end: tween.end).animate(
              CurvedAnimation(
                  parent: baseController, curve: tween.curve!, reverseCurve: tween.reverseCurve));
        }
      }
    });
  }

  final Map<dynamic, CompositeItem<dynamic>> composite;

  dynamic value(dynamic key) => composite[key]!.animation.value;

  int valueInt(dynamic key) => composite[key]!.animation.value.toInt();

  dynamic animation(dynamic key) => composite[key]!.animation;

  AnimationStatus animationStatus(dynamic key) => composite[key]!.animation.status;
}

///
///
///
///

typedef CompositeCreateBuilder = Widget Function(
    BuildContext context, CompositeAnimation compositeAnimation);

///
/// CompositeCreate
///
///
///
///
class CompositeCreate extends StatefulWidget {
  const CompositeCreate({
    required this.compositeMap,
    required this.onAnimating,
    required this.builder,
    Key? key,
    this.duration = 1000,
    this.repeat = false,
    this.onStart,
    this.onCompleted,
  }) : super(key: key);

  final int duration;
  final Map<dynamic, CompositeItem> compositeMap;
  final Function? onAnimating;
  final Function? onCompleted;
  final Function? onStart;
  final CompositeCreateBuilder builder;
  final bool repeat;

  @override
  _CompositeCreateState createState() => _CompositeCreateState();
}

class _CompositeCreateState extends State<CompositeCreate> with TickerProviderStateMixin {
  late CompositeAnimation compositeAnimation;

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
      widget.onStart!();
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
          widget.onCompleted!();
        }
      } else if (compositeAnimation.status == AnimationStatus.dismissed) {
        compositeAnimation.forward();
        if (widget.onStart != null) {
          widget.onStart!();
        }
      }
    } else {
      if (compositeAnimation.status == AnimationStatus.completed) {
        if (widget.onCompleted != null) {
          widget.onCompleted!();
        }
      }
    }

    if (widget.onAnimating != null) {
      widget.onAnimating!();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, compositeAnimation);
}
