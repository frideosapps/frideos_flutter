import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';
import 'package:frideos/src/scenes_object/scene.dart';
import 'package:frideos/src/scenes_object/scenes_object.dart';

///
///
/// This widget uses a [ScenesObject] for the timing of the widgets
/// visualization.
///
/// It takes as a parameter a List<Scene> and plays every [Scene].
///
/// By default to change the stage is used the relative time, so the time
/// parameter of the [Scene] indicates how much time the stage will lasts.
/// Instead, to specify the absolute time, set to true the [absoluteTiming]
/// flag, in this case the time parameter indicates the absolute time when
/// to show the scene.
///
/// The [onStart] is used to call a function when the ScenesObject begins
/// to play the stages.
///
/// The [onEnd] callback is called at the end of the last stage when the timeing
/// is relative (the [absoluteTiming] flag is set to false).
///
/// #### Usage
/// From the ScenesObject example:
///
/// ```dart
///ScenesCreate(
///  scenes: [
///    Scene(
///         widget: SingleScene(
///          color: Colors.white,
///          text: 'Scene 1',
///        ),
///        time: 3500,
///        onShow: () {
///          print('Showing scene 1');
///        }),
///    Scene(
///        widget: SingleScene(
///          color: Colors.blue,
///          text: 'Scene 2',
///        ),
///        time: 3500,
///        onShow: () {
///          print('Showing scene 2');
///        }),
///    Scene(
///        widget: SingleScene(
///          color: Colors.brown,
///          text: 'Scene 3',
///        ),
///        time: 3500,
///        onShow: () {
///          print('Showing scene 3');
///        }),
///  ],
///  onStart: () => print('Start playing scenes!'),
///  onEnd: () => print('End playing scenes!'),
///),
///
///
///// The singleScene widget:
///
/// class SingleScene extends StatelessWidget {
///   const SingleScene({Key key, this.text, this.color}) : super(key: key);
///
///   final String text;
///   final Color color;
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       alignment: Alignment.center,
///       color: color,
///       child: Text(text),
///     );
///   }
/// }
/// ```
class ScenesCreate extends StatefulWidget {
  const ScenesCreate(
      {@required this.scenes,
      Key key,
      this.absoluteTiming = false,
      this.onStart,
      this.onEnd})
      : assert(scenes != null, 'The scenes argument is null.'),
        super(key: key);

  final List<Scene> scenes;
  final bool absoluteTiming;
  final Function onStart;
  final Function onEnd;

  @override
  _ScenesCreateState createState() {
    return _ScenesCreateState();
  }
}

class _ScenesCreateState extends State<ScenesCreate> {
  final ScenesObject scenesObject = ScenesObject();

  @override
  void initState() {
    super.initState();
    if (widget.onStart != null) {
      scenesObject.setCallback(widget.onStart);
    }
    if (widget.onEnd != null) {
      scenesObject.setOnEndCallback(widget.onEnd);
    }
    scenesObject
      ..setScenesList(widget.scenes)
      ..startScenes();
  }

  @override
  void dispose() {
    scenesObject.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = scenesObject.getScene(0);
    assert(stage != null);
    return ValueBuilder(
        streamed: scenesObject, builder: (context, snapshot) => snapshot.data);
  }
}
