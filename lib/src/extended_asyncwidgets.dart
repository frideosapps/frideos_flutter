import 'dart:async';

import 'package:flutter/material.dart';

import 'core/core.dart';

///
///
///

typedef ErrorCallback = Widget Function(Object);

typedef WaitingCallback = Widget Function();

///
/// ValueBuilder extends the [StreamBuilder] widget providing
/// some callbacks to handle the state of the stream and returning a
/// [Container] if `noDataChild` is not provided, in order to avoid
/// checking `snapshot.hasData`.
///
/// N.B. To use when there is no need to receive a *null value*.
///
/// It takes as a `streamed` parameter an object implementing the
/// [StreamedObject] interface and triggers the rebuild of the widget
/// whenever the stream emits a new event.
///
///
/// #### Usage:
///
/// ```dart
/// ValueBuilder<String>(
///   streamed: streamedValue,
///   builder: (BuildContext context, snasphot) => Text(snasphot.data),
///   initialData: // Data to provide for the initial snapshot
///   noDataChild: // Widget to show when the stream has no data
///   onNoData: () => // or Callback
///   errorChild: // Widget to show on error
///   onError: (error) => // or Callback
/// )
/// ```
///
/// If no [noDataChild] widget or [onNoData] callback is provided then
/// a [Container] is returned.
///
/// If no [errorChild] widget or no [onError] callback is provided then
/// a [Container] is returned.
///
///
/// N.B. The callbacks are executed only if their respective child is
/// not provided.
///
///
class ValueBuilder<T> extends StreamBuilder<T> {
  ValueBuilder(
      {@required StreamedObject<T> streamed,
      @required this.builder,
      Key key,
      T initialData,
      this.noDataChild,
      this.onNoData,
      this.errorChild,
      this.onError})
      : assert(streamed != null, 'The streamed argument is null.'),
        assert(builder != null, 'The builder argument is null.'),
        super(
            key: key,
            initialData: initialData,
            stream: streamed.outStream,
            builder: builder);

  final AsyncWidgetBuilder<T> builder;

  ///
  /// If the snapshot has no data then this widget is returned
  final Widget noDataChild;

  ///
  /// If no [noDataChild] is provided then the [onNoData] callback is called
  final WaitingCallback onNoData;

  ///
  /// This widget is returned if there is an error
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
/// StreamedWidget extends the [StreamBuilder] widget providing
/// some callbacks to handle the state of the stream and returning a
/// [Container] if `noDataChild` is not provided, in order to avoid
/// checking `snapshot.hasData`.
///
/// N.B. To use when there is no need to receive a *null value*.
///
/// It takes as a `stream` parameter a [Stream] and triggers the rebuild
/// of the widget whenever the stream emits a new event.
///
///
///#### Usage
///
/// ```dart
/// StreamedWidget<String>(
///   stream: stream,
///   builder: (context, snasphot) => Text(snasphot.data),
///   initialData: // Data to provide for the initial snapshot
///   noDataChild: // Widget to show when the stream has no data
///   onNoData: () => // or Callback
///   errorChild: // Widget to show on error
///   onError: (error) => // or Callback
/// )
/// ```
///
/// In case of an object implementing the StreamedObject interface
/// (eg. StreamedValue, StreamedList etc.):
///
/// ```dart
/// StreamedWidget<String>(
///   stream: streamedObject.outStream, // outStream getter
///   builder: (context, snasphot) => Text(snasphot.data),
///   initialData: // Data to provide for the initial snapshot
///   noDataChild: // Widget to show when the stream has no data
///   onNoData: () => // or Callback
///   errorChild: // Widget to show on error
///   onError: (error) => // or Callback
/// )
/// ```
///
/// If no [noDataChild] widget or [onNoData] callback is provided then
/// a [Container] is returned.
///
/// If no [errorChild] widget or no [onError] callback is provided then
/// a [Container] is returned.
///
/// N.B. The callbacks are executed only if their respective child is
/// not provided.
///
///
class StreamedWidget<T> extends StreamBuilder<T> {
  const StreamedWidget(
      {@required Stream<T> stream,
      @required this.builder,
      Key key,
      this.initialData,
      this.noDataChild,
      this.onNoData,
      this.errorChild,
      this.onError})
      : assert(stream != null, 'The stream argument is null.'),
        assert(builder != null, 'The builder argument is null.'),
        super(key: key, stream: stream, builder: builder);

  final AsyncWidgetBuilder<T> builder;
  final T initialData;

  ///
  /// If the snapshot has no data then this widget is returned
  final Widget noDataChild;

  ///
  /// If no [noDataChild] is provided then the [onNoData] callback is called
  final WaitingCallback onNoData;

  ///
  /// This widget is returned if there is an error
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
/// FuturedWidget is a wrapper for the [FutureBuilder] widget. It provides
/// some callbacks to handle the state of the future and returning a
/// [Container] if `onWaitingChild` is not provided, in order to avoid
/// checking `snapshot.hasData`.
///
///
/// #### Usage
///
/// ```dart
/// FuturedWidget<String>(
///   future: future,
///   builder: (BuildContext context, snasphot) => Text(snasphot.data),
///   initialData: // Data to provide if the snapshot is null or still not completed
///   waitingChild: // Widget to show on waiting
///   onWaiting: () => // or Callback
///   errorChild: // Widget to show on error
///   onError: (error) => // or Callback
/// )
/// ```
///
/// If no [onWaitingChild] widget or [onWaiting] callback is provided then
/// a [Container] is returned.
///
/// If no [errorChild] widget or no [onError] callback is provided then
/// a [Container] is returned.
///
/// N.B. The callbacks are executed only if their respective child is
/// not provided.
///
///
class FuturedWidget<T> extends StatelessWidget {
  const FuturedWidget(
      {@required this.future,
      @required this.builder,
      Key key,
      this.initialData,
      this.onWaitingChild,
      this.onWaiting,
      this.errorChild,
      this.onError})
      : assert(future != null, 'The future argument is null.'),
        assert(builder != null, 'The builder argument is null.'),
        super(key: key);

  final T initialData;
  final Future<T> future;
  final AsyncWidgetBuilder<T> builder;

  ///
  /// If the snapshot has no data then this widget is returned
  final Widget onWaitingChild;

  ///
  /// If no [onWaitingChild] is provided then the [onWaiting] callback is called
  final WaitingCallback onWaiting;

  ///
  /// This widget is returned if there is an error
  final Widget errorChild;

  ///
  /// If no [errorChild] is provided then the [onError] callback is called
  final ErrorCallback onError;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        initialData: initialData,
        future: future,
        builder: (context, snapshot) {
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
