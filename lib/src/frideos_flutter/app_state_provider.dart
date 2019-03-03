import 'package:flutter/material.dart';

import '../frideos_dart/interfaces/app_state.dart';

/// Simple state provider that extends a StatefulWidget and use an InheritedWidget 
/// to share the state with the widgets on the tree.
/// 
/// Used along with streams, it is possibile for the widgets the access this data to 
/// modify it and propagates the changes to the entire widgets tree.
/// 
class AppStateProvider<T extends AppStateModel> extends StatefulWidget {
  AppStateProvider({this.appState, this.child});

  final T appState;
  final Widget child;

  @override
  _AppStateProviderState createState() {
    return new _AppStateProviderState();
  }

  static T of<T extends AppStateModel>(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedState)
            as _InheritedState)
        .state;
  }
}

class _AppStateProviderState extends State<AppStateProvider> {
  @override
  void initState() {
    super.initState();
    widget.appState.init();    
  }

  @override
  void dispose() {
    widget.appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedState(state: widget.appState, child: widget.child);
  }
}

class _InheritedState extends InheritedWidget {
  final AppStateModel state;

  _InheritedState({
    Key key,
    @required this.state,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedState old) => state != old.state;
}
