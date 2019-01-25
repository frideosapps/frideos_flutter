import 'package:flutter/material.dart';

abstract class BlocBase {
  dispose();
}

class BlocProvider extends StatefulWidget {
  BlocProvider({this.bloc, this.child});
  final BlocBase bloc;
  final Widget child;

  @override
  _BlocProviderState createState() {
    return new _BlocProviderState();
  }

  static BlocBase of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedBloc)
            as _InheritedBloc)
        .bloc;
  }
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _InheritedBloc(bloc: widget.bloc, child: widget.child);
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

class _InheritedBloc extends InheritedWidget {
  final BlocBase bloc;

  _InheritedBloc({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedBloc old) => bloc != old.bloc;
}
