import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';
import 'package:frideos/frideos_dart.dart';

import 'package:frideos_general/src/blocs/staged_object/staged_page_two_bloc.dart';

class StagedPageTwo extends StatelessWidget {
  StagedPageTwo({this.bloc});

  final StagedPageTwoBloc bloc;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Page two'),
        ),
        body: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              StreamedWidget<StageStatus>(
                initialData: StageStatus.stop,
                stream: bloc.staged.statusStream,
                builder: (context, AsyncSnapshot<StageStatus> snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      snapshot.data == StageStatus.active
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: Text('Reset'),
                              onPressed: () {
                                bloc.staged.resetStages();
                              })
                          : Container(),
                      snapshot.data == StageStatus.stop
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: Text('Start'),
                              onPressed: () {
                                bloc.staged.startStages();
                                //bloc.showText();
                              })
                          : Container(),
                      snapshot.data == StageStatus.active
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: Text('Stop'),
                              onPressed: () {
                                bloc.staged.stopStages();
                              })
                          : Container(),
                    ],
                  );
                },
              ),              
              Expanded(
                child: Center(
                  child: StreamedWidget(
                    stream: bloc.staged.widgetStream,
                    builder: (context, snapshot) => snapshot.data,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
