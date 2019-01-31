

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

##### 1. Added the ```onEnd``` callback
##### 2. The ```widgetsMap``` property was renamed to ```stagesMap```


## Version 0.0.2

#### - StreamedList class

##### 1. Added a getter for the length of the list
   
   e.g. 
   streamedList.length

   it is the same as:
   streamedList.value.length


##### 2. Methods added:
*  removeElement
*  removeAt
*  clear

#### - StreamedMap class

##### 1. Added a getter for the length of the map
   
   e.g. 
   streamedMap.length

   it is the same as:
   streamedMap.value.length

##### 2. Methods added:
*  AddKey
*  removeKey
*  clear