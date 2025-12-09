import 'package:flutter/material.dart';
import 'package:ai_fitness_app/services/stats_service.dart';

// Jouw widgets importeren:
import 'package:ai_fitness_app/widgets/accuracy_progress_list.dart';
import 'package:ai_fitness_app/widgets/loss_curve_chart.dart';
import 'package:ai_fitness_app/widgets/dataset_donut_chart.dart';

class StatistiekenPage extends StatelessWidget {
  const StatistiekenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1412),

      body: FutureBuilder<Map<String, dynamic>>(
        future: StatsService.loadStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final stats = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: const [
                      Text(
                        "FitAI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Statistieken",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "krijg hier meer inzicht hoe accuraat de\n"
                        "gebruikte AI-model is",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 40),

                      // Titel van eerste sectie
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                            color: Color(0xFFC7E8A9),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),

                if (stats.containsKey("accuracy"))
                  AccuracyProgressList(
                    accuracy: Map<String, dynamic>.from(stats["accuracy"]),
                  ),

                const SizedBox(height: 25),

                if (stats.containsKey("loss_curve"))
                  LossCurveChart(
                    values: List<double>.from(stats["loss_curve"]),
                  ),

                const SizedBox(height: 25),

                if (stats.containsKey("dataset_distribution"))
                  DatasetDonutChart(
                    values: Map<String, dynamic>.from(
                      stats["dataset_distribution"],
                    ),
                  ),

                const SizedBox(height: 25),
              ],
            ),
          );
        },
      ),
    );
  }
}
