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

  start() {
    scaleAnimation.start(updateScale);
    rotationAnimation.start(updateRotation);
  }

  updateScale(Timer t) {
    scaleAnimation.value += 0.03;

    if (scaleAnimation.value > 8.0) {
      scaleAnimation.reset();
    }
  }

  updateRotation(Timer t) {
    rotationAnimation.value += 0.1;
  }


  stop() {
    scaleAnimation.stop();
    rotationAnimation.stop();
  }

  reset() {
    scaleAnimation.reset();
    rotationAnimation.reset();
  }

  dispose() {
    print('-------AnimatedObject BLOC DISPOSE--------');
    scaleAnimation.dispose();
    rotationAnimation.dispose();
  }
}
