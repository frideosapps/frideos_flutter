import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frideos_core/frideos_core.dart';

///
/// A simple horizontal slider
///
class HorizontalSlider extends StatefulWidget {
  const HorizontalSlider(
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
  _HorizontalSliderState createState() {
    return _HorizontalSliderState();
  }
}

class _HorizontalSliderState extends State<HorizontalSlider> {
  final StreamedValue<double> slider = StreamedValue<double>();

  double width;
  double sliderWidth;
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
      final GlobalKey key = widget.key;
      final RenderBox box = key.currentContext.findRenderObject();

      width = box.size.width;

      sliderMargin = width * 0.2;
      sliderWidth = width * 0.8;

      min = widget.rangeMin;
      max = widget.rangeMax;
      step = widget.step;

      initialValue = widget.initialValue;

      sliderEnd = sliderWidth + sliderMargin - baseTriangleSize;

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Background bar
                Stack(
                  children: <Widget>[
                    Container(
                        width: width,
                        height: 14.0,
                        color: widget.backgroundBar,
                        margin: EdgeInsets.symmetric(
                            horizontal: baseTriangleSize * 0.5)),
                    // The bar needs to be started at the vertex of the triangle
                    // (baseTriangleSize*0.5)
                    Container(
                        width: sliderPosition,
                        height: 14,
                        color: widget.foregroundBar,
                        margin: EdgeInsets.symmetric(
                            horizontal: baseTriangleSize * 0.5)),
                    Positioned(
                      left: sliderPosition,
                      child: GestureDetector(
                        child: CustomPaint(
                            foregroundPainter: _HorizontalSliderPainter(
                                height: baseTriangleSize,
                                width: baseTriangleSize,
                                color: widget.triangleColor),
                            child: Container(
                              color: Colors.transparent,
                              width: baseTriangleSize,
                              height: baseTriangleSize,
                            )),
                        onHorizontalDragUpdate: (v) {
                          final stepDir = v.delta.direction > 0 ? -step : step;

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

class _HorizontalSliderPainter extends CustomPainter {
  _HorizontalSliderPainter({this.height, this.width, this.color});

  final double height;
  final double width;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final points = [
      Offset(0, height),
      Offset(width * 0.5, 0),
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
