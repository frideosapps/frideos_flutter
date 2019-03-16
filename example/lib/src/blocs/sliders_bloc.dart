import 'package:frideos/frideos_dart.dart';

import '../blocs/bloc.dart';

class SlidersBloc extends BlocBase {
  SlidersBloc() {
    angle.value = initialAngle;
    scale.value = initialScale;
  }

  final angle = StreamedValue<double>();
  final scale = StreamedValue<double>();

  double initialAngle = 2.2;
  double initialScale = 1.8;

  void horizontalSlider(value) {
    angle.value = value;
  }

  void verticalSlider(value) {
    scale.value = value;
  }

  @override
  void dispose() {
    angle.dispose();
    scale.dispose();
  }
}
