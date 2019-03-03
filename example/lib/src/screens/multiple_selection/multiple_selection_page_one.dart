import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../../blocs/multiple_selection/multiple_selection_page_one_bloc.dart';

class MultipleSelectionPageOne extends StatelessWidget {
  MultipleSelectionPageOne({this.bloc});

  final PageOneBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page One'),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text('Send to page two'),
                  onPressed: () {
                    bloc.sendPageTwo();
                  }),
              RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text('Send to page three'),
                  onPressed: () {
                    bloc.sendPageThree();
                  }),
              ValueBuilder<String>(
                stream: bloc.tunnelReceiverMessage,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Status:'),
                        Container(width: 6.0),
                        Text(snapshot.data,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500))
                      ]);
                },
                noDataChild: Text('NO MESSAGES FROM PAGE TWO'),
              ),
              Container(
                height: 20.0,
              ),
              Expanded(
                child: ValueBuilder(                  
                  stream: bloc.selectedCollection,
                  builder: (c, s) {
                    return GridView.builder(
                        itemCount: bloc.mockItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          var item = bloc.mockItems[index];
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ValueBuilder<double>(
                                stream:
                                    bloc.borderAnimation.animation,
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> snapshot) {
                                  return Opacity(
                                    //opacity: snapshot.data,
                                    opacity: bloc.getItemOpacity(index),
                                    child: Container(
                                      height: 166.0,
                                      width: 166.0,
                                      decoration: BoxDecoration(
                                        //color: Colors.indigo[300],
                                        color: item.color,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Center(
                                child: Container(
                                  height: 158.0,
                                  width: 158.0,
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                          color: Colors.transparent,
                                          width: 2.0)),
                                  child: InkWell(
                                    child: Column(
                                      children: <Widget>[
                                        Text(item.name),
                                        //  Text('${bloc.opacityList.length}, ${bloc.selectedCollection.value.length}'),
                                        Container(
                                            height: 80.0,
                                            width: 80.0,
                                            color: item.color),
                                        Expanded(child: Text(item.description)),
                                      ],
                                    ),
                                    onTap: () {
                                      bloc.selectItem(index);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                ),
              ),         
            ],
          ),
        ),
      ),
    );
  }
}
