# Version 1.0.1 (17-05-20)
- Updated RxDart to 24.1
- Switch from inheritFromWidgetOfExactType to dependOnInheritedWidgetOfExactType on AppStateProvider class

# Version 1.0.0+1 (05-01-20)
- Fix package description

# Version 1.0.0 (05-01-20)
- Integrated frideos_core in the package
- Removed shared preferences helpers  
- Improved Readme.md, added an article
  
# Version 0.10.0+1 (28-12-19)
- CompositeItem fix

# Version 0.10.0 (28-12-19)
- ScenesWidget class renamed to ScenesCreate
- TweenAnimation to AnimationTween
- CurvedTween to AnimationCurved
- AnimationWidget to AnimationCreate
- CompositeTween to CompositeItem
- CompositeAnimation to AnimationComposite
- CompositeAnimationWidget to CompositeCreate
- Improved the AnimationCreate widget.

# Version 0.9.0 (25-12-19)
- Updated to RxDart 23.1
- Added classes for managing scenes: ScenesObject and ScenesWidget.
  
# Version 0.8.0 (08-12-19)
- Updated to RxDart 22.6
- Updated to SharedPreferences 0.5.4
- Removed sliders widgets
- Added helpers class for animations: TweenAnimation, CurvedTween, CompositeAnimation, CompositeTween

## Version 0.7.0+1 (21-06-19)
- Updated to frideos_core 0.5.0
- Updated to RxDart 0.22.0

## Version 0.6.2 (08-05-19)
- Added the parameter `initAppState` (set to `true` by default) to the `AppStateProvider` widget. Setting it to `false` the `init` method of the `AppStateModel` derived class passed to the `appState` parameter won't be called to the `initState` method of the `AppStateProvider`.
- Bugfix to the `Blur` widgets.
- Update README.md: added a `Dynamic fields validation` example.
- Updated to frideos_core 0.4.4.

## Version 0.6.1 (13-04-19)
- Update README.md: added a new example.
  
- Bugfix to the `LinearTransition` widget.

## Version 0.6.0 (31-03-19)

- **Breaking change**: integrated the [frideos_core](https://pub.dartlang.org/packages/frideos_core) package. It now mandatory to import the file `frideos_core/frideos_core.dart` to use the StreamedObjects.

- Updated the README.md.

- Updated dependency to RxDart version ^0.21

## Version 0.5.0+1 (23-03-19)

- Update the README.md: added a new example app (a Todo app).

- Package refactoring: in the example folder there is now a simple example of a counter implemented with this library (the previous examples in this [repository](https://github.com/frideosapps/frideos_examples)).

- Added some unit tests.



## Version 0.5.0 (21-03-19)
- *Breaking change*: the name of the parameter `stream` of the `ValueBuilder` widget was changed to `streamed` to highlight this is intended to use with the classes that implement the `StreamedObject` interface.
- Code refactoring
- Tests updated
- `README.md` updated

## Version 0.4.2 (16-03-19)
- Code refactoring
- Update Readme.md

## Version 0.4.1 (10-03-19)

### - StreamedList
  - Added `AddAll` method.  
  
### - AnimatedObject 
  - added `AnimatedType` enum, to handle the behavior of the animated object.
  - added `startAnimation` method: it is now possible specify a type of behavior (increment or decrement the value), the velocity, a minValue (in case of decrement) and a maxValue (increment).
  - added `outStream` getter (deprecated: `animationStream`).

  - Code refactoring.
  
### - Blur widgets and Wave widget refactored to use the ValueBuilder widget.

### - Code refactoring.

## Version 0.4.0+3 (08-03-19)
- Docs improved
- Code refactoring

## Version 0.4.0 (03-03-19)

### BREAKING CHANGES
Due to various changes in the code this version could cause issues on apps based on a previous version. Now, all the StreamedObjects need to have passed their value to the `initialData` parameter of the StreamBuilder/StreamedWidget (e.g. using the getter `value` of the StreamedObjects). As an alternative, they can be used with the new `ValueBuilder` widget, it extends the StreamBuilder class and get the value from the StreamedObject to pass to the `initialData` parameter.


### - AppStateModel
By extending the AppStateModel interface it is possible to create a class to drive the AppStateProvider in order to provide the data to the widgets.


### - AppStateProvider
Simple state provider that extends a StatefulWidget and use an InheritedWidget 
to share the state with the widgets on the tree. Used along with streams, it is possibile for the widgets the access this data to modify it and propagates the changes on the entire widgets tree.

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

### - ValueBuilder widget
Similar to the StreamedWidget, it extends the StreamBuilder class but takes as a stream parameter an object that implements the StreamedObject interface.

From the previous example:
```dart
ValueBuilder<MyTheme>(
  stream: theme,        
  builder: (context, snapshot) {
    return MaterialApp(
      title: "Theme and drawer starter app",
      theme: _buildThemeData(snapshot.data),
      home: HomePage(),
    );
  }
)
```


### - Helper class with static metods for the SharedPreferences package

#### 1. savePrefs(String Key, T value)
#### 2. saveStringList(String Key, List<String> list)
#### 3. getPref(String key)
#### 3. getKeys()
#### 3. remove(String key)


### StreamedObjects
#### - Added the `onChange` method. It calls a function every time the stream updates.
#### - More details in the debugMode. 

### - Code refactoring


## Version 0.3.0 (24-02-19)

#### - StreamedList and StreamedMap classes
##### *Breaking change*: 
StreamedList and StreamedMap by default aren't initialiazed (to avoid that when using them along with a StreamBuilder/StreamedWidget the `snaphost.hasData` is true from the beginning,becoming harder to show for example a loading spinner without using a workaround). 

#### - "initialData" parameter
- Added `initialData` parameter to the constructor to all the streamed classes to initialize the stream with an initial data.

#### - Code refactoring

## Version 0.2.0 (22-02-19)

#### - StreamedList class

##### Methods added:

- replaceAt
- replace


## Version 0.1.3 (11-02-19)

#### - Changed console messages behavior and added `debugMode` method.

By default, the debug console messages on disposing of streams are now disabled. Use this method to reenable this behavior.

e.g. from the "StreamedObjects" example:

```dart
    // Activate the debug console messages on disposing
    count.debugMode();
    countMemory.debugMode();
    countHistory.debugMode();
    timerObject.debugMode();
    counterObj.debugMode();
```

This will be applied to:

- StreamedValue
- StreamedTransformed
- MemoryObject
- HistoryObject
- StreamedList
- StreamedMap

## Version 0.1.2 (10-02-19)

#### AnimatedObject

##### - Added getter and setter for the value of the AnimatedObject:

Intead of animateObject.animation.value, now the current value of the animation it is accessible just by using the 'value' setter/getter:

```dart
animatedObject.value += 0.1;
// It is the same as animatedObject.animation.value += 0.1
```

#### AnimatedObject example updated

##### - Added multiple rotations

#### Blur widgets

##### - Code refactoring

## Version 0.1.1 (29-01-19)

#### - Documentation improved

#### - Code refactoring

#### - New widgets:

- BlurWidget
- BlurInWidget
- BlurOutWidget
- AnimatedBlurWidget
- WavesWidget

## Version 0.1.0 (26-01-19)

#### - Released as package

#### - Code refactoring

## Version 0.0.3 (24-01-19)

#### - Added the FadeInWidget

#### - Added the FadeOutWidget

#### - Added the StagedWidget

#### - StagedObject class

##### 1. Added the `onEnd` callback

##### 2. The `widgetsMap` property was renamed to `stagesMap`

## Version 0.0.2

#### - StreamedList class

##### 1. Added a getter for the length of the list

e.g.
streamedList.length

it is the same as:
streamedList.value.length

##### 2. Methods added:

- removeElement
- removeAt
- clear

#### - StreamedMap class

##### 1. Added a getter for the length of the map

e.g.
streamedMap.length

it is the same as:
streamedMap.value.length

##### 2. Methods added:

- AddKey
- removeKey
- clear
