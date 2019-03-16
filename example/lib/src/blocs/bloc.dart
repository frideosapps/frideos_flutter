import 'package:flutter/material.dart';

abstract class BlocBase {
  void dispose();
}

class BlocProvider extends StatefulWidget {
  const BlocProvider({this.bloc, this.child});
  final BlocBase bloc;
  final Widget child;

  @override
  _BlocProviderState createState() {
    return _BlocProviderState();
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
  const _InheritedBloc({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  final BlocBase bloc;

  @override
  bool updateShouldNotify(_InheritedBloc old) => bloc != old.bloc;
}
