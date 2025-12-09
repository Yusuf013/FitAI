import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LossCurveChart extends StatelessWidget {
  final List<dynamic> values;

  const LossCurveChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i].toDouble()),
              ],
              isCurved: true,
              barWidth: 4,
              color: const Color(0xFFB6EB8E),
            ),
          ],
        ),
      ),
    );
  }
}
