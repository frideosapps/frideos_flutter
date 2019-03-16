import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/bloc.dart';
import '../blocs/streamed_values_bloc.dart';

import 'history_page.dart';

const TextStyle styleHeader =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);
const TextStyle styleValue =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
const TextStyle styleOldValue =
    TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500);
const double padding = 22;
const Color buttonColor = Color(0xff99cef9);

class StreamedValuesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  StreamedValueWidget(),
                  MemoryWidget(),
                  HistoryWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StreamedValueWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StreamedValuesBloc bloc = BlocProvider.of(context);

    return Card(
      child: Container(
          padding: const EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('StreamedValue', style: styleHeader),
              Container(height: 20),
              ValueBuilder<int>(
                stream: bloc.count,
                builder: (context, snapshot) =>
                    Text('Value: ${snapshot.data}', style: styleValue),
                noDataChild: const Text('NO DATA'),
              ),
              ValueBuilder<Counter>(
                stream: bloc.counterObj,
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      Text(snapshot.data.text, style: styleValue),
                    ],
                  );
                },
                noDataChild: const Text('NO DATA'),
              ),
              RaisedButton(
                color: buttonColor,
                child: const Text('+'),
                onPressed: bloc.incrementCounter,
              ),
            ],
          )),
    );
  }
}

class MemoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StreamedValuesBloc bloc = BlocProvider.of(context);

    return Card(
      child: Container(
        padding: const EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('MemoryObject', style: styleHeader),
            Container(height: 20),
            ValueBuilder<int>(
              stream: bloc.countMemory,
              builder: (context, snapshot) => Column(
                    children: <Widget>[
                      Text('Value: ${snapshot.data}', style: styleValue),
                      Text('oldValue: ${bloc.countMemory.oldValue}',
                          style: styleOldValue),
                    ],
                  ),
              noDataChild: const Text('NO DATA'),
            ),
            RaisedButton(
              color: buttonColor,
              child: const Text('+'),
              onPressed: bloc.incrementCounterMemory,
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StreamedValuesBloc bloc = BlocProvider.of(context);

    return Card(
      child: Container(
        padding: const EdgeInsets.all(padding),
        child: Column(
          children: <Widget>[
            const Text('HistoryObject', style: styleHeader),
            Container(height: 20),
            ValueBuilder<int>(
              stream: bloc.countHistory,
              builder: (context, snapshot) => Column(
                    children: <Widget>[
                      Text('Value: ${bloc.countHistory.value}',
                          style: styleValue),
                      Text('oldValue: ${bloc.countHistory.oldValue}',
                          style: styleOldValue),
                    ],
                  ),
              noDataChild: const Text('NO DATA'),
            ),
            ValueBuilder<List<int>>(
              stream: bloc.countHistory.historyStream,
              builder: (context, snapshot) => Text(
                  'History length: ${snapshot.data.length}',
                  style: styleValue),
              noDataChild: const Text('NO DATA'),
            ),
            RaisedButton(
              color: buttonColor,
              child: const Text('+'),
              onPressed: bloc.incrementCounterHistory,
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ValueBuilder(
                      stream: bloc.countHistory,
                      builder: (context, snapshot) => RaisedButton(
                            color: buttonColor,
                            child: const Text('Save to history'),
                            onPressed: bloc.saveToHistory,
                          ),
                      noDataChild: RaisedButton(
                        color: Theme.of(context).disabledColor,
                        child: const Text('First click on +'),
                        onPressed: null,
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  color: buttonColor,
                  child: const Text('History page'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(bloc),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
