import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../core/core.dart';

import '../extended_asyncwidgets.dart';

const double initialBlurVel = 0.1;
const int blurRefreshTime = 20;

///
/// Fixed Blur
///
class BlurWidget extends StatelessWidget {
  const BlurWidget({
    @required this.child,
    @required this.sigmaX,
    @required this.sigmaY,
    Key key,
  })  : assert(child != null, 'The child argument is null.'),
        assert(sigmaX != null, 'The sigmaX argument is null.'),
        assert(sigmaY != null, 'The sigmaY argument is null.'),
        super(key: key);

  ///
  /// Child to blur
  ///
  final Widget child;

  ///
  /// Vvalue of the sigmaX parameter of the blur
  ///
  final double sigmaX;

  ///
  /// Value of the sigmaY parameter of the blur
  ///
  final double sigmaY;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: <Widget>[
          Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: child),
          ClipRect(
            child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                child: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  color: Colors.transparent,
                )),
          ),
        ],
      ),
    );
  }
}

///
/// Animated blur
///
class AnimatedBlurWidget extends StatefulWidget {
  const AnimatedBlurWidget(
      {@required this.child,
      Key key,
      this.initialSigmaX = 0.0,
      this.initialSigmaY = 0.0,
      this.finalSigmaX = 4.0,
      this.finalSigmaY = 8.0,
      this.duration = 5000,
      this.reverseAnimation = true,
      this.loop = true,
      this.refreshTime = blurRefreshTime})
      : assert(child != null, 'The child argument is null.'),
        super(key: key);

  ///
  /// Child to blur
  ///
  final Widget child;

  ///
  /// Initial value of the sigmaX parameter of the blur
  ///
  final double initialSigmaX;

  ///
  /// Initial value of the sigmaY parameter of the blur
  ///
  final double initialSigmaY;

  ///
  /// Final value of the sigmaX parameter of the blur
  ///
  final double finalSigmaX;

  ///
  /// Final value of the sigmaY parameter of the blur
  ///
  final double finalSigmaY;

  ///
  /// Time for the blur to reach the final values
  ///
  final int duration;

  ///
  /// Looping animation (default: false)
  ///
  final bool loop;

  ///
  /// Refresh time in milliseconds (default: 20)
  ///
  final int refreshTime;

  ///
  /// If set to true (default: true), when the max values are reached
  /// the animation reverses until the values reaches their initial value
  ///
  final bool reverseAnimation;

  @override
  _AnimatedBlurWidgetState createState() {
    return _AnimatedBlurWidgetState();
  }
}

class _AnimatedBlurWidgetState extends State<AnimatedBlurWidget> {
  AnimatedObject<double> blur;
  double blurSigmaY;

  @override
  void initState() {
    super.initState();

    blur = AnimatedObject(
        initialValue: widget.initialSigmaX, interval: widget.refreshTime);

    //blur.animation.value = widget.initialSigmaX;
    blurSigmaY = widget.initialSigmaY;

    // Calculate the step of the blur
    //
    var blurVelX = (widget.finalSigmaX - widget.initialSigmaX) /
        (widget.duration / widget.refreshTime);
    var blurVelY = (widget.finalSigmaY - widget.initialSigmaY) /
        (widget.duration / widget.refreshTime);

    blur.start((t) {
      // Update the blur.
      //
      blur.value += blurVelX;
      blurSigmaY += blurVelY;

      // Check if limit reached.
      //
      if (blur.value > widget.finalSigmaX) {
        // If the reverseAnimation flag is set to true (default)
        // then invert the direction.
        //
        if (widget.reverseAnimation) {
          blurVelX = -blurVelX;
          blurVelY = -blurVelY;
        } else {
          // If the loop flag is set true (default: false)
          // then reset the blur values
          //
          if (widget.loop) {
            blur.value = 0.0;
            blurSigmaY = 0.0;
          }
          // Otherwise, stop the animation.
          //
          else {
            blur.stop();
          }
        }
      }

      // Check if the value is below the initialValue.
      //
      if (blur.animation.value < widget.initialSigmaX) {
        // If the loop flag is set to true, invert the direction
        // of the animation.
        //
        if (widget.loop) {
          blurVelX = -blurVelX;
          blurVelY = -blurVelY;
        }
        // Otherwise, stop the animation.
        //
        else {
          blur.stop();
        }
      }
    });
  }

  @override
  void dispose() {
    blur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ValueBuilder<double>(
          streamed: blur.animation,
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: widget.child),
                ClipRect(
                  child: BackdropFilter(
                      filter: ui.ImageFilter.blur(
                          sigmaX: snapshot.data, sigmaY: blurSigmaY),
                      child: Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        color: Colors.transparent,
                      )),
                ),
              ],
            );
          }),
    );
  }
}

///
/// Blur in
///
class BlurInWidget extends StatefulWidget {
  const BlurInWidget(
      {@required this.child,
      Key key,
      this.initialSigmaX = 4.0,
      this.initialSigmaY = 6.0,
      this.duration = 5000,
      this.refreshTime = blurRefreshTime})
      : assert(child != null, 'The child argument is null.'),
        super(key: key);

  ///
  /// Child to blur
  ///
  final Widget child;

  ///
  /// Initial value of the sigmaX parameter of the blur
  ///
  final double initialSigmaX;

  ///
  /// Initial value of the sigmaY parameter of the blur
  ///
  final double initialSigmaY;

  ///
  /// Time for the blur to reach the final values
  ///
  final int duration;

  ///
  /// Refresh time in milliseconds (default: 20)
  ///
  final int refreshTime;

  @override
  _BlurInWidgetState createState() {
    return _BlurInWidgetState();
  }
}

class _BlurInWidgetState extends State<BlurInWidget> {
  AnimatedObject<double> blur;
  double blurSigmaY;

  @override
  void initState() {
    super.initState();
    blur = AnimatedObject(
        initialValue: widget.initialSigmaX, interval: blurRefreshTime);
    blur.value = widget.initialSigmaX;
    blurSigmaY = widget.initialSigmaY;

    // Calculate the step of the blur
    //
    var blurVelX = widget.initialSigmaX / (widget.duration / blurRefreshTime);
    final blurVelY = widget.initialSigmaY / (widget.duration / blurRefreshTime);

    blur.start((t) {
      blur.value -= blurVelX;
      blurSigmaY -= blurVelY;

      if (blur.value < 0.0) {
        blurVelX = 0.0;
        blurSigmaY = 0.0;
        blur.stop();
      }
    });
  }

  @override
  void dispose() {
    blur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ValueBuilder<double>(
          streamed: blur.animation,
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: widget.child),
                ClipRect(
                  child: BackdropFilter(
                      filter: ui.ImageFilter.blur(
                          sigmaX: snapshot.data, sigmaY: blurSigmaY),
                      child: Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        color: Colors.transparent,
                      )),
                ),
              ],
            );
          }),
    );
  }
}

///
/// Blur out
///
class BlurOutWidget extends StatefulWidget {
  const BlurOutWidget(
      {@required this.child,
      Key key,
      this.finalSigmaX = 4.0,
      this.finalSigmaY = 6.0,
      this.duration = 5000,
      this.refreshTime = blurRefreshTime})
      : assert(child != null, 'The child argument is null.'),
        super(key: key);

  ///
  /// Child to blur
  ///
  final Widget child;

  ///
  /// Final value of the sigmaX parameter of the blur
  ///
  final double finalSigmaX;

  ///
  /// Final value of the sigmaY parameter of the blur
  ///
  final double finalSigmaY;

  ///
  /// Time for the blur to reach the final values
  ///
  final int duration;

  ///
  /// Refresh time in milliseconds (default: 20)
  ///
  final int refreshTime;

  @override
  _BlurOutWidgetState createState() {
    return _BlurOutWidgetState();
  }
}

class _BlurOutWidgetState extends State<BlurOutWidget> {
  AnimatedObject<double> blur;
  double blurSigmaY = 0;

  @override
  void initState() {
    super.initState();

    blur = AnimatedObject(initialValue: 0, interval: blurRefreshTime);

    // Calculate the step of the blur
    //
    var blurVelX = widget.finalSigmaX / (widget.duration / blurRefreshTime);
    final blurVelY = widget.finalSigmaY / (widget.duration / blurRefreshTime);

    blur.start((t) {
      blur.value += blurVelX;
      blurSigmaY += blurVelY;

      if (blur.value > widget.finalSigmaX) {
        blurVelX = widget.finalSigmaX;
        blurSigmaY = widget.finalSigmaY;
        blur.stop();
      }
    });
  }

  @override
  void dispose() {
    blur.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ValueBuilder<double>(
          streamed: blur.animation,
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: widget.child),
                ClipRect(
                  child: BackdropFilter(
                      filter: ui.ImageFilter.blur(
                          sigmaX: snapshot.data, sigmaY: blurSigmaY),
                      child: Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        color: Colors.transparent,
                      )),
                ),
              ],
            );
          }),
    );
  }
}
