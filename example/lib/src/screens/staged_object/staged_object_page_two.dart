import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';
import 'package:frideos/frideos_dart.dart';

import '../../blocs/staged_object/staged_page_two_bloc.dart';

class StagedPageTwo extends StatelessWidget {
  const StagedPageTwo({this.bloc});

  final StagedPageTwoBloc bloc;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page two'),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              ValueBuilder<StageStatus>(
                streamed: bloc.staged.getStatus,
                builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      snapshot.data == StageStatus.active
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: const Text('Reset'),
                              onPressed: bloc.staged.resetStages,
                            )
                          : Container(),
                      snapshot.data == StageStatus.stop
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: const Text('Start'),
                              onPressed: bloc.staged.startStages,
                            )
                          : Container(),
                      snapshot.data == StageStatus.active
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: const Text('Stop'),
                              onPressed: bloc.staged.stopStages,
                            )
                          : Container(),
                    ],
                  );
                },
              ),
              Expanded(
                child: Center(
                  child: ValueBuilder(
                    streamed: bloc.staged,
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
