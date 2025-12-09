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
      appBar: AppBar(
        backgroundColor: const Color(0xFF141E1B),
        title: const Text("Statistieken"),
        centerTitle: true,
      ),

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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Model Prestaties",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // ===== ACCURACY BAR =====
                if (stats.containsKey("accuracy"))
                  AccuracyProgressList(
                    accuracy: Map<String, dynamic>.from(stats["accuracy"]),
                  ),

                const SizedBox(height: 25),

                // ===== LOSS GRAPH =====
                if (stats.containsKey("loss_curve"))
                  LossCurveChart(
                    values: List<double>.from(stats["loss_curve"]),
                  ),

                const SizedBox(height: 25),

                // ===== image donut =====
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
