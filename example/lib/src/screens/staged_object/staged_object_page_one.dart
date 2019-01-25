import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';
import 'package:frideos/frideos_dart.dart';

import '../../blocs/staged_object/staged_page_one_bloc.dart';

class StagedPageOne extends StatelessWidget {
  StagedPageOne({this.bloc});

  final StagedPageOneBloc bloc;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.5;
    var height = MediaQuery.of(context).size.height * 0.3;

    _background(MaterialColor color) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 0.0),
          borderRadius: BorderRadius.circular(25.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5, 1.0],
            colors: [
              color[900],
              color[600],
              color[300],
            ],
          ),
        ),
      );
    }

    var backgrounds = [
      _background(Colors.teal),
      _background(Colors.blue),
      _background(Colors.pink),
      _background(Colors.blueGrey),
      _background(Colors.orange),
      _background(Colors.purple),
    ];

    var stagesMap = <int, Stage>{
      0: Stage(
          widget: Container(
            key: Key('0'),
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: CurvedTransition(
              firstWidget: backgrounds[0],
              secondWidget: backgrounds[1],
              transitionDuration: 4000,
              curve: Curves.bounceInOut,
            ),
          ),
          time: 7000,
          onShow: () {}),
      1: Stage(
          widget: Container(
            key: Key('1'),
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: LinearTransition(
              firstWidget: backgrounds[1],
              secondWidget: backgrounds[2],
              transitionDuration: 4000,
            ),
          ),
          time: 7000,
          onShow: () {}),
      2: Stage(
          widget: Container(
            key: Key('2'),
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: LinearTransition(
              firstWidget: backgrounds[2],
              secondWidget: backgrounds[3],
              transitionDuration: 3000,
            ),
          ),
          time: 5000,
          onShow: () {}),
      3: Stage(
          widget: Container(
            key: Key('3'),
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: CurvedTransition(
              firstWidget: backgrounds[3],
              secondWidget: backgrounds[4],
              transitionDuration: 3000,
              curve: Curves.bounceInOut,
            ),
          ),
          time: 5000,
          onShow: () {}),
      4: Stage(
          widget: Container(
            key: Key('4'),
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Center(
                child: ScrollingText(
              text: 'Scrolling text (duration 2 seconds).',
              scrollingDuration: 2000,
            )),
          ),
          time: 5000,
          onShow: () {}),
      6: Stage(
          widget: Container(
            key: Key('6'),
            height: height,
            width: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: CircularProgressIndicator(),
          ),
          time: 5000,
          onShow: () {}),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Page One'),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                      color: Colors.lightBlueAccent,
                      child: Text('Reset'),
                      onPressed: () {
                        bloc.resetMap();
                      }),
                  Container(height: 12.0),
                  Container(
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    height: 32.0,
                    child: Text(
                        'Go to page two to play the staged widgets animation.'),
                  ),
                  Container(height: 12.0),
                  StreamedWidget(
                      stream: bloc.totalWidgets.outStream,
                      builder: (context, snapshot) => Text(
                            'Widgets added: ${snapshot.data}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          )),
                  Container(height: 12.0),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                List<Widget>.generate(stagesMap.length, (int index) {
                  var key = stagesMap.keys.elementAt(index);
                  return Center(
                    child: InkWell(
                      child: stagesMap[key].widget,
                      onTap: () {
                        bloc.addStage(stagesMap[key]);
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
