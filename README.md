# Frideos [![pub package](https://img.shields.io/pub/v/frideos.svg)](https://pub.dartlang.org/packages/frideos)

Helpers for state management, streams and BLoC pattern, SharedPreferences and various widgets (animations, blur, transitions, timed widgets, scrollingtext, etc.).

**frideos_core**  [![pub package](https://img.shields.io/pub/v/frideos_core.svg)](https://pub.dartlang.org/packages/frideos_core)

- **Breaking change**: it is now mandatory to import the file `frideos_core/frideos_core.dart` to use the `StreamedObjects` of the frideos_core package.


**frideos_light** [![pub package](https://img.shields.io/pub/v/frideos_light.svg)](https://pub.dartlang.org/packages/frideos_light)
- A light version of this package without dependencies other than the frideos_core package, has been released as [frideos_light](https://pub.dartlang.org/packages/frideos_light).

##### 1. [Helpers for state management](#state-management)

- AppStateModel
- AppStateProvider


##### 2. [Widgets for streams and futures](#widgets)

- ValueBuilder
- StreamedWidget
- ReceiverWidget
- FuturedWidget

##### 3. [StagedObject and StagedWidget for widgets timing](#widgets-timing)

- StagedObject
- StagedWidget

##### 4. [Widgets for effects](#effects)

- LinearTransition
- CurvedTransition
- FadeInWidget
- FadeOutWidget
- BlurWidget
- BlurInWidget
- BlurOutWidget
- AnimatedBlurWidget
- WavesWidget

##### 5. [Helper class with static methods for the SharedPreferences package](#sharedpreferences-helper)
  

##### 6. [Various widgets](#various)

- ScrollingText
- HorizontalSlider
- VerticalSlider

### Dependencies

- [RxDart](https://pub.dartlang.org/packages/rxdart)
- [SharedPreferences](https://pub.dartlang.org/packages/shared_preferences)
    
### Examples built with this library:

#### [Quiz game](https://github.com/frideosapps/trivia_example)
A simple trivia game built with Flutter and this package.

You can read an article about this example here: https://medium.com/flutter-community/flutter-how-to-build-a-quiz-game-596d0f369575

#### [Todo App](https://github.com/brianegan/flutter_architecture_samples/tree/master/frideos_library)
An implementation of the Todo App of the [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples) repository using this package.

#### [Frideos examples](https://github.com/frideosapps/frideos_examples)

An example app to show how to use some features of this library.

- Streamed objects
- Streamed collections
- TimerObject: a simple stopwatch
- StagedObject
- StagedWidget
- AnimatedObject
- Multiple selection and tunnel pattern (to share data between two blocs)
- LinearTransition
- CurvedTransition
- Blur (fixed, in, out, animated)
- WavesWidget
- Sliders

#### [Theme changer](https://github.com/frideosapps/theme_changer)

A simple starter app with a drawer, app state management, dynamic theme changer and persistent theme using the sharedpreferences.

#### [Counter](https://github.com/frideosapps/counter)

A simple app using the BLoC pattern showing a counter implemented with this library.

#### [Blood pressure](https://github.com/frideosapps/bloodpressure)

An example of a medical app built with Flutter for the classification of the arterial blood pressure.

#### [Pair game](https://github.com/frideosapps/pair_game)

A simple pair game (multiple selections, animations, tunnel pattern).
  

  

---  
  
    
    
## State management

By extending the AppStateModel interface it is possible to create a class to drive the AppStateProvider in order to provide the data to the widgets.

From the "theme changer" example (N.B. in this "light" version of the frideos package there is no SharedPreferences helper class):

#### 1. Create a model for the app state:

```dart
class AppState extends AppStateModel {
  List<MyTheme> themes;
  StreamedValue<MyTheme> currentTheme;

  AppState() {
    print('-------APP STATE INIT--------');

    themes = List<MyTheme>();

    themes.addAll([
      MyTheme(
        name: 'Default',
        brightness: Brightness.light,
        backgroundColor: Colors.blue[50],
        scaffoldBackgroundColor: Colors.blue[50],
        primaryColor: Colors.blue,
        primaryColorBrightness: Brightness.dark,
        accentColor: Colors.blue[300],
      ),
      MyTheme(
        name: 'Teal',
        brightness: Brightness.light,
        backgroundColor: Colors.teal[50],
        scaffoldBackgroundColor: Colors.teal[50],
        primaryColor: Colors.teal[600],
        primaryColorBrightness: Brightness.dark,
        accentColor: Colors.teal[300],
      ),
      MyTheme(
        name: 'Orange',
        brightness: Brightness.light,
        backgroundColor: Colors.orange[50],
        scaffoldBackgroundColor: Colors.orange[50],
        primaryColor: Colors.orange[600],
        primaryColorBrightness: Brightness.dark,
        accentColor: Colors.orange[300],
      ),
    ]);

    currentTheme = StreamedValue();
  }

  void setTheme(MyTheme theme) {
    currentTheme.value = theme;
    Prefs.savePref<String>('theme', theme.name);
  }

  @override
  void init() async {
    String lastTheme = await Prefs.getPref('theme');
    if (lastTheme != null) {
      currentTheme.value = themes.firstWhere((theme) => theme.name == lastTheme,
          orElse: () => themes[0]);
    } else {
      currentTheme.value = themes[1];
    }
  }

  @override
  dispose() {
    print('---------APP STATE DISPOSE-----------');
    currentTheme.dispose();
  }
}
```

#### 2. Wrap the MaterialApp in the AppStateProvider:

```dart
void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AppState appState;

  @override
  void initState() {
    super.initState();
    appState = AppState();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider<AppState>(
      appState: appState,
      child: MaterialPage(),
    );
  }
}
```

#### 3. Consume the data:

```dart
class MaterialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = AppStateProvider.of<AppState>(context).currentTheme;

    return ValueBuilder<MyTheme>(
        streamed: theme,
        builder: (context, snapshot) {
          return MaterialApp(
              title: "Theme and drawer starter app",
              theme: _buildThemeData(snapshot.data),
              home: HomePage());
        });
  }

  _buildThemeData(MyTheme appTheme) {
    return ThemeData(
      brightness: appTheme.brightness,
      backgroundColor: appTheme.backgroundColor,
      scaffoldBackgroundColor: appTheme.scaffoldBackgroundColor,
      primaryColor: appTheme.primaryColor,
      primaryColorBrightness: appTheme.primaryColorBrightness,
      accentColor: appTheme.accentColor,
    );
  }
}
```

#### 4. Change the data (using a stream):

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = AppStateProvider.of<AppState>(context);

    _buildThemesList() {
      return appState.themes.map((MyTheme appTheme) {
        return DropdownMenuItem<MyTheme>(
          value: appTheme,
          child: Text(appTheme.name, style: TextStyle(fontSize: 14.0)),
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Choose a theme:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ValueBuilder<MyTheme>(
                    streamed: appState.currentTheme,
                    builder: (context, snapshot) {
                      return DropdownButton<MyTheme>(
                        hint: Text("Status"),
                        value: snapshot.data,
                        items: _buildThemesList(),
                        onChanged: appState.setTheme,
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## Widgets

### ValueBuilder

ValueBuilder extends the [StreamBuilder] widget providing some callbacks to handle the state of the stream and returning a [Container] if `noDataChild` is not provided, in order to avoid checking `snapshot.hasData`.

N.B. To use when there is no need to receive a _null value_.

It takes as a `streamed` parameter an object implementing the [StreamedObject] interface and triggers the rebuild of the widget whenever the stream emits a new event.

#### Usage

```dart
ValueBuilder<String>(
  streamed: streamedValue,
  builder: (context, snasphot) => Text(snasphot.data),
  initialData: // Data to provide for the initial snapshot
  noDataChild: // Widget to show when the stream has no data
  onNoData: () => // or Callback
  errorChild: // Widget to show on error
  onError: (error) => // or Callback
)
```

If no [noDataChild] widget or [onNoData] callback is provided then a [Container] is returned.

If no [errorChild] widget or no [onError] callback is provided then a [Container] is returned.

N.B. The callbacks are executed only if their respective child is not provided.

### StreamedWidget

StreamedWidget extends the [StreamBuilder] widget providing
some callbacks to handle the state of the stream and returning a
[Container] if `noDataChild` is not provided, in order to avoid
checking `snapshot.hasData`.

N.B. To use when there is no need to receive a _null value_.

It takes as a `stream` parameter a [Stream] and triggers the rebuild of the widget whenever the stream emits a new event.

If no [noDataChild] widget or [onNoData] callback is provided then a [Container] is returned.

If no [errorChild] widget or no [onError] callback is provided then a [Container] is returned.

#### Usage

```dart
StreamedWidget<String>(
  stream: stream,
  builder: (context, snasphot) => Text(snasphot.data),
  noDataChild: // Widget to show when the stream has no data
  onNoData: () => // or Callback
  errorChild: // Widget to show on error
  onError: (error) => // or Callback
)
```

In case of an object implementing the StreamedObject interface (eg. StreamedValue, StreameList etc.):

```dart
StreamedWidget<String>(
  stream: streamedObject.outStream, // outStream getter
  builder: (context, snasphot) => Text(snasphot.data),
  noDataChild: // Widget to show when the stream has no data
  onNoData: () => // or Callback
  errorChild: // Widget to show on error
  onError: (error) => // or Callback
)
```

N.B. The callbacks are executed only if their respective child is not provided.

### ReceiverWidget

Used with a StreamedValue when the type is a widget to directly stream a widget to the view. Under the hood a StreamedWidget handles the stream and shows the widget.

#### Usage

```dart
ReceiverWidget(stream: streamedValue.outStream),
```

### FuturedWidget

FuturedWidget is a wrapper for the [FutureBuilder] widget. It provides some callbacks to handle the state of the future and returning a [Container] if `onWaitingChild` is not provided, in order to avoid checking `snapshot.hasData`.

#### Usage

```dart
FuturedWidget<String>(
  future: future,
  builder: (context, snasphot) => Text(snasphot.data),
  initialData: // Data to provide if the snapshot is null or still not completed
  waitingChild: // Widget to show on waiting
  onWaiting: () => // or Callback
  errorChild: // Widget to show on error
  onError: (error) => // or Callback
)
```

If no [onWaitingChild] widget or [onWaiting] callback is provided then a [Container] is returned.

If no [errorChild] widget or no [onError] callback is provided then a [Container] is returned.

N.B. The callbacks are executed only if their respective child is not provided.

## Widgets timing

### StagedObject

A complex class to hadle the rendering of widgets over the time. It takes a collection of "Stages" and triggers the visualization of the widgets at a given time (relative o absolute timing). For example to make a demostration on how to use an application, showing the widgets and pages along with explanations.

![StagedObject](https://i.imgur.com/9XLb7JD.gif)

Every stage is handled by using the Stage class:

```dart
class Stage {
  Widget widget;
  int time; // milliseconds
  Function onShow = () {};
  Stage({this.widget, this.time, this.onShow});
}
```

##### N.B. The onShow callback is used to trigger an action when the stage shows

#### Usage

From the StagedObject example:

1. #### Declare a map <int, Stage>
   Here the map is in the view and is set in the BLoC class by the setStagesMap.

```dart
Map<int, Stage> get stagesMap => <int, Stage>{
  0: Stage(
      widget: Container(
        width: 200.0,
        height: 200.0,
        color: Colors.indigo[200],
        alignment: Alignment.center,
        key: Key('0'),
        child: ScrollingText(
          text:
            'This stage will last 8 seconds. By the onShow call back it is possibile to assign an action when the widget shows.',
          scrollingDuration: 2000,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18.0,
            fontWeight: FontWeight.w500)),
        ),
      time: 8000,
      onShow: () {}),
  1: Stage(
      widget: Container(
        width: 200.0,
        height: 200.0,
        color: Colors.indigo[200],
        alignment: Alignment.center,
        key: Key('00'),
        child: ScrollingText(
              text: 'The next widgets will cross      fade.',
              scrollingDuration: 2000,
            ),
          ),
      time: 8000,
      onShow: () {}),

}
```

2. #### In the BLoC

```dart
  final text = StreamedValue<String>();
  final staged = StagedObject();


  // The map can be set through the constructor of the StagedObject
  // or by the setStagesMap method like in this case.
  setMap(Map<int, Stage> stagesMap) {
    staged.setStagesMap(stagesMap);
  }


  // This method is then called from a button in the view
  start() {
    if (staged.getMapLength() > 0) {
      staged.setCallback(sendNextStageText);
      staged.startStages();
    }
  }

  // By this method we get the next stage to show it
  // in a little box below the current stage
  sendNextStageText() {
    var nextStage = staged.getNextStage();
    if (nextStage != null) {
      text.value = "Next stage:";
      widget.value = nextStage.widget;
      stage.value = StageBridge(
          staged.getStageIndex(), staged.getCurrentStage(), nextStage);
    } else {
      text.value = "This is the last stage";
      widget.value = Container();
    }
  }

```

3. #### In the view:

```dart
  // Setting the map in the build method
  StagedObjectBloc bloc = BlocProvider.of(context);
  bloc.setMap(stagesMap);


  // To show the current widget on the view using the ReceiverWidget.
  // As an alternative it can be used the StreamedWidget/StreamBuilder.
  ReceiverWidget(
    stream: bloc.staged.widgetStream,
  ),
```

### StagedWidget

![StagedWidget](https://i.imgur.com/nCsbJCy.gif)

#### Usage

1. #### Declare a map <int, Stage>
   Here the map is in the view and is set in the BLoC class by the setStagesMap.

```dart
Map<int, Stage> get stagesMap => <int, Stage>{
  0: Stage(
      widget: Container(
        width: 200.0,
        height: 200.0,
        color: Colors.indigo[200],
        alignment: Alignment.center,
        key: Key('0'),
        child: ScrollingText(
          text:
            'This stage will last 8 seconds. By the onShow call back it is possibile to assign an action when the widget shows.',
          scrollingDuration: 2000,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18.0,
            fontWeight: FontWeight.w500)),
        ),
      time: 8000,
      onShow: () {}),
  1: Stage(
      widget: Container(
        width: 200.0,
        height: 200.0,
        color: Colors.indigo[200],
        alignment: Alignment.center,
        key: Key('00'),
        child: ScrollingText(
              text: 'The next widgets will cross      fade.',
              scrollingDuration: 2000,
            ),
          ),
      time: 8000,
      onShow: () {}),

}
```

2. #### In the view:

```dart
StagedWidget(
  stagesMap: stagesMap,
  onStart: // function to call,
  onEnd: () {
    // Function to call at the end of the last stage
    // (only if relative timing):
    // e.g. Navigator.pop(context);
  }),
```

## Effects

### LinearTransition

Linear cross fading transition between two widgets, it can be used with the `StagedObject`.

![LinearTransition](https://i.imgur.com/viGPpCu.gif)

#### Usage

```dart
LinearTransition(
  firstWidget: Container(height: 100.0, width: 100.0,
        color: Colors.blue),
  secondWidget: Container(height: 100.0, width: 100.0,
        color: Colors.lime),
  transitionDuration: 4000,
),
```

### CurvedTransition

Cross fading transition between two widgets. This uses the Flutter way to make an animation.

![CurvedTransition](https://i.imgur.com/kxWOKMU.gif)

#### Usage

```dart
CurvedTransition(
  firstWidget: Container(height: 100.0, width: 100.0,
     color: Colors.blue),
  secondWidget: Container(height: 100.0, width: 100.0,
     color: Colors.lime),
  transitionDuration: 4000,
  curve: Curves.bounceInOut,
),
```

### FadeInWidget

#### Usage

```dart
FadeInWidget(
  duration: 7000,
  child: ScrollingText(
      text: 'Fade in text',
      scrollingDuration: 2000,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 94.0,
        fontWeight: FontWeight.w500,
      ),
    ),
),
```

### FadeOutWidget

#### Usage

```dart
FadeOutWidget(
  duration: 7000,
  child: ScrollingText(
      text: 'Fade out text',
      scrollingDuration: 2000,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 94.0,
        fontWeight: FontWeight.w500,
      ),
    ),
),
```

### BlurWidget

![Blur](https://i.imgur.com/Q8CJboZ.png)

#### Usage

```dart
BlurWidget(
  sigmaX: 2.0,
  sigmaY: 3.0,
  child: Text('Fixed blur')
)
```

### BlurInWidget

#### Usage

```dart
BlurInWidget(
  initialSigmaX: 2.0,
  initialSigmaY: 12.0,
  duration: 5000,
  refreshTime: 20,
  child: Text('Blur out'),
)
```

### BlurOutWidget

#### Usage

```dart
BlurOutWidget(
  finalSigmaX: 2.0,
  finalSigmaY: 12.0,
  duration: 5000,
  refreshTime: 20,
  child: Text('Blur out'),
)
```

### AnimatedBlurWidget

#### Usage

```dart
AnimatedBlurWidget(
  initialSigmaX: 2.0,
  initialSigmaY: 3.0,
  finalSigmaX: 2.0,
  finalSigmaY: 3.0,
  duration: 5000,
  reverseAnimation: true,
  loop: true,
  refreshTime: 20,
  child: Text('Fixed blur')
)
```

### WavesWidget

#### Usage

```dart
WavesWidget(
  width: 128.0,
  height: 128.0,
  color: Colors.red,
  child: Container(
    color: Colors.red[400],
 ),
```

## SharedPreferences helper

#### - savePrefs(String Key, T value)

#### - saveStringList(String Key, List<String> list)

#### - getPref(String key)

#### - getKeys()

#### - remove(String key)

From the "Theme changer" example:

##### - Save the theme choosed so that the next time it will be set on startup

```dart
void setTheme(MyTheme theme) {
  currentTheme.value = theme;
  Prefs.savePref<String>('apptheme', theme.name);
}
```

##### - Load the theme when the app starts

```dart
@override
void init() async {
  String lastTheme = await Prefs.getPref('apptheme');
  if (lastTheme != null) {
    currentTheme.value =
      themes.firstWhere((theme) => theme.name == lastTheme, orElse: () => themes[0]);
  } else {
    currentTheme.value = themes[0];
  }
}
```

## Various

### ScrollingText

#### Usage

```dart
ScrollingText(
 text: 'Text scrolling (during 8 seconds).',
 scrollingDuration: 2000, // in milliseconds
 style: TextStyle(color: Colors.blue,
    fontSize: 18.0, fontWeight: FontWeight.w500),
),
```

### Sliders

![Sliders](https://i.imgur.com/H16VE01.gif)

#### Usage

```dart
HorizontalSlider(
  key: _horizontalSliderKey,
  rangeMin: 0.0,
  rangeMax: 3.14,
  //step: 1.0,
  initialValue: bloc.initialAngle,
  backgroundBar: Colors.indigo[50],
  foregroundBar: Colors.indigo[500],
  triangleColor: Colors.red,
  onSliding: (slider) {
    bloc.horizontalSlider(slider);
  },
)



VerticalSlider(
  key: _verticalSliderKey,
  rangeMin: 0.5,
  rangeMax: 5.5,
  step: 1.0, // Default value 1.0
  initialValue: bloc.initialScale,
  backgroundBar: Colors.indigo[50],
  foregroundBar: Colors.indigo[500],
  triangleColor: Colors.red,
  onSliding: (slider) {
    bloc.verticalSlider(slider);
  },
)
```