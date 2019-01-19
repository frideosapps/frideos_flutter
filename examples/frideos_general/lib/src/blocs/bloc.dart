import 'package:flutter/material.dart';

abstract class BlocBase {
  dispose();
}

class BlocProvider extends StatefulWidget {
  BlocProvider({this.bloc, this.child});
  final BlocBase bloc;
  final Widget child;

  @override
  BlocProviderState createState() {
    return new BlocProviderState();
  }

  static BlocBase of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .bloc;
  }
}

class BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return InheritedBloc(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

class InheritedBloc extends InheritedWidget {
  final BlocBase bloc;

  InheritedBloc({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedBloc old) => bloc != old.bloc;
}


