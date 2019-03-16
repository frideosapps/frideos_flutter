import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

class LinearTransitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _firstChild() {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5, 1.0],
            colors: [
              Colors.blue[900],
              Colors.blue[600],
              Colors.blue[300],
            ],
          ),
        ),
      );
    }

    Widget _secondChild() {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text('LinearTransition', style: TextStyle(fontSize: 34)),
            const FlutterLogo(
              size: 192,
            ),
            Container(
              height: 12,
            )
          ]);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LinearTransition'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: LinearTransition(
            firstWidget: _firstChild(),
            secondWidget: _secondChild(),
            transitionDuration: 4000,
          ),
        ),
      ),
    );
  }
}
