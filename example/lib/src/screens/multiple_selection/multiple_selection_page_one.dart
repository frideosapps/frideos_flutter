import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../../blocs/multiple_selection/multiple_selection_page_one_bloc.dart';

class MultipleSelectionPageOne extends StatelessWidget {
  const MultipleSelectionPageOne({this.bloc});

  final PageOneBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page One'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: const Text('Send to page two'),
                  onPressed: bloc.sendPageTwo),
              RaisedButton(
                color: Colors.lightBlueAccent,
                child: const Text('Send to page three'),
                onPressed: bloc.sendPageThree,
              ),
              ValueBuilder<String>(
                stream: bloc.tunnelReceiverMessage,
                builder: (context, snapshot) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Status:'),
                        Container(width: 6),
                        Text(snapshot.data,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500))
                      ]);
                },
                noDataChild: const Text('NO MESSAGES FROM PAGE TWO'),
              ),
              Container(
                height: 20,
              ),
              Expanded(
                child: ValueBuilder(
                  stream: bloc.selectedCollection,
                  builder: (c, s) {
                    return GridView.builder(
                        itemCount: bloc.mockItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          final item = bloc.mockItems[index];
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ValueBuilder<double>(
                                stream: bloc.borderAnimation.animation,
                                builder: (context, snapshot) {
                                  return Opacity(
                                    opacity: bloc.getItemOpacity(index),
                                    child: Container(
                                      height: 166,
                                      width: 166,
                                      decoration: BoxDecoration(
                                        color: item.color,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Center(
                                child: Container(
                                  height: 158,
                                  width: 158,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.transparent, width: 2)),
                                  child: InkWell(
                                    child: Column(
                                      children: <Widget>[
                                        Text(item.name),
                                        Container(
                                            height: 80,
                                            width: 80,
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
