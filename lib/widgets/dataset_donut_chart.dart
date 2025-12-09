import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DatasetDonutChart extends StatelessWidget {
  final Map<String, dynamic> values;

  const DatasetDonutChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF9DBF9B),
      const Color(0xFF6E8F72),
      const Color(0xFF3D5A47),
      const Color(0xFF4F6D5A),
      const Color(0xFF7EA48D),
      const Color(0xFF1C3128),
    ];

    int i = 0;

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 40,
          sections: values.entries.map((e) {
            return PieChartSectionData(
              value: e.value.toDouble(),
              color: colors[i++ % colors.length],
              radius: 45,
            );
          }).toList(),
        ),
      ),
    );
  }
}
