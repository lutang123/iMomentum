import 'package:flutter/material.dart';

import 'animated_line_chart/animated_line_chart.dart';
import 'animated_line_chart/line_chart.dart';

class TodayLineChart extends StatefulWidget {
  @override
  _TodayLineChartState createState() => _TodayLineChartState();
}

class _TodayLineChartState extends State<TodayLineChart> {
  Map<DateTime, double> createLine2() {
    Map<DateTime, double> data = {};
    data[DateTime.now().subtract(Duration(minutes: 40))] = 13.0;
    data[DateTime.now().subtract(Duration(minutes: 30))] = 24.0;
    data[DateTime.now().subtract(Duration(minutes: 22))] = 39.0;
    data[DateTime.now().subtract(Duration(minutes: 20))] = 29.0;
    data[DateTime.now().subtract(Duration(minutes: 15))] = 27.0;
    data[DateTime.now().subtract(Duration(minutes: 12))] = 9.0;
    data[DateTime.now().subtract(Duration(minutes: 5))] = 35.0;
    print(data);
    return data;
  }

  LineChart chart;
  @override
  void initState() {
    chart = LineChart.fromDateTimeMaps(
        [createLine2()], [Colors.blue], ['Focused Time'],
        tapTextFontWeight: FontWeight.w400);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedLineChart(
          chart,
          key: UniqueKey(),
        ), //Unique key to force animations
      ),
    );
  }
}
