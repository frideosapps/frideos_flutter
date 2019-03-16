import 'dart:async';
import 'dart:math' as math;

import 'package:frideos/frideos_dart.dart';

import '../blocs/bloc.dart';

class StagedWidgetBloc extends BlocBase {
  StagedWidgetBloc() {
    print('-------StagedWidget BLOC--------');
  }

  // Initial value 0.5, updating interval 20 milliseconds
  final rotateAnimation =
      AnimatedObject<double>(initialValue: 0.0, interval: 20);

  void startRotate() {
    rotateAnimation.start(updateRotate);
  }

  void updateRotate(Timer t) {
    rotateAnimation.animation.value += 0.04;

    if (rotateAnimation.animation.value > math.pi * 2) {
      //rotateAnimation.reset();
      rotateAnimation.animation.value = math.pi * 2;
      stopRotate();
    }
  }

  void stopRotate() {
    rotateAnimation.stop();
  }

  void resetRotate() {
    rotateAnimation.reset();
  }

  // Initial value 0.5, updating interval 20 milliseconds
  final scaleAnimation =
      AnimatedObject<double>(initialValue: 1.0, interval: 20);

  void startScale() {
    scaleAnimation.start(updateScale);
  }

  void updateScale(Timer t) {
    scaleAnimation.animation.value -= 0.002;

    if (scaleAnimation.animation.value < 0.1) {
      scaleAnimation.animation.value = 0.1;
    }
  }

  void stopScale() {
    scaleAnimation.stop();
  }

  void resetScale() {
    scaleAnimation.reset();
  }

  void stagedOnStart() {
    print('Change stage');
  }

  @override
  void dispose() {
    print('-------StagedWidget BLOC DISPOSE--------');
    rotateAnimation.dispose();
    scaleAnimation.dispose();
  }
}
