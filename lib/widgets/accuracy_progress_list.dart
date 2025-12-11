import 'package:flutter/material.dart';

class AccuracyProgressList extends StatefulWidget {
  final Map<String, dynamic> accuracy;

  const AccuracyProgressList({super.key, required this.accuracy});

  @override
  State<AccuracyProgressList> createState() => _AccuracyProgressListState();
}

class _AccuracyProgressListState extends State<AccuracyProgressList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _controller.forward(); // start animatie
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final entries = widget.accuracy.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        ...List.generate(entries.length, (index) {
          final entry = entries[index];
          final label = formatLabel(entry.key.toLowerCase());
          final targetValue = (entry.value as num).toDouble();

          // Unieke delay per bar
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(
              index * 0.1,
              0.5 + index * 0.1,
              curve: Curves.easeOut,
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final animatedValue = targetValue * animation.value;

              return Opacity(
                opacity: animation.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      // Label
                      SizedBox(
                        width: 120,
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Animated progress bar
                      Expanded(
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C4A45),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: animatedValue,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFB6EB8E),
                                    Color(0xFF7F8F85),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Animated percentage
                      Text(
                        "${(animatedValue * 100).toInt()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
