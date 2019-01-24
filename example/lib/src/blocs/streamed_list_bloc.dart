import 'dart:async';

import 'package:frideos/frideos_dart.dart';

import 'package:frideos_general/src/blocs/bloc.dart';

class StreamedListBloc extends BlocBase {
  StreamedListBloc() {
    print('-------StreamedList BLOC--------');

    //Set the validation transformer for the stream
    streamedText.setTransformer(validateText);
  }

  final streamedText = StreamedTransformed<String, String>();
  final streamedList = StreamedList<String>();

  final validateText =
      StreamTransformer<String, String>.fromHandlers(handleData: (str, sink) {
    if (str.isNotEmpty) {
      sink.add(str);
    } else {
      sink.addError('The text must not be empty.');
    }
  });

  // Add to the streamed list the string from the textfield
  addText() {
    streamedList.addElement(streamedText.value);

    // Or, as an alternative:
    // streamedList.value.add(streamedText.value);
    // streamedList.refresh(); // To refresh the stream with the new value
  }

  dispose() {
    print('-------StreamedList BLOC DISPOSE--------');
    streamedText.dispose();
    streamedList.dispose();
  }
}
