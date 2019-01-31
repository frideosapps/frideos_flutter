import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/streamed_values_bloc.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage(this.bloc);

  final StreamedValuesBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History page'),
      ),
      body: Container(
        child: StreamedWidget<List<int>>(
          initialData: bloc.countHistory.history,
          stream: bloc.countHistory.historyStream,
          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) =>
              ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text('Item ${index + 1}:'),
                      title: Text(
                        '${snapshot.data[index]}',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      dense: true,
                    );
                  }),
          noDataChild: Text('NO DATA'),
        ),
      ),
    );
  }
}
