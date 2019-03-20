import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import '../blocs/bloc.dart';
import '../blocs/sliders_bloc.dart';

class SlidersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SlidersBloc bloc = BlocProvider.of(context);
    GlobalKey _horizontalSliderKey = GlobalKey();
    GlobalKey _verticalSliderKey = GlobalKey();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sliders'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: ValueBuilder<double>(
                        streamed: bloc.scale,
                        builder: (context, snapshotScale) {
                          return ValueBuilder<double>(
                              streamed: bloc.angle,
                              builder: (context, snapshot) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Transform.scale(
                                          scale: snapshotScale.data,
                                          child: Transform.rotate(
                                              angle: snapshot.data,
                                              child: const FlutterLogo()),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              noDataChild: const Text(
                                  'Click on start to show the widgets.'));
                        },
                        noDataChild:
                            const Text('Click on start to show the widgets.')),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: VerticalSlider(
                      key: _verticalSliderKey,
                      rangeMin: 0.5,
                      rangeMax: 5.5,
                      //step: 5.0,
                      initialValue: bloc.initialScale,
                      backgroundBar: Colors.indigo[50],
                      foregroundBar: Colors.indigo[500],
                      triangleColor: Colors.red,
                      onSliding: (slider) {
                        bloc.verticalSlider(slider);
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: HorizontalSlider(
                  key: _horizontalSliderKey,
                  rangeMin: 0,
                  rangeMax: 3.14,
                  //step: 5.0,
                  initialValue: bloc.initialAngle,
                  backgroundBar: Colors.indigo[50],
                  foregroundBar: Colors.indigo[500],
                  triangleColor: Colors.red,
                  onSliding: (slider) {
                    bloc.horizontalSlider(slider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
