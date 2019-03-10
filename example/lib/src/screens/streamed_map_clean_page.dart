import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/bloc.dart';
import '../blocs/streamed_map_clean_bloc.dart';

const styleHeader =
    TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500);
const styleValue = TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500);
const styleOldValue =
    TextStyle(color: Colors.grey, fontSize: 12.0, fontWeight: FontWeight.w500);
const padding = 22.0;
const buttonColor = Color(0xff99cef9);

class StreamedMapCleanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('StreamedMap'),
        ),
        body: StreamedMapCleanWidget(),
      ),
    );
  }
}

class StreamedMapCleanWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StreamedMapCleanBloc bloc = BlocProvider.of(context);

    return Column(
      children: <Widget>[
        Container(
          height: 16.0,
        ),
        Text('StreamedMap', style: styleHeader),
        StreamBuilder<String>(
            stream: bloc.outTextTransformed,
            builder: (context, snapshot) {
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
                      onChanged: bloc.inText,
                    ),
                  ),
                ],
              );
            }),
        StreamBuilder<int>(
            stream: bloc.outKeyTransformed,
            builder: (context, snapshot) {
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
                        labelText: 'Key:',
                        hintText: 'Insert an integer...',
                        errorText: snapshot.error,
                      ),
                      // To avoid the user could insert text use the TextInputType.number
                      // Here is commented to show the error msg.
                      //keyboardType: TextInputType.number,
                      onChanged: bloc.inKey,
                    ),
                  ),
                ],
              );
            }),
        StreamBuilder<bool>(
            stream: bloc.isFilled,
            builder: (context, snapshot) {
              return RaisedButton(
                color: buttonColor,
                child: Text('Add text'),
                onPressed: snapshot.hasData ? bloc.addText : null,
              );
            }),
        Container(height: 20.0),
        Expanded(
          child: StreamedWidget<Map<int, String>>(
            stream: bloc.outMap,
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var key = snapshot.data.keys.elementAt(index);
                    return Center(
                      child: Text('Key $key: ${snapshot.data[key]}',
                          style: styleValue),
                    );
                  });
            },
            noDataChild: Text('NO DATA'),
          ),
        ),
      ],
    );
  }
}
