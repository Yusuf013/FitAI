import 'package:flutter/material.dart';

class AccuracyProgressList extends StatelessWidget {
  final Map<String, dynamic> accuracy;

  const AccuracyProgressList({super.key, required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: accuracy.entries.map((entry) {
        final name = entry.key;
        final value = entry.value.toDouble();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name.replaceAll("_", " "),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              Expanded(
                child: Container(
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3C4A45),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: value,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF9DBF9B),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "${(value * 100).toInt()}%",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
