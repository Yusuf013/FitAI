import 'package:flutter/material.dart';

class AccuracyProgressList extends StatefulWidget {
  final Map<String, dynamic> accuracy;

  // NEW (optioneel)
  final Map<String, dynamic>? precision;
  final Map<String, dynamic>? recall;
  final Map<String, dynamic>? support;

  const AccuracyProgressList({
    super.key,
    required this.accuracy,
    this.precision,
    this.recall,
    this.support,
  });

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

  double? _getMetric(Map<String, dynamic>? map, String key) {
    if (map == null) return null;
    final v = map[key];
    if (v == null) return null;
    return (v as num).toDouble();
  }

  int? _getSupport(Map<String, dynamic>? map, String key) {
    if (map == null) return null;
    final v = map[key];
    if (v == null) return null;
    return (v as num).round();
  }

  String _fmt2(double? v) {
    if (v == null) return "—";
    return v.toStringAsFixed(2);
  }

  Widget _metricChip({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2521),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF3C4A45), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: const Color(0xFFC7E8A9)),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.accuracy.entries.toList();

    // (optioneel) Sorteer op hoogste accuracy eerst:
    // entries.sort((a, b) => (b.value as num).compareTo(a.value as num));

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

          // Let op: label formatten voor display, maar entry.key gebruiken voor data lookup.
          final label = formatLabel(entry.key.toLowerCase());
          final targetValue = (entry.value as num).toDouble().clamp(0.0, 1.0);

          // Unieke delay per bar
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(
              index * 0.1,
              (0.5 + index * 0.1).clamp(0.0, 1.0),
              curve: Curves.easeOut,
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final animatedValue = (targetValue * animation.value).clamp(
                0.0,
                1.0,
              );

              final p = _getMetric(widget.precision, entry.key);
              final r = _getMetric(widget.recall, entry.key);
              final s = _getSupport(widget.support, entry.key);

              return Opacity(
                opacity: animation.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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

                      // NEW: metric row onder de balk
                      if (widget.precision != null ||
                          widget.recall != null ||
                          widget.support != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 120, top: 6),
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.2,
                            ),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _metricChip(
                                  label: "Precision",
                                  value: _fmt2(p),
                                  icon: Icons.center_focus_strong,
                                ),
                                _metricChip(
                                  label: "Recall",
                                  value: _fmt2(r),
                                  icon: Icons.my_location,
                                ),
                                _metricChip(
                                  label: "Support",
                                  value: s?.toString() ?? "—",
                                  icon: Icons.storage_rounded,
                                ),
                              ],
                            ),
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
