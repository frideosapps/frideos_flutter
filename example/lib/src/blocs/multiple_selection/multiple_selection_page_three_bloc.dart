import 'package:frideos/frideos_dart.dart';

import '../../blocs/bloc.dart';
import '../../models/item_model.dart';

class PageThreeBloc extends BlocBase {
  final items = StreamedList<Item>(initialData: []);
  final tunnelReceiverSelectedItems = StreamedList<Item>(initialData: []);

  // SENDERS
  final tunnelSenderMessage = StreamedSender<String>();
  send(int numItems) {
    print('SENDING SELECTED ITEMS');

    tunnelSenderMessage.send('Page three received $numItems item${numItems > 1 ? 's' : ''}');
  }

  PageThreeBloc() {
    print('-------PAGE THREE BLOC--------');

    tunnelReceiverSelectedItems.outStream.listen((selectedItems) {      
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
