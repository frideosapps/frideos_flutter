import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import 'package:frideos_general/src/blocs/multiple_selection/multiple_selection_page_two_bloc.dart';
import 'package:frideos_general/src/models/item_model.dart';

class MultipleSelectionPageTwo extends StatelessWidget {
  MultipleSelectionPageTwo({this.bloc});

  final PageTwoBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Two'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[  
              Expanded(
                child: StreamedWidget<List<Item>>(
                  stream: bloc.items.outStream,
                  builder: (c, s) {
                    return GridView.builder(
                        itemCount: s.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          var item = s.data[index];
                          return Container(
                            padding: EdgeInsets.all(10.0),
                            child: InkWell(
                              child: Column(
                                children: <Widget>[
                                  Text(item.name),
                                  Container(
                                      height: 100.0,
                                      width: 100.0,
                                      color: item.color),
                                  Expanded(child: Text(item.description)),
                                ],
                              ),
                              onTap: () {
                                //bloc.selectItem(index);
                              },
                            ),
                          );
                        });
                  },
                  noDataChild:
                      Text('items list empty.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
