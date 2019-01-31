import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../frideos_dart/streamed_value.dart';
import '../frideos_dart/utils.dart';

///
/// A simple vertical slider
///
class VerticalSlider extends StatefulWidget {
  VerticalSlider(
      {@required GlobalKey key,
      @required this.rangeMin,
      @required this.rangeMax,
      this.step = 1.0,
      @required this.initialValue,
      @required this.onSliding,
      this.backgroundBar = const Color(0xffbbdefb),
      this.foregroundBar = const Color(0xff2090e9),
      this.triangleColor = Colors.deepOrange})
      : super(key: key);

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
    return new _VerticalSliderState();
  }
}

class _VerticalSliderState extends State<VerticalSlider> {
  final slider = StreamedValue<double>();

  double width;
  double height;
  double sliderHeight;
  double sliderMargin;
  double angle;
  double baseTriangleSize = 20.0;

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

      var sliderInitialPosition =
          Utils.convertRange(min, max, 0.0, sliderEnd, initialValue);

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
          builder: (context, AsyncSnapshot snapshot) {
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
                    //The bar needs to be started at the vertex of the triangle (baseTriangleSize*0.5)
                    Container(
                        width: 14.0,
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
                          var stepDir = v.delta.direction > 0 ? step : -step;

                          var newPosition = sliderPosition + stepDir;

                          sliderPosition = newPosition;

                          if (sliderPosition < 0.0) {
                            sliderPosition = widget.rangeMin;
                          }

                          if (sliderPosition > sliderEnd) {
                            sliderPosition = sliderEnd;
                          }

                          slider.value = Utils.convertRange(
                              0.0, sliderEnd, min, max, sliderPosition);

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
  final height;
  final width;
  Color color;

  _VerticalSliderPainter({this.height, this.width, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();
    var points = [
      Offset(width, 0.0),
      Offset(0.0, height * 0.5),
      Offset(width, height),
    ];
    path.addPolygon(points, true);

    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
