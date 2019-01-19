import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frideos/frideos_dart.dart';

class HorizontalSlider extends StatefulWidget {
  HorizontalSlider(
      {GlobalKey key,
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
  HorizontalSliderState createState() {
    return new HorizontalSliderState();
  }
}

class HorizontalSliderState extends State<HorizontalSlider> {
  final slider = StreamedValue<double>();

  double width;
  double sliderWidth;
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

      sliderMargin = width * 0.2;
      sliderWidth = width * 0.8;

      min = widget.rangeMin;
      max = widget.rangeMax;
      step = widget.step;
      //step = 1.1;      
      //step = 1.0;

      initialValue = widget.initialValue;

      sliderEnd = sliderWidth + sliderMargin - baseTriangleSize;

      var sliderInitialPosition =
          Utils.convertRange(min, max, 0.0, sliderEnd, initialValue);

      slider.value = sliderInitialPosition;

      sliderPosition = sliderInitialPosition;

/*
      var sliderInitialPosition = (initialValue / max) * sliderEnd;

      sliderPosition = sliderInitialPosition;

      slider.value = sliderInitialPosition;
      */

      print('initial value: $initialValue');

      //print('slider initial position: $sliderInitialPosition');

      print('slider position: $sliderPosition');

      print('initial value: ${slider.value}');

      /*
      slider.value = Utils.convertRange(
                                0.0, sliderEnd, min, max, sliderPosition);

                                */
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
      //color: Colors.blueGrey[200],
      child: StreamBuilder(
          stream: slider.outStream,
          builder: (context, AsyncSnapshot snapshot) {
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
                    //The bar needs to be started at the vertex of the triangle (baseTriangleSize*0.5)
                    Container(
                        width: sliderPosition,
                        height: 14.0,
                        color: widget.foregroundBar,
                        margin: EdgeInsets.symmetric(
                            horizontal: baseTriangleSize * 0.5)),
                    Positioned(
                      left: sliderPosition,
                      child: GestureDetector(
                        child: CustomPaint(
                            foregroundPainter: HorizontalSliderPainter(
                                height: baseTriangleSize,
                                width: baseTriangleSize,
                                color: widget.triangleColor),
                            child: Container(
                              color: Colors.transparent,
                              width: baseTriangleSize,
                              height: baseTriangleSize,
                            )),
                        //onTap: () => print('tap'),
                        onHorizontalDragUpdate: (v) {
                          //print('Drag $v');
                          /*
                          var step = v.delta.direction > 0 ? -1.0 : 1.0;
                          var newValue = slider.value + step;
                          var sliderEnd =
                              sliderWidth + sliderMargin - baseTriangleSize;
                          //print('NW: $newValue, Limit: $sliderEnd, $sliderWidth, $sliderMargin, $baseTriangleSize');
                          if (newValue >= 0.0 && newValue <= sliderEnd) {
                            slider.value = newValue;
                            widget.onSliding(slider.value);
                          }*/
                          var stepDir = v.delta.direction > 0 ? -step : step;

                          var newPosition = sliderPosition + stepDir;

/*
                          if (newPosition >= 0.0 && newPosition <= sliderEnd) {
                            sliderPosition = newPosition;

                            slider.value = Utils.convertRange(
                                0.0, sliderEnd, min, max, sliderPosition);

                            widget.onSliding(slider.value);
                          } */

                          sliderPosition = newPosition;
                          //print(sliderPosition);

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

class HorizontalSliderPainter extends CustomPainter {
  final height;
  final width;
  Color color;

  HorizontalSliderPainter({this.height, this.width, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Center = width * 0.5

    Path path = new Path();
    var points = [
      Offset(0.0, height),
      Offset(width * 0.5, 0.0),
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
