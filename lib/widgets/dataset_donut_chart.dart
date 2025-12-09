import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DatasetDonutChart extends StatelessWidget {
  final Map<String, dynamic> values;

  const DatasetDonutChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFCBE7B9),
      const Color(0xFF8FBF8E),
      const Color(0xFF5C8A60),
      const Color(0xFF446B4C),
      const Color(0xFF7AA785),
      const Color(0xFF2C4637),
    ];

    final entries = values.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titel + bullet
        Row(
          children: const [
            Icon(Icons.circle, size: 10, color: Color(0xFFC7E8A9)),
            SizedBox(width: 8),
            Text(
              "Datasetverdeling",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== LINKER KOLOM MET LABELS =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          "${e.key.replaceAll('_', ' ')}:",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          e.value.toString(),
                          style: const TextStyle(
                            color: Color(0xFFC7E8A9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // ===== DONUT CHART =====
            SizedBox(
              width: 170,
              height: 170,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 45,
                  sections: [
                    for (int i = 0; i < entries.length; i++)
                      PieChartSectionData(
                        value: entries[i].value.toDouble(),
                        color: colors[i % colors.length],
                        radius: 55, // VISUEEL GROOT, zoals screenshot
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
