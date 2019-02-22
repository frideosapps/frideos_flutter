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
