import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iMomentum/app/constants/piechart_color.dart';
import 'package:iMomentum/app/services/multi_notifier.dart';
import 'package:iMomentum/screens/todo_screen/todo_screen_empty_message.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:iMomentum/app/constants/theme.dart';
import 'package:provider/provider.dart';

class NewPieChart extends StatelessWidget {
  NewPieChart({@required this.dataMap, this.textPieChart1, this.textPieChart2});

  final Map<String, double> dataMap;
  final String textPieChart1;
  final String textPieChart2;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool _darkTheme = (themeNotifier.getTheme() == darkTheme);
    if (dataMap != null && dataMap.isNotEmpty) {
      return Padding(
        padding:
            const EdgeInsets.only(bottom: 8.0, left: 15, right: 15, top: 15),
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 1.5,
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
              color: _darkTheme
                  ? Colors.white.withOpacity(0.9)
                  : lightThemeButton),
          legendStyle: defaultLegendStyle.copyWith(
              color: _darkTheme
                  ? Colors.white.withOpacity(0.9)
                  : lightThemeButton),
          chartType: ChartType.ring,
        ),
      );
    } else {
      return TodoScreenEmptyMessage(
        text1: textPieChart1,
        text2: textPieChart2,
      );
    }
  }
}

///we can not add Spacer or Expanded, we will get this error:
//The following assertion was thrown during performLayout():
// RenderFlex children have non-zero flex but incoming height constraints are unbounded.
// When a column is in a parent that does not provide a finite height constraint, for example if it is
// in a vertical scrollable, it will try to shrink-wrap its children along the vertical axis. Setting a
// flex on a child (e.g. using Expanded) indicates that the child is to expand to fill the remaining
// space in the vertical direction.
// These two directives are mutually exclusive. If a parent is to shrink-wrap its child, the child
// cannot simultaneously expand to fit its parent.
// Consider setting mainAxisSize to MainAxisSize.min and using FlexFit.loose fits for the flexible
// children (using Flexible rather than Expanded). This will allow the flexible children to size
// themselves to less than the infinite remaining space they would otherwise be forced to take, and
// then will cause the RenderFlex to shrink-wrap the children rather than expanding to fit the maximum
// constraints provided by the parent.
// Spacer(),
