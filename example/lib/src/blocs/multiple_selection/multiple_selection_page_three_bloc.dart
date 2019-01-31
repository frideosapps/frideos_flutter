import 'package:frideos/frideos_dart.dart';

import '../../blocs/bloc.dart';
import '../../models/item_model.dart';

class PageThreeBloc extends BlocBase {
  final items = StreamedList<Item>();
  final tunnelReceiverSelectedItems = StreamedList<Item>();

  // SENDERS
  final tunnelSenderMessage = StreamedSender<String>();
  send(int numItems) {
    print('SENDING SELECTED ITEMS');

    tunnelSenderMessage.send('Page three received $numItems item${numItems > 1 ? 's' : ''}');
  }

  PageThreeBloc() {
    print('-------PAGE THREE BLOC--------');

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
    print('-------PAGE THREE BLOC DISPOSE--------');

    tunnelReceiverSelectedItems.dispose();

    items.dispose();
  }
}
