import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

void main() => runApp(MyApp());

class AppState extends AppStateModel {
  factory AppState() => _singletonAppState;

  AppState._internal();

  static final AppState _singletonAppState = AppState._internal();

  // STREAM
  final counter = StreamedValue<int>();

  void incrementCounter() {
    counter.value++;
  }

  @override
  void init() {
    counter.value = 0;
  }

  @override
  void dispose() {
    counter.dispose();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppState appState;

  @override
  void initState() {
    super.initState();
    appState = AppState();
  }

  @override
  void dispose() {
    appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider<AppState>(
      appState: appState,
      child: MaterialApp(
        title: 'Counter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Counter:'),
                Container(width: 30),
                ValueBuilder<int>(
                  streamed: appState.counter,
                  builder: (context, snapshot) => Text('${snapshot.data}'),
                  noDataChild: const Text('null'),
                ),
              ],
            ),
            Container(height: 30),
            RaisedButton(
                child: const Text('Second page'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondPage()));
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: appState.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Other page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Counter:'),
                Container(width: 30),
                ValueBuilder<int>(
                  streamed: appState.counter,
                  builder: (context, snapshot) => Text('${snapshot.data}'),
                  noDataChild: const Text('null'),
                ),
              ],
            ),
            Container(height: 30),
            RaisedButton(
                child: const Text('Other page'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondPage()));
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: appState.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
