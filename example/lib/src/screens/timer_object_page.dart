import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/bloc.dart';
import '../blocs/timer_object_bloc.dart';

const styleHeader =
    TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500);
const styleValue = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);
const styleOldValue =
    TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.w500);
const padding = 22.0;
const buttonColor = Color(0xff99cef9);

class TimerObjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TimerObjectBloc bloc = BlocProvider.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Streamed objects'),
        ),
        body: Container(
          color: Colors.blueGrey[100],
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Card(
                    child: Container(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('TimerObject', style: styleHeader),
                            Container(height: 20.0),
                            ValueBuilder<int>(                              
                              stream: bloc.timerObject,
                              builder: (BuildContext context,
                                      AsyncSnapshot<int> snapshot) =>
                                  Text(
                                      'Value: ${(snapshot.data * 0.001).toStringAsFixed(2)} secs',
                                      style: styleValue),
                              noDataChild: Text('NO DATA'),
                            ),
                            ValueBuilder<int>(                              
                              stream: bloc.timerObject.stopwatch,
                              builder: (BuildContext context,
                                      AsyncSnapshot<int> snapshot) =>
                                  Text(
                                      'Time passed: ${(snapshot.data * 0.001).toStringAsFixed(2)} secs',
                                      style: styleValue),
                              noDataChild: Text('NO DATA'),
                            ),
                            ValueBuilder<int>(                              
                              stream: bloc.timerObject,
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: buttonColor,
                                      child: Text('Lap time'),
                                      onPressed: () {
                                        bloc.getLapTime();
                                      },
                                    ),
                                    RaisedButton(
                                      color: buttonColor,
                                      child: Text('Stop'),
                                      onPressed: () {
                                        bloc.stopTimer();
                                      },
                                    ),
                                  ],
                                );
                              },
                              noDataChild: RaisedButton(
                                color: buttonColor,
                                child: Text('Start'),
                                onPressed: () {
                                  bloc.startTimer();
                                },
                              ),
                              onError: (error) => Text(error),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
