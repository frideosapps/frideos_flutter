import 'dart:async';

import 'package:flutter/material.dart';

///
///
///

typedef ErrorCallback = Widget Function(Object);

typedef WaitingCallback = Widget Function();

///
/// StreamedWidget is a wrapper for the [StreamBuilder] widget
///
/// If no [noDataChild] widget or [onNoData] callback is provided then a [Container] is shown
///
/// If no [errorChild] widget or no [onError] callback is provided then a [Container] is shown
///
///
class StreamedWidget<T> extends StreamBuilder<T> {
  const StreamedWidget(
      {Key key,
      this.initialData,
      Stream<T> stream,
      @required this.builder,
      this.noDataChild,
      this.onNoData,
      this.errorChild,
      this.onError})
      : super(key: key, stream: stream, builder: builder);

  final AsyncWidgetBuilder<T> builder;
  final T initialData;

  ///
  /// If the snapshot has no data then this widget is shown
  final Widget noDataChild;

  ///
  /// If no [noDataChild] is provided then the [onNoData] callback is called
  final WaitingCallback onNoData;

  ///
  /// This widget is shown if there is an error
  final Widget errorChild;

  ///
  /// If no [errorChild] is provided then the [onError] callback is called
  final ErrorCallback onError;

  @override
  Widget build(BuildContext context, AsyncSnapshot<T> currentSummary) {
    if (currentSummary.hasData) {
      return builder(context, currentSummary);
    }

    if (currentSummary.hasError) {
      if (errorChild != null) {
        return errorChild;
      } else {
        return onError != null ? onError(currentSummary.error) : Container();
      }
    }

    if (noDataChild != null) {
      return noDataChild;
    } else {
      return onNoData != null ? onNoData() : Container();
    }
  }
}


///
/// FuturedWidget is a wrapper for the [FutureBuilder] widget
///
/// If no [onWaitingWidget] widget or [onWaiting] callback is provided then a [Container] is shown
///
/// If no [errorChild] widget or no [onError] callback is provided then a [Container] is shown
///
///
class FuturedWidget<T> extends StatelessWidget {
  FuturedWidget(
      {this.initialData,
      @required this.future,
      @required this.builder,
      this.onWaitingChild,
      this.onWaiting,
      this.errorChild,
      this.onError});

  final T initialData;
  final Future<T> future;
  final AsyncWidgetBuilder<T> builder;

  ///
  /// If the snapshot has no data then this widget is shown
  final Widget onWaitingChild;

  ///
  /// If no [onWaitingChild] is provided then the [onWaiting] callback is called
  final WaitingCallback onWaiting;

  ///
  /// This widget is shown if there is an error
  final Widget errorChild;

  ///
  /// If no [errorChild] is provided then the [onError] callback is called
  final ErrorCallback onError;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        initialData: initialData,
        future: future,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          if (snapshot.hasData) {
            return builder(context, snapshot);
          }

          if (snapshot.hasError) {
            if (errorChild != null) {
              return errorChild;
            } else {
              return onError != null ? onError(snapshot.error) : Container();
            }
          }

          if (onWaitingChild != null) {
            return onWaitingChild;
          } else {
            return onWaiting != null ? onWaiting() : Container();
          }
        });
  }
}
