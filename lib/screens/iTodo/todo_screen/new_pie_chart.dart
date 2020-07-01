import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class NewPieChart extends StatelessWidget {
  NewPieChart({
    @required this.dataMap,
  });

  final Map<String, double> dataMap;

  final List<Color> colorList = [
    Color(0xFFffcb74).withOpacity(0.8),
    Color(0xFFea907a).withOpacity(0.8),
    Color(0xFF4f8a8b).withOpacity(0.8),
    Color(0xFF01a9b4).withOpacity(0.8),
    Color(0xFF87dfd6).withOpacity(0.8),
    Colors.blue[400].withOpacity(0.8),
    Colors.blue[300].withOpacity(0.8),
    Colors.blue[200].withOpacity(0.8),
    Colors.blue[100].withOpacity(0.8),
    Colors.blue[50].withOpacity(0.8),
//    Color(0xFFffcb74).withOpacity(0.8),
//    Color(0xFFfbfd8a).withOpacity(0.8),

//    Colors.blue[900].withOpacity(0.8),
//    Colors.blue[800],
//    Colors.blue[700],
//    Colors.blue[600],
//    Colors.blue[500],
  ];

//  final List<Color> colorList2 = [
//    Color(0xFFffa41b).withOpacity(0.8),
//    Colors.white.withOpacity(0.8),
//    Color(0xFF005082).withOpacity(0.8),
//    Color(0xFF01a9b4).withOpacity(0.8),
//    Color(0xFF87dfd6).withOpacity(0.8),
////    Color(0xFFeaffd0),
////    Color(0xFFc2f0fc),
//  ];

  @override
  Widget build(BuildContext context) {
    return dataMap != null && dataMap.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 2,
              showChartValuesInPercentage: true,
              showChartValues: true,
              showChartValuesOutside: false,
              chartValueBackgroundColor: Colors.transparent,
              colorList: colorList,
              showLegends: true,
              legendPosition: LegendPosition.bottom,
              decimalPlaces: 0,
              showChartValueLabel: true,
              initialAngle: 0,
              chartValueStyle: defaultChartValueStyle.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              chartType: ChartType.ring,
            ),
          )
        : Container(
            child: Text('You have not completed any Pomodoro task'),
          );
  }
}
