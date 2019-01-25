import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

class CurvedTransitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _background(MaterialColor color) {
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

    var backgrounds = [
      _background(Colors.blue),
      _background(Colors.pink),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('CurvedTransition'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: CurvedTransition(
            firstWidget: backgrounds[0],
            secondWidget: backgrounds[1],
            transitionDuration: 4000,
            curve: Curves.bounceInOut,
          ),
        ),
      ),
    );
  }
}
