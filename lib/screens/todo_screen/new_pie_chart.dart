import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:provider/provider.dart';

class NewPieChart extends StatelessWidget {
  NewPieChart({
    @required this.dataMap,
  });

  final Map<String, double> dataMap;

  final List<Color> colorList = [
    Color(0xFF58b4ae).withOpacity(0.8),
    Color(0xFFffe277).withOpacity(0.8),
    Color(0xFFffb367).withOpacity(0.8),
    Color(0xFFffe2bc).withOpacity(0.8),
    Color(0xFF7fdbda).withOpacity(0.8),
    Color(0xFFade498).withOpacity(0.8),
    Color(0xFFede682).withOpacity(0.8),
    Color(0xFFfebf63).withOpacity(0.8),
    Color(0xFF086972).withOpacity(0.8),
    Color(0xFF01a9b4).withOpacity(0.8),
    Color(0xFF87dfd6).withOpacity(0.8),
    Color(0xFFfbfd8a).withOpacity(0.8),
    Color(0xFF8bcdcd).withOpacity(0.8),
    Color(0xFFe5edb7).withOpacity(0.8),
    Color(0xFFf1c5c5).withOpacity(0.8),
    Colors.blue[300].withOpacity(0.8),
    Colors.blue[200].withOpacity(0.8),
    Colors.blue[100].withOpacity(0.8),
    Colors.blue[50].withOpacity(0.8),
  ];

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return dataMap != null && dataMap.isNotEmpty
        ? Container(
            padding: const EdgeInsets.only(
                top: 15.0, left: 15, right: 15, bottom: 80),
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
                  color:
                      _darkTheme ? Colors.white.withOpacity(0.9) : lightButton),
              legendStyle: defaultLegendStyle.copyWith(
                  color:
                      _darkTheme ? Colors.white.withOpacity(0.9) : lightButton),
              chartType: ChartType.ring,
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.width / 0.5,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'You have not done any focused task on this day.',
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
            ));
  }
}
