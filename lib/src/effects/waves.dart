import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/core.dart';

import '../extended_asyncwidgets.dart';

const double strokeWidth = 25;
const double baseHeight = 15;

///
/// Waves animation
///
class WavesWidget extends StatefulWidget {
  const WavesWidget({
    @required this.child,
    Key key,
    this.width,
    this.height,
    this.color,
    this.refreshTime = 20,
  })  : assert(child != null, 'The child argument is null.'),
        super(key: key);

  final double width;
  final double height;
  final MaterialColor color;
  final Widget child;

  ///
  /// Refresh time in milliseconds (default: 20)
  ///
  final int refreshTime;

  @override
  _WavesWidgetState createState() {
    return _WavesWidgetState();
  }
}

class _WavesWidgetState extends State<WavesWidget> {
  AnimatedObject<int> frame;

  @override
  void initState() {
    super.initState();
    frame = AnimatedObject<int>(initialValue: 1, interval: widget.refreshTime);
    frame.animation.value = 1;

    frame.start((t) {
      frame.animation.value += 10;
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
      builder: (context, constraints) => ValueBuilder<int>(
          streamed: frame.animation,
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: widget.height,
                  child: widget.child,
                ),
                CustomPaint(
                  painter:
                      _WavesPainter(frame: snapshot.data, color: widget.color),
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

class _WavesPainter extends CustomPainter {
  _WavesPainter({this.frame, this.color});

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

    final height = size.height - paint.strokeWidth / 2;
    final width = size.width;

    final path = Path()
      ..moveTo(0, height + baseHeight)
      ..lineTo(width, height + baseHeight)
      ..moveTo(0, height + baseHeight);

    for (int i = 0; i < size.width.toInt(); i += 6) {
      final x = i * 1.0;
      final sin = math.sin((frame + i) * math.pi / 180.0);
      path.lineTo(x, height - sin * 5.0);
    }

    canvas.drawPath(path, paint);

    paint
      ..color = color[300]
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.softLight
      ..style = PaintingStyle.stroke;

    path
      ..reset()
      ..moveTo(0, height + baseHeight)
      ..lineTo(width, height + baseHeight)
      ..moveTo(0, height + baseHeight);

    for (int i = 0; i < size.width.toInt(); i += 3) {
      final x = i * 1.0;
      final sin = math.sin((frame + i + 90.0) * math.pi / 180.0);
      path.lineTo(x, height - sin * 8.0);
    }

    canvas.drawPath(path, paint);

    paint
      ..color = color[300]
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.softLight
      ..style = PaintingStyle.stroke;

    path
      ..reset()
      ..moveTo(0, height + baseHeight)
      ..lineTo(width, height + baseHeight)
      ..moveTo(0, height + baseHeight);

    for (int i = 0; i < size.width.toInt(); i += 3) {
      final x = i * 1.0;
      final sin = math.sin((frame + i + 180.0) * math.pi / 180.0);
      path.lineTo(x, height - sin * 6.0);
    }

    canvas.drawPath(path, paint);

    paint
      ..color = color[500]
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.softLight
      ..style = PaintingStyle.stroke;

    path
      ..reset()
      ..moveTo(0, height + baseHeight)
      ..lineTo(width, height + baseHeight)
      ..moveTo(0, height + baseHeight);

    for (int i = 0; i < size.width.toInt(); i += 3) {
      final x = i * 1.0;
      final sin = math.sin((frame + i + 135.0) * math.pi / 180.0);
      path.lineTo(x, height - sin * 8.0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
