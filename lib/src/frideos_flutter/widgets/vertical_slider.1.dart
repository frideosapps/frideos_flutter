import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:frideos/frideos_dart.dart';

class VerticalSlider extends StatefulWidget {
  VerticalSlider(
      {GlobalKey key,
      this.rangeMin,
      this.rangeMax,
      this.initialValue,
      this.onSliding,
      this.backgroundBar = const Color(0xffbbdefb),
      this.foregroundBar = const Color(0xff2090e9),
      this.triangleColor = Colors.deepOrange})
      : super(key: key);

  final double rangeMin;
  final double rangeMax;
  final double initialValue;
  final Color backgroundBar;
  final Color foregroundBar;
  final Color triangleColor;

  final Function(double) onSliding;

  @override
  VerticalSliderState createState() {
    return new VerticalSliderState();
  }
}

class VerticalSliderState extends State<VerticalSlider> {
  final slider = StreamedValue<double>();

  double width;
  double height;
  double sliderHeight;
  double sliderMargin;
  double angle;
  double baseTriangleSize = 20.0;

  double min;
  double max;
  double initialValue;
  double step;
  double sliderPosition;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      GlobalKey key = widget.key;
      final RenderBox box = key.currentContext.findRenderObject();
      width = box.size.width;
      height = box.size.height;
      slider.value = 1.0;
      min = widget.rangeMin;
      max = widget.rangeMax;
     // min = 1.0;
     // max = 100.0;
      initialValue = max / 2;

      //step = (max - min) / 100;

      slider.value = min;
      sliderMargin = height * 0.2;
      sliderHeight = height * 0.8;
      sliderPosition = height * 0.5;
      step = 1.0;
      //sliderHeight = 240.0;
      //slider.value = height * 0.5;

      // Chosen range = (max-min)
      // Step?
      // Pixels range = sliderHeight
      // 1 Pixel = ?
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
      // width: 14.0,
      // color: Colors.blueGrey[500],
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
                        //height: slider.value,
                        height: sliderPosition,
                        color: widget.foregroundBar,
                        margin: EdgeInsets.symmetric(
                            vertical: baseTriangleSize * 0.5)),
                    Positioned(
                      //top: slider.value,
                      top: sliderPosition,
                      child: GestureDetector(
                        child: CustomPaint(
                            foregroundPainter: VerticalSliderPainter(
                                height: baseTriangleSize,
                                width: baseTriangleSize,
                                color: widget.triangleColor),
                            child: Container(
                              color: Colors.transparent,
                              //color: Colors.green,
                              width: baseTriangleSize,
                              height: baseTriangleSize,
                            )),
                        onVerticalDragUpdate: (v) {
                          //var step = v.delta.direction > 0 ? 1.0 : -1.0;
                          //r print('Global: ${v.globalPosition.dy}');
                          var stepDir = v.delta.direction > 0 ? step : -step;
                          var newValue = slider.value + stepDir;
                          var newPosition = sliderPosition + stepDir;
                          var sliderEnd =
                              sliderHeight + sliderMargin - baseTriangleSize;
                          //if (newValue >= 0 && newValue <= sliderEnd) {
                          if (newPosition >= 0.0 && newPosition <= sliderEnd) {
                            //slider.value = newValue;
                            //slider.value = newPosition;
                             sliderPosition = newPosition;
                             widget.onSliding(slider.value);
                            // print('$max, $sliderHeight');

                            // Chosen range = (max-min)
                            // Step?
                            // Pixels range = sliderHeight
                            // 1 Pixel = ?

                            //new_value = ( (old_value - old_min) / (old_max - old_min) ) * (new_max - new_min) + new_min
                            //slider.value = ((sliderPosition - 1) / (sliderEnd - 1) ) * (max - min) + min;
                            //NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
                            //slider.value = (((sliderPosition - (sliderHeight*0.01)) * (max - min)) / (sliderEnd - 1)) + min;

                            var oldValue = sliderPosition;
                            print('sliderPosition: $sliderPosition');
                            var oldMin = 1.0;
                            var newMax = max;
                            var newMin = min;
                            var oldMax = sliderEnd-1.0;

                            slider.value =
                                (((oldValue - oldMin) * (newMax - newMin)) /
                                        (oldMax - oldMin)) +
                                    newMin;
                                    
                                  
                          }
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

class VerticalSliderPainter extends CustomPainter {
  final height;
  final width;
  Color color;

  VerticalSliderPainter({this.height, this.width, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Center = width * 0.5

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
