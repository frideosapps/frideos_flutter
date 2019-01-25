import 'package:frideos/frideos_dart.dart';

import '../../blocs/bloc.dart';
import '../../models/item_model.dart';

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
