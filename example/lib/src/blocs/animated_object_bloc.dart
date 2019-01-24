import 'dart:async';

import 'package:frideos/frideos_dart.dart';

import 'package:frideos_general/src/blocs/bloc.dart';

class AnimatedObjectBloc extends BlocBase {
  AnimatedObjectBloc() {
    print('-------AnimatedObject BLOC--------');    
  }

  // Initial value 0.5, updating interval 20 milliseconds
  final scaleAnimation =
      AnimatedObject<double>(initialValue: 0.5, interval: 20);

  start() {
    scaleAnimation.start(updateScale);
  }

  updateScale(Timer t) {
    scaleAnimation.animation.value += 0.02;

    if (scaleAnimation.animation.value > 5.0) {
      scaleAnimation.reset();
    }
  }

  stop() {
    scaleAnimation.stop();
  }

  reset() {
    scaleAnimation.reset();
  }

  dispose() {
    print('-------AnimatedObject BLOC DISPOSE--------');
    scaleAnimation.dispose();
  }
}
