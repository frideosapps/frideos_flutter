import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

const strokeWidth = 25.0;
const baseHeight = 15.0;

class WavesPainter extends CustomPainter {
  WavesPainter({this.frame, this.color});

  final int frame;
  MaterialColor color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color[700]
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.softLight
      ..style = PaintingStyle.stroke;

    var height = size.height - paint.strokeWidth / 2; // - paint.strokeWidth;
    var width = size.width;

    var path = Path();
    path.moveTo(0.0, height + baseHeight);
    path.lineTo(width, height + baseHeight);
    path.moveTo(0.0, height + baseHeight);

    for (int i = 0; i < size.width.toInt(); i += 6) {
      var x = i * 1.0;
      var sin = math.sin((frame + i) * math.pi / 180.0);
      path.lineTo(x, height - sin * 5.0);
    }

    canvas.drawPath(path, paint);

    paint
      ..color = color[300]
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.softLight
      ..style = PaintingStyle.stroke;

    
    path.reset();
    path.moveTo(0.0, height + baseHeight);
    path.lineTo(width, height + baseHeight);
    path.moveTo(0.0, height + baseHeight);

    for (int i = 0; i < size.width.toInt(); i += 3) {
      var x = i * 1.0;
      var sin = math.sin((frame + i + 90.0) * math.pi / 180.0);
      path.lineTo(x, height - sin * 8.0);
    }

    canvas.drawPath(path, paint);

    paint
      ..color = color[300]
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round      
      ..blendMode = BlendMode.softLight
      ..style = PaintingStyle.stroke;

    //var path = Path();
    path.reset();
    path.moveTo(0.0, height + baseHeight);
    path.lineTo(width, height + baseHeight);
    path.moveTo(0.0, height + baseHeight);

    for (int i = 0; i < size.width.toInt(); i += 3) {
      var x = i * 1.0;
      var sin = math.sin((frame + i + 180.0) * math.pi / 180.0);
      path.lineTo(x, height - sin * 6.0);
    }

    canvas.drawPath(path, paint);

    paint
      ..color = color[500]
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round      
      ..blendMode = BlendMode.softLight
      ..style = PaintingStyle.stroke;

    
    path.reset();
    path.moveTo(0.0, height + baseHeight);
    path.lineTo(width, height + baseHeight);
    path.moveTo(0.0, height + baseHeight);

    for (int i = 0; i < size.width.toInt(); i += 3) {
      var x = i * 1.0;
      var sin = math.sin((frame + i + 135.0) * math.pi / 180.0);
      path.lineTo(x, height - sin * 8.0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class WavesWidget extends StatefulWidget {
  WavesWidget({
    this.width,
    this.height,
    this.color,
    @required this.child,
  });

  final double width;
  final double height;
  final MaterialColor color;
  final Widget child;

  @override
  _WavesWidgetState createState() {
    return new _WavesWidgetState();
  }
}

class _WavesWidgetState extends State<WavesWidget> {
  final frame = AnimatedObject<int>(initialValue: 1, interval: 50);

  @override
  void initState() {
    super.initState();
    frame.animation.value = 1;

    frame.start((t) {
      frame.animation.value += 10;
      //if (frame.animation.value > widget.width) {
      //  frame.stop();
      //}
    });
  }

  @override
  void dispose() {
    frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          StreamedWidget(
              stream: frame.animationStream,
              builder: (context, AsyncSnapshot<int> snapshot) {                
                return Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: widget.height,
                      child: widget.child,
                    ),
                    CustomPaint(
                      painter: WavesPainter(
                          frame: snapshot.data, color: widget.color),
                      child: Container(
                        height: widget.height,
                      ),
                    ),
                  ],
                );
              }),
    );
  }
}