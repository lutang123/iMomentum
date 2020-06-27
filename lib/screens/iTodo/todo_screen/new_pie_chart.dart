import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class NewPieChart extends StatelessWidget {
  NewPieChart({
    @required this.dataMap,
  });

  final Map<String, double> dataMap;

  final List<Color> colorList = [
    Color(0xFFffa41b).withOpacity(0.8),
    Colors.white.withOpacity(0.8),
//    Color(0xFF005082),
//    Color(0xFF00a8cc),
    Color(0xFF005082).withOpacity(0.8),
    Color(0xFF01a9b4).withOpacity(0.8),
    Color(0xFF87dfd6).withOpacity(0.8),
//    Color(0xFFeaffd0),
//    Color(0xFFc2f0fc),
    Color(0xFFfbfd8a).withOpacity(0.8),
  ];

  @override
  Widget build(BuildContext context) {
    return dataMap != null
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
        : Container();
  }
}
