import 'package:flutter/material.dart';

import 'package:frideos/frideos_dart.dart';

import 'package:frideos_general/src/blocs/bloc.dart';
import 'package:frideos_general/src/models/item_model.dart';

class PageTwoBloc extends BlocBase {
  final items = StreamedList<Item>();
  final tunnelReceiverSelectedItems = StreamedList<Item>();

  // SENDERS
  final tunnelSenderMessage = StreamedSender<String>();
  send(int numItems) {
    print('SENDING SELECTED ITEMS');

    tunnelSenderMessage.send('Page two received $numItems item${numItems > 1 ? 's' : ''}');
  }

  PageTwoBloc() {
    print('-------PAGE TWO BLOC--------');

/*
    tunnelReceiverItem.outStream.listen((element) {
      items.addElement(element);
      print(element);
      print('length: ${items.value.length}');
    });

*/
    /// Why this is getting fired only the first time?!?!?!?
    tunnelReceiverSelectedItems.outStream.listen((selectedItems) {
      print('LISTEN SELECTED ITEMS');
      print('length: ${selectedItems.length}');
      items.value.addAll(selectedItems);
      send(selectedItems.length);
      items.refresh();
    });
  }

  dispose() {
    print('-------PAGE TWO BLOC DISPOSE--------');

    tunnelReceiverSelectedItems.dispose();

    items.dispose();
  }
}
