import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  BlurWidget(
      {@required this.child, @required this.sigmaX, @required this.sigmaY});

  final Widget child;
  final double sigmaX;
  final double sigmaY;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Stack(
            children: <Widget>[
              Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: child),
              BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                  child: Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    color: Colors.transparent,
                  )),
            ],
          ),
    );
  }
}