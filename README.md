# Frideos [![pub package](https://img.shields.io/pub/v/frideos.svg)](https://pub.dartlang.org/packages/frideos)

Helpers for state management, streams and BLoC pattern, SharedPreferences and various widgets (animations, blur, transitions, timed widgets, scrollingtext, etc.).

#### - [Helpers for state management](#state-management)

- AppStateModel
- AppStateProvider

#### - [Helpers for streams and BLoC pattern](#streams-and-bloc-pattern):

- StreamedValue
- StreamedTransformed
- StreamedList
- StreamedMap
- MemoryValue
- HistoryObject
- StreamedSender
- Tunnel pattern: ListSender and MapSender

#### - [Helper class with static methods for the SharedPreferences package](#sharedpreferences-helper)

#### - [Widgets for streams and futures](#widgets)

- ValueBuilder
- StreamedWidget
- ReceiverWidget
- FuturedWidget

#### - [Classes for animations and timing](#animations-and-timing)

- TimerObject
- AnimatedObject
- StagedObject
- StagedWidget

#### - [Widgets for effects](#effects)

- LinearTransition
- CurvedTransition
- FadeInWidget
- FadeOutWidget
- BlurWidget
- BlurInWidget
- BlurOutWidget
- AnimatedBlurWidget
- WavesWidget

#### - [Various widgets](#various)

- ScrollingText
- HorizontalSlider
- VerticalSlider

#### - [Examples built with this library](#examples)

### Dependencies

- [RxDart](https://pub.dartlang.org/packages/rxdart)
- [SharedPreferences](https://pub.dartlang.org/packages/shared_preferences) 


## State management

By extending the AppStateModel interface it is possible to create a class to drive the AppStateProvider in order to provide the data to the widgets.

From the "theme changer" example:

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
      currentTheme.value =
          themes.firstWhere((theme) => theme.name == lastTheme);
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
        stream: theme,
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
                    stream: appState.currentTheme,
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


## Streams and BLoC pattern

Utility classes to make a little bit easier working with streams/RxDart and Flutter. 

This example (you can find it in the example folder of this repo) shows how to use some classes of this library, and a comparison code without it. It is just a page with two textfields to add a key/value pair to a map. The map is then used to drive a ListView.builder showing all the pairs.

#### Common code

```dart
class Validators {
  final validateText =
      StreamTransformer<String, String>.fromHandlers(handleData: (str, sink) {
    if (str.isNotEmpty) {
      sink.add(str);
    } else {
      sink.addError('The text must not be empty.');
    }
  });

  final validateKey =
      StreamTransformer<String, int>.fromHandlers(handleData: (key, sink) {
    var k = int.tryParse(key);
    if (k != null) {
      sink.add(k);
    } else {
      sink.addError('The key must be an integer.');
    }
  });
}
```

1. ##### BLoC without this library

```dart
class StreamedMapCleanBloc extends BlocBase with Validators {
  StreamedMapCleanBloc() {
    print('-------StreamedMapClean BLOC--------');
  }

  final _map = BehaviorSubject<Map<int, String>>();
  Stream<Map<int, String>> get outMap => _map.stream;
  Function(Map<int, String> map) get inMap => _map.sink.add;
  final map = Map<int, String>();

  final _text = BehaviorSubject<String>();
  Stream<String> get outText => _text.stream;
  Stream<String> get outTextTransformed => _text.stream.transform(validateText);
  Function(String text) get inText => _text.sink.add;

  final _key = BehaviorSubject<String>();
  Stream<String> get outKey => _key.stream;
  Stream<int> get outKeyTransformed => _key.stream.transform(validateKey);
  Function(String) get inKey => _key.sink.add;

  Observable<bool> get isFilled => Observable.combineLatest2(
      outTextTransformed, outKeyTransformed, (a, b) => true);

  // Add to the streamed map the key/value pair put by the user
  addText() {
    var key = int.parse(_key.value);
    var value = _text.value;
    var streamMap = _map.value;

    if (streamMap != null) {
      map.addAll(streamMap);
    }

    map[key] = value;
    inMap(map);
  }

  dispose() {
    print('-------StreamedMapClean BLOC DISPOSE--------');

    _map.close();
    _text.close();
    _key.close();
  }
}
```

2. ##### With this library:

```dart
class StreamedMapBloc extends BlocBase with Validators {
  StreamedMapBloc() {
    print('-------StreamedMap BLOC--------');

    // Set the validation transformers for the textfields
    streamedText.setTransformer(validateText);
    streamedKey.setTransformer(validateKey);

    // Activate the debug console messages on disposing
    streamedKey.debugMode();
    streamedKey.debugMode();
    streamedMap.debugMode();
  }

  final streamedMap = StreamedMap<int, String>(initialData: Map());
  final streamedText = StreamedTransformed<String, String>();
  final streamedKey = StreamedTransformed<String, int>();

  Observable<bool> get isFilled => Observable.combineLatest2(
      streamedText.outTransformed, streamedKey.outTransformed, (a, b) => true);

  // Add to the streamed map the key/value pair put by the user
  addText() {
    var key = int.parse(streamedKey.value);
    var value = streamedText.value;

    streamedMap.addKey(key, value);

    // Or, as an alternative:
    //streamedMap.value[key] = value;
    //streamedMap.refresh();
  }

  dispose() {
    print('-------StreamedMap BLOC DISPOSE--------');
    streamedMap.dispose();
    streamedText.dispose();
    streamedKey.dispose();
  }
}
```

As you can see the code is more clean, easier to read and to mantain.

### StreamedValue

Used in tandem with the StreamedWidget/StreamBuilder/ValueBuilder, it automatically triggers the refresh of the widget when a new value is set.

This essentially does a simple thing: every time a new value is set, this is compared to the oldest one and if it is different assigned to the variable and sent to stream. Why this? So that when a new value is set, it automatically triggers the StreamerBuilder of the widget and it refreshes without the need to manually add the value to the sink of the stream.

So for example, instead of doing something like this:

```dart
counter += 1;
stream.sink.add(counter);
```

It becomes just:

```dart
counter.value += 1;
```

Then the StreamedValue is used to drive a ValueBuilder/StreamedWidget/StreamBuilder using the outStream getter.

N.B. when the type is not a basic type (e.g int, double, String etc.) and the value of a property of the object is changed, it is necessary to call the `refresh` method to update the stream.

N.B. Using both StreamedWidget and StreamBuilder it is necessary to pass to the `iniitialData` parameter, the value of the stream (e.g. using the getter `value` of the StreamedObjects).

#### Usage

```dart
// In the BLoC
final count = StreamedValue<int>(initialData: 0);

incrementCounter() {
  count.value += 2.0;
}

// View
ValueBuilder<int>(                
  stream: bloc.count, // no need of the outStream getter with ValueBuilder
  builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
    Text('Value: ${snapshot.data}', style: styleValue),
  noDataChild: Text('NO DATA'),
),

// Alternative:
//
// StreamedWidget<int>(
//    initialData: bloc.count
//    stream: bloc.count.outStream,
//    builder: (BuildContext context,
//        AsyncSnapshot<int> snapshot) => Text('Value: ${snapshot.data}',
//    noDataChild: Text('NO DATA'),
//),

RaisedButton(
    color: buttonColor,
    child: Text('+'),
    onPressed: () {
      bloc.incrementCounter();
    },
),
```

### StreamedTransformed

A special StreamedValue that is used when there is the need to use a StreamTransformer (e.g. validation of input fields).

#### Usage

From the StreamedMap example:

```dart
// In the BLoC class
final streamedKey = StreamedTransformed<String, int>();



// In the constructor of the BLoC class
streamedKey.setTransformer(validateKey);



// Validation (e.g. in the BLoC or in a mixin class)
final validateKey =
      StreamTransformer<String, int>.fromHandlers(handleData: (key, sink) {
    var k = int.tryParse(key);
    if (k != null) {
      sink.add(k);
    } else {
      sink.addError('The key must be an integer.');
    }
  });


// In the view:
StreamBuilder(
            stream: bloc.streamedKey.outTransformed,
            builder: (context, AsyncSnapshot<int> snapshot) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Key:',
                        hintText: 'Insert an integer...',
                        errorText: snapshot.error,
                      ),
                      // To avoid the user could insert text use the TextInputType.number
                      // Here is commented to show the error msg.
                      //keyboardType: TextInputType.number,
                      onChanged: bloc.streamedKey.inStream,
                    ),
                  ),
                ],
              );
            }),
```

### StreamedList

This class has been created to work with lists. It works like [StreamedValue].

To modify the list (e.g. adding items) and update the stream automatically
use these methods:

- [addElement]
- [clear]
- [removeAt]
- [removeElement]
- [replaceAt]
- [replace]

For other direct actions on the list, to update the stream call
the [refresh] method instead.

#### Usage

e.g. adding an item:

```dart
 streamedList.addElement(item);
```

it is the same as:

```dart
  streamedList.value.add(item);
  streamedList.refresh();
```

From the StreamedList example:

```dart
  final streamedList = StreamedList<String>();


  // Add to the streamed list the string from the textfield
  addText() {
    streamedList.addElement(streamedText.value);

    // Or, as an alternative:
    // streamedList.value.add(streamedText.value);
    // streamedList.refresh(); // To refresh the stream with the new value
  }
```

### StreamedMap

This class has been created to work with maps, it works like [StreamedList].

To modify the list (e.g. adding items) and update the stream automatically
use these methods:

- [addKey]
- [removeKey]
- [clear]

For other direct actions on the map, to update the stream call
the [refresh] method instead.

#### Usage

e.g. adding a key/value pair:

```dart
  streamedMap.addKey(1, 'first');
```

it is the same as:

```dart
   streamedMap.value[1] = 'first';
   streamedList.refresh();
```

From the streamed map example:

```dart
  final streamedMap = StreamedMap<int, String>();


  // Add to the streamed map the key/value pair put by the user
  addText() {
    var key = int.parse(streamedKey.value);
    var value = streamedText.value;

    streamedMap.addKey(key, value);

    // Or, as an alternative:
    //streamedMap.value[key] = value;
    //streamedMap.refresh();
  }
```

### MemoryValue

The MemoryObject has a property to preserve the previous value. The setter checks for the new value, if it is different from the one already stored, this one is given [oldValue] before storing and streaming the new one.

#### Usage

```dart
final countMemory = MemoryValue<int>();

countMemory.value // current value
couneMemory.oldValue // previous value
```

## HistoryObject

Extends the [MemoryValue] class, adding a [StreamedCollection]. Useful when it is need to store a value in a list.

```dart
final countHistory = HistoryObject<int>();

incrementCounterHistory() {
  countHistory.value++;
}

saveToHistory() {
  countHistory.saveValue();
}
```

## Tunnel pattern

Easy pattern to share data between two blocs.

### StreamedSender

Used to make a one-way tunnel beetween two blocs (from blocA to a StremedValue on blocB).

#### Usage

1. #### Define a [StreamedValueBase] derived object in the blocB

```dart
final receiverStr = StreamedValue<String>();
```

2. #### Define a [StreamedSender] in the blocA

```dart
final tunnelSenderStr = StreamedSender<String>();
```

3. #### Set the receiver in the sender on the class the holds the instances of the blocs

```dart
blocA.tunnelSenderStr.setReceiver(blocB.receiverStr);
```

4. #### To send data from blocA to bloc B then:

```dart
tunnelSenderStr.send("Text from blocA to blocB");
```

## ListSender and MapSender

Like the StreamedSender, but used with collections.

#### Usage

1. #### Define a [StreamedList] or [StreamedMap]object in the blocB

```dart
final receiverList = StreamedList<int>();
final receiverMap = StreamedMap<int, String>();
```

2. #### Define a [ListSender]/[MapSender] in the blocA

```dart
final tunnelList = ListSender<int>();
final tunnelMap = MapSender<int, String>();
```

3. #### Set the receiver in the sender on the class the holds the instances of the blocs

```dart
blocA.tunnelList.setReceiver(blocB.receiverList);
blocA.tunnelMap.setReceiver(blocB.receiverMap);
```

4. #### To send data from blocA to bloc B then:

```dart
tunnelList.send(list);
tunnelMap.send(map);
```


# SharedPreferences helper

### - savePrefs(String Key, T value)
### - saveStringList(String Key, List<String> list)
### - getPref(String key)
### - getKeys()
### - remove(String key)


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

## Widgets

### ValueBuilder
It is a widget that extends the StreamBuilder class but takes as a stream parameter an object that implements the StreamedObject interface.

#### Usage

```dart
ValueBuilder<String>(
  stream: streamedValue,        
  builder: (BuildContext context, AsyncSnapshot<String> snasphot) => Text(snasphot.data),
  noDataChild: // Widget to show when the stream has no data
  onNoData: () => // or Callback
  errorChild: // Widget to show on error
  onError: (error) => // or Callback
)
```

### StreamedWidget
It extends that StreamBuilder class, provides some callbacks to handle the state of the stream and return a `Container()` if `noDataChild` is not provided, to avoid to check if the `snapshot.hasData` is true. To use when there is no need to receive a null value.

#### Usage

```dart
StreamedWidget<String>(stream: stream, builder: (BuildContext context, AsyncSnapshot<String> snasphot)
  => Text(snasphot.data),
  noDataChild: // Widget to show when the stream has no data
  onNoData: () => // or Callback
  errorChild: // Widget to show on error
  onError: (error) => // or Callback
)
```

N.B. The callback is executed only if the respective child is not provided.

### ReceiverWidget

Used with a StreamedValue when the type is a widget to directly stream a widget to the view. Under the hood a StreamedWidget handles the stream and shows the widget.

#### Usage

```dart
ReceiverWidget(stream: streamedValue.outStream),
```

### FuturedWidget

It's a wrapper for the FutureBuilder that gives the possibility to choose directly in the widget the widget to show on waiting the future is resolving or in case of errore or, in alternative, to use the relative callbacks.

#### Usage

```dart
FuturedWidget<String>(future: future, builder: (BuildContext context, AsyncSnapshot<String> snasphot)
  => Text(snasphot.data),
  waitingChild: // Widget to show on waiting
  onWaiting: () => // or Callback
  errorChild: // Widget to show on error
  onError: (error) => // or Callback
)
```

N.B. The callback is executed only if the respective child is not provided.




## Animations and timing

### TimerObject

An object that embeds a timer and a stopwatch.

#### Usage

```dart
final timerObject = TimerObject();

startTimer() {
  timerObject.startTimer();
}

stopTimer() {
  timerObject.stopTimer();
}

getLapTime() {
  timerObject.getLapTime();
}

incrementCounter(Timer t) {
  counter.value += 2.0;
}

startPeriodic() {
   var interval = Duration(milliseconds: 1000);
   timerObject.startPeriodic(interval, incrementCounter);
}

```

### AnimatedObject

This class is used to update a value over a period of time. Useful to handle animations using the BLoC pattern.

From the AnimatedObject example:

![AnimatedObject](https://i.imgur.com/10nfh0R.gif)

#### Usage

- #### In the BLoC:

```dart
// Initial value 0.5, updating interval 20 milliseconds
  final scaleAnimation =
      AnimatedObject<double>(initialValue: 0.5, interval: 20);

      
  final rotationAnimation =
      AnimatedObject<double>(initialValue: 0.5, interval: 20);

  start() {
    scaleAnimation.start(updateScale);
    rotationAnimation.start(updateRotation);
  }

  updateScale(Timer t) {
    scaleAnimation.value += 0.03;

    if (scaleAnimation.value > 8.0) {
      scaleAnimation.reset();
    }
  }

  updateRotation(Timer t) {
    rotationAnimation.value += 0.1;
  }


  stop() {
    scaleAnimation.stop();
    rotationAnimation.stop();
  }

  reset() {
    scaleAnimation.reset();
    rotationAnimation.reset();
  }
```

- #### In the view:

```dart
      Container(
          color: Colors.blueGrey[100],
          child: Column(
            children: <Widget>[
              Container(height: 20.0,),
              StreamedWidget<AnimatedStatus>(
                initialData: AnimatedStatus.stop,
                stream: bloc.scaleAnimation.statusStream,
                builder: (context, AsyncSnapshot<AnimatedStatus> snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      snapshot.data == AnimatedStatus.active
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: Text('Reset'),
                              onPressed: () {
                                bloc.reset();
                              })
                          : Container(),
                      snapshot.data == AnimatedStatus.stop
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: Text('Start'),
                              onPressed: () {
                                bloc.start();
                              })
                          : Container(),
                      snapshot.data == AnimatedStatus.active
                          ? RaisedButton(
                              color: Colors.lightBlueAccent,
                              child: Text('Stop'),
                              onPressed: () {
                                bloc.stop();
                              })
                          : Container(),
                    ],
                  );
                },
              ),
              Expanded(
                child: StreamedWidget(
                    stream: bloc.scaleAnimation.animationStream,
                    builder: (context, snapshot) {
                      return Transform.scale(
                          scale: snapshot.data,
                          // No need for StreamBuilder here, the widget
                          // is already updating
                          child: Transform.rotate(
                              angle: bloc.rotationAnimation.value,
                              // Same here
                              //
                              child: Transform(
                                  transform: Matrix4.rotationY(
                                      bloc.rotationAnimation.value),
                                  child: FlutterLogo())));
                    }),
              )
            ],
          ),
        ),
```

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

Linear cross fading transition between two widgets, it can be used with the [StagedObject].

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

## Examples

### 1. [General](https://github.com/frideosapps/frideos_flutter/tree/master/example)
An example app to show how to use this library.

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
  
### 2. [Counter](https://github.com/frideosapps/counter)
A simple app using the BLoC pattern showing a counter implemented with this library.

### 3. [Blood pressure](https://github.com/frideosapps/bloodpressure)
An example of a medical app built with Flutter for the classification of the arterial blood pressure.

### 4. [Pair game](https://github.com/frideosapps/pair_game)
A simple pair game (multiple selections, animations, tunnel pattern).

### 5. [Theme changer](https://github.com/frideosapps/theme_changer)
A starter app with a drawer and a dynamic theme changer, BLoC pattern, settings page.

