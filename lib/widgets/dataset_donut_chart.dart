import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DatasetDonutChart extends StatefulWidget {
  final Map<String, dynamic> values;

  const DatasetDonutChart({super.key, required this.values});

  @override
  State<DatasetDonutChart> createState() => _DatasetDonutChartState();
}

class _DatasetDonutChartState extends State<DatasetDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<MapEntry<String, dynamic>> entries;

  final List<Color> modernColors = const [
    Color(0xFF90A27D),
    Color(0xFF9EB8A8),
    Color(0xFF405048),
    Color(0xFF119744),
    Color(0xFF1A4E2E),
    Color(0xFF59BF80),
  ];

  @override
  void initState() {
    super.initState();
    entries = widget.values.entries.toList();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = entries.fold<double>(
      0,
      (sum, e) => sum + (e.value as num).toDouble(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, size: 12, color: Color(0xFFC7E8A9)),
            SizedBox(width: 8),
            Text(
              "Datasetverdeling",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final progress = _controller.value;

            return SizedBox(
              width: 240,
              height: 240,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 70,
                  sectionsSpace: 3,
                  sections: [
                    for (int i = 0; i < entries.length; i++)
                      PieChartSectionData(
                        value: (entries[i].value as num).toDouble(),
                        color: modernColors[i],
                        radius: 65 * progress,
                        title:
                            "${((entries[i].value as num) / total * 100).toStringAsFixed(1)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        borderSide: BorderSide(
                          color: modernColors[i].withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 35),

        // 👉 Hier nu één enkele kolom met ALLE oefeningen netjes onder elkaar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildLegendColumn(entries),
        ),
      ],
    );
  }

  Widget _buildLegendColumn(List<MapEntry<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: modernColors[entries.indexOf(item)],
                    boxShadow: [
                      BoxShadow(
                        color: modernColors[entries.indexOf(item)].withValues(
                          alpha: 0.6,
                        ),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    item.key.replaceAll("_", " "),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),

                SizedBox(
                  width: 40,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${item.value}",
                      style: const TextStyle(
                        color: Color(0xFFC7E8A9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
