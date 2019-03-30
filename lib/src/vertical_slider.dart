import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frideos_core/frideos_core.dart';

///
/// A simple vertical slider
///
class VerticalSlider extends StatefulWidget {
  const VerticalSlider(
      {@required GlobalKey key,
      @required this.rangeMin,
      @required this.rangeMax,
      @required this.initialValue,
      @required this.onSliding,
      this.step = 1.0,
      this.backgroundBar = const Color(0xffbbdefb),
      this.foregroundBar = const Color(0xff2090e9),
      this.triangleColor = Colors.deepOrange})
      : assert(rangeMin != null, 'The rangeMin argument is null.'),
        assert(rangeMax != null, 'The rangeMax argument is null.'),
        assert(initialValue != null, 'The initialValue argument is null.'),
        assert(onSliding != null, 'The onSliding argument is null.'),
        super(key: key);

  final double rangeMin;
  final double rangeMax;
  final double step;
  final double initialValue;
  final Color backgroundBar;
  final Color foregroundBar;
  final Color triangleColor;

  final Function(double) onSliding;

  @override
  _VerticalSliderState createState() {
    return _VerticalSliderState();
  }
}

class _VerticalSliderState extends State<VerticalSlider> {
  final StreamedValue<double> slider = StreamedValue<double>();

  double width;
  double height;
  double sliderHeight;
  double sliderMargin;
  double angle;
  double baseTriangleSize = 20;

  double min;
  double max;
  double step;
  double initialValue;
  double sliderPosition;
  double sliderEnd;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      GlobalKey key = widget.key;
      final RenderBox box = key.currentContext.findRenderObject();
      width = box.size.width;
      height = box.size.height;

      sliderMargin = height * 0.2;
      sliderHeight = height * 0.8;

      min = widget.rangeMin;
      max = widget.rangeMax;

      step = widget.step;

      initialValue = widget.initialValue;

      sliderEnd = sliderHeight + sliderMargin - baseTriangleSize;

      final sliderInitialPosition =
          Utils.convertRange(min, max, 0, sliderEnd, initialValue);

      slider.value = sliderInitialPosition;

      sliderPosition = sliderInitialPosition;
    });
  }

  @override
  void dispose() {
    super.dispose();
    slider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: slider.outStream,
          builder: (context, snapshot) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Background bar
                Stack(
                  children: <Widget>[
                    Container(
                        width: 14.0,
                        height: height,
                        color: widget.backgroundBar,
                        margin: EdgeInsets.symmetric(
                            vertical: baseTriangleSize * 0.5)),
                    // The bar needs to be started at the vertex of the triangle
                    // (baseTriangleSize*0.5)
                    Container(
                        width: 14,
                        height: sliderPosition,
                        color: widget.foregroundBar,
                        margin: EdgeInsets.symmetric(
                            vertical: baseTriangleSize * 0.5)),
                    Positioned(
                      //top: slider.value,
                      top: sliderPosition,
                      child: GestureDetector(
                        child: CustomPaint(
                            foregroundPainter: _VerticalSliderPainter(
                                height: baseTriangleSize,
                                width: baseTriangleSize,
                                color: widget.triangleColor),
                            child: Container(
                              color: Colors.transparent,
                              width: baseTriangleSize,
                              height: baseTriangleSize,
                            )),
                        onVerticalDragUpdate: (v) {
                          final stepDir = v.delta.direction > 0 ? step : -step;

                          final newPosition = sliderPosition + stepDir;

                          sliderPosition = newPosition;

                          if (sliderPosition < 0.0) {
                            sliderPosition = widget.rangeMin;
                          }

                          if (sliderPosition > sliderEnd) {
                            sliderPosition = sliderEnd;
                          }

                          slider.value = Utils.convertRange(
                              0, sliderEnd, min, max, sliderPosition);

                          widget.onSliding(slider.value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}

class _VerticalSliderPainter extends CustomPainter {
  _VerticalSliderPainter({this.height, this.width, this.color});

  final double height;
  final double width;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final points = [
      Offset(width, 0),
      Offset(0, height * 0.5),
      Offset(width, height),
    ];
    path.addPolygon(points, true);

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
