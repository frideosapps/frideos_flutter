import 'dart:async';

import 'package:frideos/frideos_dart.dart';

import '../../blocs/bloc.dart';
import '../../models/item_model.dart';

const double opacitySpeed = 0.090;

class BorderItem {
  int index;
  double opacity;
  bool opacityForward;

  BorderItem(
    this.index,
    this.opacityForward,
    this.opacity,
  );

  @override
  String toString() {
    return "$index, $opacity";
  }
}

class PageOneBloc extends BlocBase {
  PageOneBloc() {
    print('-------PAGE ONE BLOC--------');    
  }

  final selectedCollection = StreamedList<int>(initialData: []);
  final mockItems = globalMockItems;
  int lastSelectedItem = -1;
  
  final borderAnimation = AnimatedObject<double>(initialValue: 0.0, interval: 20);

  final borderOpacityList = List<BorderItem>();

  ///SELECTION
  ///
  bool checkIfSelected(int index) {
    var selected = selectedCollection.value.contains(index);
    return selected;
  }

  selectItem(int index) {
    var isSelected = checkIfSelected(index);

    if (isSelected) {
      selectedCollection.value.remove(index);
    } else {
      selectedCollection.value.add(index);
    }

    var item = borderOpacityList.firstWhere((item) => item.index == index,
        orElse: () => null);

    // First check if the element is already in the borderOpacityList
    if (item == null) {
      // If the element is selected then the animation will be a fade out
      // otherwise will be fade in
      if (isSelected) {
        var toAdd = BorderItem(index, false, 1);
        borderOpacityList.add(toAdd);
      } else {
        var toAdd = BorderItem(index, true, 0.01);
        borderOpacityList.add(toAdd);
      }
    }

    //Starting animation
    startBorderOpacityAnimation();
  }

  ///SELECTION BOX OPACITY ANIMATION
  ///
  startBorderOpacityAnimation() {
    borderAnimation.start(updateBorderOpacity);
  }

  updateBorderOpacity(Timer t) {
    // Update opacity for every element
    List<int> toDelete = [];

    for (int i = 0; i <= borderOpacityList.length - 1; i++) {
      if (borderOpacityList[i].opacityForward) {
        borderOpacityList[i].opacity += opacitySpeed;
      } else {
        borderOpacityList[i].opacity -= opacitySpeed * 1.5;
      }

      if (borderOpacityList[i].opacity < 0 ||
          borderOpacityList[i].opacity > 1) {        
        toDelete.add(i);
      }
    }

    for (int i = 0; i <= toDelete.length - 1; i++) {
      borderOpacityList.removeAt(i);
    }

    if (borderOpacityList.length == 0) {
      borderAnimation.stop();
    }

    // To send the stream the updated list.
    selectedCollection.refresh();
  }

  getItemOpacity(int index) {
    var item = borderOpacityList.firstWhere((item) => item.index == index,
        orElse: () => null);

    if (item != null) {
      return item.opacity;
    } else {
      // if it was selected the default opacity is 1.0, else is 0
      var isSelected = checkIfSelected(index);
      return isSelected ? 1.0 : 0.0;
    }
  }

  // TUNNEL

  // SENDERS
  final tunnelSenderSelectedItemsTwo = ListSender<Item>();
  final tunnelSenderSelectedItemsThree = ListSender<Item>();
  sendPageTwo() {
    _sendTo(tunnelSenderSelectedItemsTwo);
  }

  sendPageThree() {
    _sendTo(tunnelSenderSelectedItemsThree);
  }

  _sendTo(ListSender sender) {
    print('SENDING SELECTED ITEMS');
    if (selectedCollection.value.length > 0) {
      List<Item> items = [];
      selectedCollection.value.forEach((index) {
        var item = mockItems[index];
        items.add(item);
      });

      sender.send(items);

      selectedCollection.value.clear();
      selectedCollection.refresh();
    }
  }

  // RECEIVERS
  final tunnelReceiverMessage = StreamedValue<String>();

  dispose() {
    print('-------PAGE ONE BLOC DISPOSE--------');
    borderAnimation.dispose();
    selectedCollection.dispose();
  }
}
