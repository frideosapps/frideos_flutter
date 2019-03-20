import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/bloc.dart';
import '../blocs/timer_object_bloc.dart';

const TextStyle styleHeader =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);
const TextStyle styleValue =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
const TextStyle styleOldValue =
    TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500);
const double padding = 22;
const Color buttonColor = Color(0xff99cef9);

class TimerObjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TimerObjectBloc bloc = BlocProvider.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Streamed objects'),
        ),
        body: Container(
          color: Colors.blueGrey[100],
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Card(
                    child: Container(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('TimerObject', style: styleHeader),
                            Container(height: 20),
                            ValueBuilder<int>(
                              streamed: bloc.timerObject,
                              builder: (context, snapshot) => Text(
                                  'Value: ${(snapshot.data * 0.001).toStringAsFixed(2)} secs',
                                  style: styleValue),
                              noDataChild: const Text('NO DATA'),
                            ),
                            ValueBuilder<int>(
                              streamed: bloc.timerObject.stopwatch,
                              builder: (context, snapshot) => Text(
                                  'Time passed: ${(snapshot.data * 0.001).toStringAsFixed(2)} secs',
                                  style: styleValue),
                              noDataChild: const Text('NO DATA'),
                            ),
                            ValueBuilder<int>(
                              streamed: bloc.timerObject,
                              builder: (context, snapshot) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: buttonColor,
                                      child: const Text('Lap time'),
                                      onPressed: bloc.getLapTime,
                                    ),
                                    RaisedButton(
                                      color: buttonColor,
                                      child: const Text('Stop'),
                                      onPressed: bloc.stopTimer,
                                    ),
                                  ],
                                );
                              },
                              noDataChild: RaisedButton(
                                color: buttonColor,
                                child: const Text('Start'),
                                onPressed: bloc.startTimer,
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
