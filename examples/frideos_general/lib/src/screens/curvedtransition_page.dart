import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

class CurvedTransitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('CurvedTransition'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: CurvedTransition(
            firstWidget: Image.asset('assets/images/1.jpg', fit: BoxFit.fill),
            secondWidget: Image.asset('assets/images/2.jpg', fit: BoxFit.fill),
            transitionDuration: 4000,
            curve: Curves.bounceInOut,
          ),
        ),
      ),
    );
  }
}
