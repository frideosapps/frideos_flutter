import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/bloc.dart';
import '../blocs/streamed_list_bloc.dart';

const TextStyle styleHeader =
    TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500);
const TextStyle styleValue =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
const TextStyle styleOldValue =
    TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500);
const double padding = 22;
const Color buttonColor = Color(0xff99cef9);

class StreamedListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('StreamedList'),
        ),
        body: StreamedListWidget(),
      ),
    );
  }
}

class StreamedListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StreamedListBloc bloc = BlocProvider.of(context);

    return Column(
      children: <Widget>[
        Container(
          height: 16.0,
        ),
        const Text('StreamedList', style: styleHeader),
        StreamBuilder<String>(
            initialData: ' ',
            stream: bloc.streamedText.outTransformed,
            builder: (context, snapshot) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Text:',
                        hintText: 'Insert a text...',
                        errorText: snapshot.error,
                      ),
                      // To avoid the user could insert text use the
                      // TextInputType.number. Here is commented to
                      // show the error msg.
                      // keyboardType: TextInputType.number,
                      onChanged: bloc.streamedText.inStream,
                    ),
                  ),
                  RaisedButton(
                    color: buttonColor,
                    child: const Text('Add text'),
                    onPressed: snapshot.hasData ? bloc.addText : null,
                  ),
                ],
              );
            }),
        Container(height: 20),
        Expanded(
          child: ValueBuilder<List<String>>(
            stream: bloc.streamedList,
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => Center(
                      child: Text('Value $index: ${snapshot.data[index]}',
                          style: styleValue)));
            },
            noDataChild: const Text('NO DATA'),
          ),
        ),
      ],
    );
  }
}
