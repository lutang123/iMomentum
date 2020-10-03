import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final Function(DateTime) onItemClicked;

  SimpleTimeSeriesChart(this.seriesList, this.onItemClicked);

  List<Transaction> mockTransactions() => [
        Transaction(
            amount: "6",
            type: "RECEIVE",
            date: DateTime.now().subtract(Duration(hours: 4))),
        Transaction(
            amount: "-3",
            type: "SEND",
            date: DateTime.now().subtract(Duration(hours: 3))),
        Transaction(
            amount: "5",
            type: "RECEIVE",
            date: DateTime.now().subtract(Duration(hours: 2))),
        Transaction(amount: "-5", type: "SEND", date: DateTime.now()),
      ];

  //map our current data into a ‘List<charts.Series>’ let’s start by adding a factory method and map our data into our TimeSeriesSimple class we created before

  factory SimpleTimeSeriesChart.withTransactionData(
      List<Transaction> transactions, Function(DateTime) onItemClicked) {
    var runningTotal = 0;

    List<TimeSeriesSimple> mapped = transactions.map((item) {
      runningTotal += int.parse(item.amount);
      return TimeSeriesSimple(time: item.date, sales: runningTotal);
    }).toList();

    // we need to convert this list into a list like this
    List<charts.Series<TimeSeriesSimple, DateTime>> list = [
      charts.Series<TimeSeriesSimple, DateTime>(
        id: 'Balance',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSimple sales, _) => sales.time,
        measureFn: (TimeSeriesSimple sales, _) => sales.sales,
        data: mapped,
      )
    ];

    return SimpleTimeSeriesChart(list, onItemClicked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: charts.TimeSeriesChart(
            seriesList,
            animationDuration: Duration(seconds: 2),
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            animate: true,
            selectionModels: [
              charts.SelectionModelConfig(
                  type: charts.SelectionModelType.info,
                  changedListener: _onSelectionChanged)
            ],
          ),
        ),
      ],
    );
  }

  //model.selectedDataum.first.dataum will basically be of the type of the object your time series is based on. E.g in our case it’s TimeSeriesSimple. So, .time will give us the time. If you use a different object, it’ll be a dynamic type, but basically it’ll be whatever type you make it.
  _onSelectionChanged(charts.SelectionModel<DateTime> model) {
    //You can use this to create a dialog box, or indeed change any other value in the calling widget.
    onItemClicked(model.selectedDatum.first.datum.time);
  }
}

class TimeSeriesSimple {
  final DateTime time;
  final int sales;

  TimeSeriesSimple({this.time, this.sales});
}

class Transaction {
  final DateTime date;
  final String amount;
  final String type;

  Transaction({this.date, this.amount, this.type});
}
