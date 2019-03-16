import 'dart:async';

import 'package:frideos/frideos_dart.dart';

import '../blocs/bloc.dart';

class AnimatedObjectBloc extends BlocBase {
  AnimatedObjectBloc() {
    print('-------AnimatedObject BLOC--------');
  }

  // Initial value 0.5, updating interval 20 milliseconds
  final scaleAnimation =
      AnimatedObject<double>(initialValue: 0.5, interval: 20);

  final rotationAnimation =
      AnimatedObject<double>(initialValue: 0.5, interval: 20);

  void start() {
    scaleAnimation.start(updateScale);
    rotationAnimation.start(updateRotation);
  }

  void updateScale(Timer t) {
    scaleAnimation.value += 0.03;

    if (scaleAnimation.value > 8.0) {
      scaleAnimation.reset();
    }
  }

  void updateRotation(Timer t) {
    rotationAnimation.value += 0.1;
  }

  void stop() {
    scaleAnimation.stop();
    rotationAnimation.stop();
  }

  void reset() {
    scaleAnimation.reset();
    rotationAnimation.reset();
  }

  @override
  void dispose() {
    print('-------AnimatedObject BLOC DISPOSE--------');
    scaleAnimation.dispose();
    rotationAnimation.dispose();
  }
}
