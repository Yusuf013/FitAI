import 'package:flutter/material.dart';

class AccuracyProgressList extends StatelessWidget {
  final Map<String, dynamic> accuracy;

  const AccuracyProgressList({super.key, required this.accuracy});

  // Kleine helper om namen netjes te maken
  String formatLabel(String key) {
    return key
        .replaceAll("_", " ")
        .replaceAll("cable fly", "Cable flyes")
        .replaceAll("incline benchpress", "Bench press")
        .replaceAll("machine pulldown", "Pulldown")
        .replaceAll("romanian deadlift", "Deadlift");
  }

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
              "Nauwkeurigheid per oefening",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Lijst met progress bars
        ...accuracy.entries.map((entry) {
          final name = formatLabel(entry.key.toLowerCase());
          final value = (entry.value as num).toDouble();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // Label
                SizedBox(
                  width: 120,
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Progress bar
                Expanded(
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3C4A45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: value,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB6EB8E), Color(0xFF7F8F85)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Percentage
                Text(
                  "${(value * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
