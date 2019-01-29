import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../src/blocs/animated_object_bloc.dart';
import '../src/blocs/bloc.dart';
import '../src/blocs/sliders_bloc.dart';
import '../src/blocs/staged_widget_bloc.dart';
import '../src/blocs/staged_object/staged_object_bloc.dart';
import '../src/blocs/streamed_list_bloc.dart';
import '../src/blocs/streamed_map_bloc.dart';
import '../src/blocs/streamed_values_bloc.dart';
import '../src/blocs/timer_object_bloc.dart';
import '../src/blocs/multiple_selection/multiple_selection_bloc.dart';

import 'screens/animated_object_page.dart';
import 'screens/blur_page.dart';
import 'screens/curvedtransition_page.dart';
import 'screens/lineartransition_page.dart';
import 'screens/sliders_page.dart';
import 'screens/staged_widget_page.dart';
import 'screens/streamed_list_page.dart';
import 'screens/streamed_map_page.dart';
import 'screens/streamed_values_page.dart';
import 'screens/timer_object_page.dart';
import 'screens/staged_object/staged_object_home.dart';
import 'screens/multiple_selection/multiple_selection_home.dart';

class HomePage extends StatelessWidget {
  _expansionTile(String title, List<Widget> widgets) {
    return ExpansionTile(
        backgroundColor: Colors.white,
        title: Text(title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
        children: widgets);
  }

  _tile(String title, Function onTap) {
    return ListTile(
      dense: true,
      title: Text(title,
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frideos examples'),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue[100],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                    child: Text('Examples',
                        style: TextStyle(color: Colors.white, fontSize: 22.0))),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              _expansionTile('Streams', [
                _tile('Streamed objects', () {
                  Navigator.pop(context);

                  final bloc = StreamedValuesBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            bloc: bloc,
                            child: StreamedValuesPage(),
                          ),
                    ),
                  );
                }),
                _tile('StreamedList', () {
                  Navigator.pop(context);

                  final bloc = StreamedListBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            bloc: bloc,
                            child: StreamedListPage(),
                          ),
                    ),
                  );
                }),
                _tile('StreamedMap', () {
                  Navigator.pop(context);

                  final bloc = StreamedMapBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            bloc: bloc,
                            child: StreamedMapPage(),
                          ),
                    ),
                  );
                }),
              ]),
              _expansionTile('Timing and animations', [
                _tile('TimerObject', () {
                  Navigator.pop(context);

                  final bloc = TimerObjectBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            bloc: bloc,
                            child: TimerObjectPage(),
                          ),
                    ),
                  );
                }),
                _tile('AnimatedObject', () {
                  Navigator.pop(context);

                  final bloc = AnimatedObjectBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            bloc: bloc,
                            child: AnimatedObjectPage(),
                          ),
                    ),
                  );
                }),
                _tile('StagedObject', () {
                  Navigator.pop(context);

                  final bloc = StagedObjectBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            bloc: bloc,
                            child: StagedHomePage(),
                          ),
                    ),
                  );
                }),
                _tile('StagedWidget', () {
                  Navigator.pop(context);

                  final bloc = StagedWidgetBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StagedWidgetPage(
                            bloc: bloc,
                          ),
                    ),
                  );
                }),
              ]),
              _expansionTile('Effects', [
                _tile('Blur', () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlurPage(),
                    ),
                  );
                }),
                _tile('CurvedTransition', () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurvedTransitionPage(),
                    ),
                  );
                }),
                _tile('LinearTransition', () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LinearTransitionPage(),
                    ),
                  );
                }),
              ]),
              _expansionTile('Various', [
                _tile('Multiple selection', () {
                  Navigator.pop(context);

                  final bloc = MultipleSelectionBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            bloc: bloc,
                            child: MultipleSelectionHome(),
                          ),
                    ),
                  );
                }),
                _tile('Sliders', () {
                  Navigator.pop(context);

                  final bloc = SlidersBloc();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            bloc: bloc,
                            child: SlidersPage(),
                          ),
                    ),
                  );
                }),
              ]),
              AboutListTile(),
            ],
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: LinearTransition(
          transitionDuration: 1000,
          firstWidget: Container(),
          secondWidget: Container(
            child: WavesWidget(              
              color: Colors.blue,
              child: Container(
                  color: Colors.blue[800],
                  alignment: Alignment.center,
                  child: BlurInWidget(
                      initialSigmaX: 6.0,
                      initialSigmaY: 12.0,
                      duration: 2000,
                      child: FlutterLogo(
                        size: 240.0,
                      ))),
            ),
          ),
        ),
      ),
    );
  }
}
