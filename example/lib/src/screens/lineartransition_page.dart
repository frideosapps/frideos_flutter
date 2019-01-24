import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

class LinearTransitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('LinearTransition'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: LinearTransition(
            firstWidget: Image.asset('assets/images/1.jpg', fit: BoxFit.fill),
            secondWidget: Image.asset('assets/images/2.jpg', fit: BoxFit.fill),
            transitionDuration: 4000,
          ),
        ),
      ),
    );
  }
}
