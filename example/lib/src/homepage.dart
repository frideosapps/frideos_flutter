import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      drawer: Drawer(
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
            ListTile(
              title: Text('Streamed objects'),
              onTap: () {
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
              },
            ),
            ListTile(
              title: Text('StreamedList'),
              onTap: () {
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
              },
            ),
            ListTile(
              title: Text('StreamedMap'),
              onTap: () {
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
              },
            ),
            ListTile(
              title: Text('TimerObject'),
              onTap: () {
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
              },
            ),
            ListTile(
              title: Text('AnimatedObject'),
              onTap: () {
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
              },
            ),
            ListTile(
              title: Text('StagedObject'),
              onTap: () {
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
              },
            ),
            ListTile(
              title: Text('StagedWidget'),
              onTap: () {
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
              },
            ),
            ListTile(
              title: Text('Multiple selection'),
              onTap: () {
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
              },
            ),
            ListTile(
              title: Text('CurvedTransition'),
              onTap: () {
                Navigator.pop(context);

                final bloc = SlidersBloc();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CurvedTransitionPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('LinearTransition'),
              onTap: () {
                Navigator.pop(context);

                final bloc = SlidersBloc();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LinearTransitionPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Sliders'),
              onTap: () {
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
              },
            ),
            AboutListTile(),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text('Home Page'),
      ),
    );
  }
}
