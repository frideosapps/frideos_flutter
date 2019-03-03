# Frideos examples

Example app to show how to use this library: 

* #### Streamed objects 
* #### Streamed collections
* #### TimerObject: a simple stopwatch 
* #### StagedObject
* #### StagedWidget
* #### AnimatedObject
* #### Multiple selection and tunnel pattern (to share data between two blocs)
* #### LinearTransition
* #### CurvedTransition
* #### Sliders
  






### StreamedMap example
This example shows how to use some classes of this library, and a comparison code without it. It is just a page with two textfields to add a key/value pair to a map. The map is then used to drive a ListView.builder showing all the pairs.


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
  }

  final streamedMap = StreamedMap<int, String>();
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
    print('-------Streamed BLOC DISPOSE--------');
    streamedMap.dispose();
    streamedText.dispose();
    streamedKey.dispose();
  }
}
```

As you can see the code is more clean, easier to read and to mantain.





## Screenshots

![StagedWidget](https://i.imgur.com/nCsbJCy.gif)
![StagedObject](https://i.imgur.com/9XLb7JD.gif)
![Blur](https://i.imgur.com/A7XmY5t.gif?s=150)
![LinearTransition](https://i.imgur.com/viGPpCu.gif)
![CurvedTransition](https://i.imgur.com/kxWOKMU.gif)
![AnimatedObject](https://i.imgur.com/10nfh0R.gif)
![MultipleSelection](https://i.imgur.com/nGLRiCY.gif)
![Sliders](https://i.imgur.com/H16VE01.gif)
![Screenshot](screenshots/streamedmap.png?s=150)
![Screenshot](screenshots/streamed.png?s=150)
![Screenshot](screenshots/streamedlist.png?s=150)
