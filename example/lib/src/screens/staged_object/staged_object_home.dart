import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';
import 'package:frideos/frideos_dart.dart';

import 'package:frideos_general/src/blocs/bloc.dart';
import 'package:frideos_general/src/blocs/staged_object/staged_object_bloc.dart';

import 'staged_object_page_one.dart';
import 'staged_object_page_two.dart';

class StagedHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Setting the map in the build method
    StagedObjectBloc bloc = BlocProvider.of(context);

    var width = MediaQuery.of(context).size.width * 0.7;
    var height = MediaQuery.of(context).size.height * 0.6;

    _background(MaterialColor color) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
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
      _background(Colors.blue),
      _background(Colors.pink),
      _background(Colors.blueGrey),
      _background(Colors.orange),
    ];
/*
    var widgets = [
      SizedBox(
          height: height,
          width: width,
          child: Image.asset('assets/images/1.jpg', fit: BoxFit.fill)),
      SizedBox(
          height: height,
          width: width,
          child: Image.asset('assets/images/2.jpg', fit: BoxFit.fill)),
      SizedBox(
          height: height,
          width: width,
          child: Image.asset('assets/images/3.jpg', fit: BoxFit.fill)),
      SizedBox(
          height: height,
          width: width,
          child: Image.asset('assets/images/4.jpg', fit: BoxFit.fill)),
    ];*/

    var stagesMap = <int, Stage>{
      0: Stage(
          widget: Container(
            width: width,
            height: height,
            color: Colors.blue[100],
            alignment: Alignment.center,
            key: Key('0'),
            child: ScrollingText(
                text:
                    'This stage will last 5 seconds. By the onShow call back it is possibile to assign an action when the widget shows.',
                scrollingDuration: 2000,
                style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500)),
          ),
          time: 5000,
          onShow: () {}),
      1: Stage(
          widget: Container(
            width: width,
            height: height,
            color: Colors.orange[200],
            alignment: Alignment.center,
            key: Key('1'),
            child: ScrollingText(
              text: 'The next widgets will cross fade.',
              scrollingDuration: 2000,
              style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          time: 8000,
          onShow: () {}),
      2: Stage(
          widget: Container(
              key: Key('2'),
              child: LinearTransition(
                firstWidget: backgrounds[0],
                secondWidget: backgrounds[1],
                transitionDuration: 4000,
              )),
          time: 5000,
          onShow: () {}),
      3: Stage(
          widget: Container(
              key: Key('3'),
              child: CurvedTransition(
                firstWidget: backgrounds[2],
                secondWidget: backgrounds[3],
                transitionDuration: 4000,
                curve: Curves.bounceOut,
              )),
          time: 5000,
          onShow: () {}),
      4: Stage(
          widget: Container(
              key: Key('4'),
              child: LinearTransition(
                firstWidget: backgrounds[1],
                secondWidget: backgrounds[2],
                transitionDuration: 4000,
              )),
          time: 5000,
          onShow: () {}),
      5: Stage(
          widget: Container(
              key: Key('5'),
              child: CurvedTransition(
                firstWidget: backgrounds[3],
                secondWidget: backgrounds[0],
                transitionDuration: 4000,
                curve: Curves.bounceInOut,
              )),
          time: 5000,
          onShow: () {}),
      6: Stage(
          widget: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            key: Key('6'),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Choose the widget to stage in the page one and play the StagedObject in page two.',
                      style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  child: Transform.scale(
                    scale: 1.0,
                    child: StagedPageOne(
                      bloc: bloc.blocA,
                    ),
                  ),
                ),
              ],
            ),
          ),
          time: 10000,
          onShow: () {}),
    };

    bloc.setMap(stagesMap);

    return Scaffold(
      appBar: AppBar(
        title: Text('StagedObject'),
      ),
      body: Container(
        color: Colors.blueGrey[50],
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      child: Text('Page one'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StagedPageOne(
                                  bloc: bloc.blocA,
                                ),
                          ),
                        );
                      }),
                ),
                Container(width: 40.0),
                Expanded(
                  child: RaisedButton(
                      color: Colors.lightBlueAccent,
                      child: Text('Page two'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StagedPageTwo(
                                  bloc: bloc.blocB,
                                ),
                          ),
                        );
                      }),
                ),
              ],
            ),
            Container(
              height: 16.0,
            ),
            StreamedWidget<StageStatus>(
                initialData: StageStatus.stop,
                stream: bloc.staged.statusStream,
                builder: (context, AsyncSnapshot<StageStatus> snapshot) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        snapshot.data == StageStatus.active
                            ? Container()
                            : Container(
                                color: Colors.yellow,
                                alignment: Alignment.center,
                                height: 32.0,
                                child: Text(
                                    'Click on start to show the widgets staged animation.')),
                      ]);
                }),
            Container(
              height: 16.0,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: ReceiverWidget(
                      stream: bloc.staged.widgetStream,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 16.0,
            ),
            Center(
                child: StreamedWidget(
                    stream: bloc.text.outStream,
                    builder: (context, snapshot) => Text(snapshot.data))),
            SizedBox(
              height: 80.0,
              width: 80.0,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: StreamedWidget(
                    stream: bloc.widget.outStream,
                    builder: (context, snapshot) => snapshot.data,
                  ),
                ),
              ),
            ),
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
                              bloc.start();
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
          ],
        ),
      ),
    );
  }
}
