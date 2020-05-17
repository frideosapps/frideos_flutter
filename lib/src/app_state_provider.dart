import 'package:flutter/material.dart';

import 'interfaces/app_state.dart';

/// Simple state provider that extends a StatefulWidget and use
/// an InheritedWidget to share the state with the widgets on the tree.
///
/// Used along with streams, it is possibile for the widgets the access
/// this data to modify it and propagates the changes to the entire widgets
/// tree.
///
class AppStateProvider<T extends AppStateModel> extends StatefulWidget {
  const AppStateProvider(
      {@required this.appState, @required this.child, this.initAppState = true})
      : assert(appState != null, 'The appState argument is null.'),
        assert(child != null, 'The child argument is null.');

  final T appState;
  final Widget child;
  final bool initAppState;

  @override
  _AppStateProviderState createState() => _AppStateProviderState();

  static T of<T extends AppStateModel>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_InheritedState>().state;
}

class _AppStateProviderState extends State<AppStateProvider> {
  @override
  void initState() {
    super.initState();
    if (widget.initAppState) {
      widget.appState.init();
    }
  }

  @override
  void dispose() {
    widget.appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _InheritedState(state: widget.appState, child: widget.child);
}

class _InheritedState extends InheritedWidget {
  const _InheritedState({
    @required this.state,
    @required Widget child,
    Key key,
  }) : super(key: key, child: child);

  final AppStateModel state;

  @override
  bool updateShouldNotify(_InheritedState old) => state != old.state;
}
