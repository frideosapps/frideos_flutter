import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/bloc.dart';
import '../blocs/streamed_list_bloc.dart';

const styleHeader =
    TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500);
const styleValue = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);
const styleOldValue =
    TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.w500);
const padding = 22.0;
const buttonColor = Color(0xff99cef9);

class StreamedListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('StreamedList'),
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
        Text('StreamedList', style: styleHeader),
        StreamBuilder<String>(
            initialData: ' ',
            stream: bloc.streamedText.outTransformed,
            builder: (context, AsyncSnapshot<String> snapshot) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Text:',
                        hintText: 'Insert a text...',
                        errorText: snapshot.error,
                      ),
                      // To avoid the user could insert text use the TextInputType.number
                      // Here is commented to show the error msg.
                      //keyboardType: TextInputType.number,
                      onChanged: bloc.streamedText.inStream,
                    ),
                  ),
                  RaisedButton(
                    color: buttonColor,
                    child: Text('Add text'),
                    onPressed: snapshot.hasData ? bloc.addText : null,
                  ),
                ],
              );
            }),
        Container(height: 20.0),
        Expanded(
          child: StreamedWidget<List<String>>(
            initialData: bloc.streamedList.value,
            stream: bloc.streamedList.outStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => Center(
                      child: Text('Value $index: ${snapshot.data[index]}',
                          style: styleValue)));
            },
            noDataChild: Text('NO DATA'),
          ),
        ),
      ],
    );
  }
}
