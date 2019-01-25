import '../../blocs/bloc.dart';

import 'multiple_selection_page_one_bloc.dart';
import 'multiple_selection_page_two_bloc.dart';
import 'multiple_selection_page_three_bloc.dart';

class MultipleSelectionBloc extends BlocBase {
  final blocA = PageOneBloc();
  final blocB = PageTwoBloc();
  final blocC = PageThreeBloc();

  MultipleSelectionBloc() {
    print('-------TUNNEL BLOC--------');

    // Senders from blocOne to blocTwo
    blocA.tunnelSenderSelectedItemsTwo
        .setReceiver(blocB.tunnelReceiverSelectedItems);

    // Senders from blocOne to blocThree
    blocA.tunnelSenderSelectedItemsThree
        .setReceiver(blocC.tunnelReceiverSelectedItems);

    // From blocTwo and Three to blocOne
    blocB.tunnelSenderMessage.setReceiver(blocA.tunnelReceiverMessage);
    blocC.tunnelSenderMessage.setReceiver(blocA.tunnelReceiverMessage);
  }

  @override
  dispose() {
    print('-------TUNNEL BLOC DISPOSE--------');

    blocA.dispose();
    blocB.dispose();
    blocC.dispose();
  }
}
