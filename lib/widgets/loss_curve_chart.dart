import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LossCurveChart extends StatelessWidget {
  final List<dynamic> values;

  const LossCurveChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titel + bullet
        Row(
          children: const [
            Icon(Icons.circle, size: 10, color: Color(0xFFC7E8A9)),
            SizedBox(width: 8),
            Text(
              "Verlies curve",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // As-labels (links & onder)
        SizedBox(
          height: 220,
          child: Stack(
            children: [
              // Y-as label "loss"
              const Positioned(
                left: 0,
                top: 90,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "loss",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),

              // X-as label "Tijd"
              const Positioned(
                bottom: 0,
                left: 130,
                child: Text(
                  "Tijd",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),

              // De grafiek zelf
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 10, top: 10),
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    titlesData: FlTitlesData(show: false),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Color(0xFFC7E8A9), width: 1),
                        bottom: BorderSide(color: Color(0xFFC7E8A9), width: 1),
                        right: BorderSide(width: 0, color: Colors.transparent),
                        top: BorderSide(width: 0, color: Colors.transparent),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < values.length; i++)
                            FlSpot(i.toDouble(), values[i].toDouble()),
                        ],
                        isCurved: true,
                        barWidth: 3,
                        color: const Color(0xFFC7E8A9),
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Uitleg (zoals screenshot)
        const SizedBox(height: 10),
        const Text(
          "Deze lijn laat zien hoe de AI steeds minder fouten maakt\n"
          "tijdens het trainen. Hoe lager de lijn, hoe beter de AI jouw\n"
          "oefeningen leert herkennen.",
          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
        ),
      ],
    );
  }
}
