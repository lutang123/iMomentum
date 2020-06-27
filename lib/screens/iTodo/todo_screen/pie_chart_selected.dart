import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:iMomentum/screens/entries/daily_todos_details.dart';

class MyPieChartSelected extends StatelessWidget {
  const MyPieChartSelected({
    Key key,
    @required List<charts.Series<TodoDetails, String>> seriesPieDataSelected,
  })  : _seriesPieDataSelected = seriesPieDataSelected,
        super(key: key);

  final List<charts.Series<TodoDetails, String>> _seriesPieDataSelected;

  @override
  Widget build(BuildContext context) {
    return _seriesPieDataSelected != null
        ? charts.PieChart(_seriesPieDataSelected,
            animate: true,
            animationDuration: Duration(seconds: 1),
            behaviors: [
              charts.DatumLegend(
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 2,
                cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.blue.shadeDefault,
                    fontFamily: 'Georgia',
                    fontSize: 11),
              )
            ],
            defaultRenderer: charts.ArcRendererConfig(
                arcWidth: 60,
                arcRendererDecorators: [
                  charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.auto)
                ]))
        : Container();
  }
}

//
//  var piedata = [
//    new Task('Work', 35.8),
//    new Task('Eat', 8.3),
//    new Task('Commute', 10.8),
//    new Task('TV', 15.6),
//    new Task('Sleep', 19.2),
//  ];

class Task {
  String task;
  double taskvalue;
//  Color colorval;

  Task(this.task, this.taskvalue);
}
