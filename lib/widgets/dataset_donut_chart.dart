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

  final colors = const [
    Color(0xFFCBE7B9),
    Color(0xFF8FBF8E),
    Color(0xFF5C8A60),
    Color(0xFF446B4C),
    Color(0xFF7AA785),
    Color(0xFF2C4637),
  ];

  @override
  void initState() {
    super.initState();
    entries = widget.values.entries.toList();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
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
        // ⭐ Titel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.circle, size: 12, color: Color(0xFFC7E8A9)),
            SizedBox(width: 8),
            Text(
              "Datasetverdeling",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30), // EXTRA ruimte
        // ⭐ Donut Chart
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final progress = _controller.value;

            return SizedBox(
              width: 220,
              height: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 60,
                  sectionsSpace: 2,
                  sections: [
                    for (int i = 0; i < entries.length; i++)
                      PieChartSectionData(
                        value: (entries[i].value as num).toDouble() * progress,
                        color: colors[i % colors.length],
                        radius: 70,
                      ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 35), // EXTRA ruimte boven labels
        // ⭐ Labels in 2 kolommen (3 links + 3 rechts)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ---------- LINKER KOLUM ----------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 3; i++)
                      _buildLegendItem(
                        color: colors[i],
                        label: entries[i].key.replaceAll("_", " "),
                        count: entries[i].value,
                        percent: ((entries[i].value as num) / total * 100),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // ---------- RECHTER KOLUM ----------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 3; i < 6; i++)
                      _buildLegendItem(
                        color: colors[i],
                        label: entries[i].key.replaceAll("_", " "),
                        count: entries[i].value,
                        percent: ((entries[i].value as num) / total * 100),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ⭐ Component voor 1 label-item
  Widget _buildLegendItem({
    required Color color,
    required String label,
    required int count,
    required double percent,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Bolletje
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),

          // Label
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),

          // Aantal + procent
          Text(
            "$count (${percent.toStringAsFixed(1)}%)",
            style: const TextStyle(
              color: Color(0xFFC7E8A9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
