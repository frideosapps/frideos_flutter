import 'package:flutter/material.dart';

import 'package:frideos_general/src/homepage.dart';
import 'package:frideos_general/src/blocs/bloc.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {    

    return MaterialApp(
      title: 'Frideos-flutter examples',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}