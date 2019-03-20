import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';
import 'package:frideos/frideos_dart.dart';

import '../blocs/staged_widget_bloc.dart';

class StagedWidgetPage extends StatelessWidget {
  const StagedWidgetPage({this.bloc});

  final StagedWidgetBloc bloc;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final Shader linearGradient = LinearGradient(
      colors: <Color>[Colors.red[900], Colors.blue[900]],
    ).createShader(Rect.fromLTWH(width / 2 - 50.0, 0.0, width / 2 + 50.0, 5.0));

    final Shader linearGradient2 = LinearGradient(
      colors: <Color>[Colors.blue[900], Colors.lime[300]],
    ).createShader(Rect.fromLTWH(width / 2 - 50.0, 0.0, width / 2 + 50.0, 5.0));

    Widget _background(MaterialColor color) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5, 1.0],
            colors: [
              color[900],
              color[600],
              color[300],
            ],
          ),
        ),
      );
    }

    final backgrounds = [
      _background(Colors.blue),
      _background(Colors.pink),
      _background(Colors.blueGrey),
      _background(Colors.orange),
    ];

    final shadows = <Shadow>[
      const Shadow(offset: Offset(6, 6), blurRadius: 5, color: Colors.black),
      Shadow(
          offset: const Offset(6, 6),
          blurRadius: 10,
          color: Colors.blueGrey[900]),
    ];

    final stagesMap = <int, Stage>{
      0: Stage(
          widget: Container(
              key: const Key('0'),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // BACKGROUND TRANSITION
                  LinearTransition(
                    firstWidget: backgrounds[0],
                    secondWidget: backgrounds[1],
                    transitionDuration: 4000,
                  ),
                  // FOREGROUND TRANSITION
                  FadeInWidget(
                    child: Center(
                      child: ValueBuilder(
                          streamed: bloc.rotateAnimation.animation,
                          builder: (context, snapshot) {
                            return Transform.rotate(
                                angle: snapshot.data,
                                child: FadeInWidget(
                                  duration: 5000,
                                  child: ScrollingText(
                                    text: 'Flutter',
                                    scrollingDuration: 4000,
                                    style: TextStyle(
                                        //color: Colors.blue[800],
                                        fontSize: 94,
                                        fontWeight: FontWeight.w500,
                                        foreground: Paint()
                                          ..shader = linearGradient,
                                        shadows: shadows),
                                  ),
                                ));
                          }),
                    ),
                    duration: 5000,
                  ),
                ],
              )),
          time: 5000,
          onShow: () {
            print('Stage 0');
            bloc.startRotate();
          }),
      1: Stage(
          widget: Container(
              key: const Key('1'),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // BACKGROUND TRANSITION
                  LinearTransition(
                    firstWidget: backgrounds[1],
                    secondWidget: backgrounds[2],
                    transitionDuration: 4000,
                  ),
                  // FOREGROUND TRANSITION
                  LinearTransition(
                    transitionDuration: 3000,
                    firstWidget: Center(
                      child: FadeOutWidget(
                        duration: 3000,
                        child: Text('Flutter',
                            style: TextStyle(
                                fontSize: 94,
                                fontWeight: FontWeight.w500,
                                foreground: Paint()..shader = linearGradient,
                                shadows: shadows)),
                      ),
                    ),
                    secondWidget: Center(
                      child: ValueBuilder(
                          streamed: bloc.scaleAnimation.animation,
                          builder: (context, snapshot) {
                            return FadeInWidget(
                              duration: 2000,
                              child: Transform.scale(
                                scale: snapshot.data,
                                child: FadeOutWidget(
                                  duration: 6000,
                                  child: Text('Flutter',
                                      style: TextStyle(
                                          fontSize: 94,
                                          fontWeight: FontWeight.w500,
                                          foreground: Paint()
                                            ..shader = linearGradient2,
                                          shadows: shadows)),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              )),
          time: 6000,
          onShow: () {
            print('Stage 1');
            bloc.startScale();
          }),
      2: Stage(
          widget: Container(
              key: const Key('2'),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // BACKGROUND TRANSITION
                  LinearTransition(
                    firstWidget: backgrounds[2],
                    secondWidget: backgrounds[3],
                    transitionDuration: 3500,
                  ),
                  // FOREGROUND TRANSITION
                  FadeInWidget(
                    child: Center(
                      child: FadeOutWidget(
                        duration: 7000,
                        child: ScrollingText(
                          text: '...is',
                          scrollingDuration: 2000,
                          style: TextStyle(
                              fontSize: 94,
                              fontWeight: FontWeight.w500,
                              foreground: Paint()..shader = linearGradient,
                              shadows: shadows),
                        ),
                      ),
                    ),
                    duration: 1000,
                  ),
                ],
              )),
          time: 7000,
          onShow: () {
            print('Stage 2');
          }),
      3: Stage(
          widget: Container(
              key: const Key('3'),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // BACKGROUND TRANSITION
                  LinearTransition(
                    firstWidget: backgrounds[3],
                    secondWidget: backgrounds[0],
                    transitionDuration: 4000,
                  ),
                  Center(
                    child: Transform.rotate(
                      angle: math.pi / 5,
                      child: FadeInWidget(
                        duration: 2000,
                        child: FadeOutWidget(
                          duration: 8000,
                          child: ScrollingText(
                            text: 'Limitless!',
                            scrollingDuration: 2000,
                            style: TextStyle(
                                fontSize: 74,
                                fontWeight: FontWeight.w500,
                                foreground: Paint()..shader = linearGradient,
                                shadows: shadows),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          time: 8000,
          onShow: () {
            print('Stage 3');
          }),
      4: Stage(
          widget: Container(
              key: const Key('4'),
              child: Stack(
                children: <Widget>[
                  LinearTransition(
                    firstWidget: backgrounds[0],
                    secondWidget: backgrounds[1],
                    transitionDuration: 4000,
                  ),
                  Center(
                    child: FadeInWidget(
                      duration: 500,
                      child: ScrollingText(
                        text: 'Period.',
                        scrollingDuration: 2000,
                        style: TextStyle(
                            fontSize: 94,
                            fontWeight: FontWeight.w500,
                            foreground: Paint()..shader = linearGradient2,
                            shadows: shadows),
                      ),
                    ),
                  ),
                ],
              )),
          time: 5000,
          onShow: () {
            print('Stage 4');
          }),
    };

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('StagedWidget'),
          backgroundColor: Colors.blue[400],
        ),
        body: StagedWidget(
            stagesMap: stagesMap,
            onStart: bloc.stagedOnStart,
            onEnd: () {
              // Navigator.pop(context);
              bloc
                ..stopRotate()
                ..stopScale();
            }),
      ),
    );
  }
}
