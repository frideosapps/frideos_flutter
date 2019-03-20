import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frideos/frideos.dart';

class Model {
  Model({this.counter, this.text});

  int counter;
  String text;
}

class AppState extends AppStateModel {
  AppState() {
    print('-------APP STATE INIT--------');
  }

  final model = StreamedValue<Model>();

  @override
  void init() {
    model.value = Model(counter: 33, text: 'Lorem ipsum');
  }

  @override
  void dispose() {
    model.dispose();
  }
}

class App extends StatelessWidget {
  final AppState appState;

  App({@required this.appState});

  @override
  Widget build(BuildContext context) {
    return AppStateProvider<AppState>(
      appState: appState,
      child: MaterialPage(),
    );
  }
}

class MaterialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = AppStateProvider.of<AppState>(context).model;

    return ValueBuilder<Model>(
        streamed: model,
        builder: (context, snapshot) {
          return MaterialApp(
            home: Container(
              child: Column(
                children: <Widget>[
                  Text(snapshot.data.text),
                  Text(snapshot.data.counter.toString()),
                ],
              ),
            ),
          );
        });
  }
}

void main() {
  testWidgets('AppStateProvider', (WidgetTester tester) async {
    final appState = AppState();

    await tester.pumpWidget(App(
      appState: appState,
    ));

    await tester.pump();

    expect(find.text('Lorem ipsum'), findsOneWidget);
    expect(find.text('33'), findsOneWidget);
  });
}
