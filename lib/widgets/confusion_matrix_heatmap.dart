import 'dart:math';
import 'package:flutter/material.dart';

class ConfusionMatrixHeatmap extends StatefulWidget {
  final List<String> labels;
  final List<List<dynamic>> matrix;

  const ConfusionMatrixHeatmap({
    super.key,
    required this.labels,
    required this.matrix,
  });

  @override
  State<ConfusionMatrixHeatmap> createState() => _ConfusionMatrixHeatmapState();
}

class _ConfusionMatrixHeatmapState extends State<ConfusionMatrixHeatmap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  String _formatLabel(String key) {
    return key
        .replaceAll("_", " ")
        .replaceAll("cable fly", "Cable flyes")
        .replaceAll("incline benchpress", "Bench press")
        .replaceAll("machine pulldown", "Pulldown")
        .replaceAll("romanian deadlift", "Deadlift");
  }

  /// Afkortingen (zorgt dat alles binnen de randen past).
  String _abbrFromFormatted(String formattedName) {
    final k = formattedName.toLowerCase();

    if (k.contains("cable") || k.contains("fly")) return "CF";
    if (k.contains("bench")) return "BP";
    if (k.contains("pulldown")) return "PD";
    if (k.contains("pullup")) return "PU";
    if (k.contains("deadlift")) return "DL";
    if (k.contains("squat")) return "SQ";

    // fallback: eerste letters van woorden (max 3 chars)
    final cleaned = formattedName.trim();
    final parts = cleaned
        .split(RegExp(r"\s+"))
        .where((p) => p.isNotEmpty)
        .toList();
    final initials = parts.map((p) => p[0].toUpperCase()).join();
    return initials.length > 3 ? initials.substring(0, 3) : initials;
  }

  /// Chip voor legenda (zelfde vibe als jouw metric chips)
  Widget _legendChip({required String abbr, required String full}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2521),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF3C4A45), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1815),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFC7E8A9), width: 1),
            ),
            child: Text(
              abbr,
              style: const TextStyle(
                color: Color(0xFFC7E8A9),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            full,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
    // Matrix values naar int
    final values = widget.matrix
        .map((row) => row.map((v) => (v as num).toInt()).toList())
        .toList();

    // max value voor kleur-intensiteit
    final maxVal = values.fold<int>(
      0,
      (prev, row) => max(prev, row.fold<int>(0, (p, v) => max(p, v))),
    );

    Color cellColor(int v) {
      if (maxVal == 0) return const Color(0xFF1B2521);
      final t = (v / maxVal).clamp(0.0, 1.0);
      return Color.lerp(
        const Color(0xFF1B2521), // donker
        const Color(0xFFB6EB8E), // groen
        t,
      )!;
    }

    // 1) Format volledige namen (voor legenda)
    final fullNames = widget.labels
        .map((e) => _formatLabel(e.toLowerCase()))
        .toList();

    // 2) Afkortingen voor de matrix assen
    final abbrs = fullNames.map(_abbrFromFormatted).toList();

    // 3) Unieke legenda items
    final legend = <Map<String, String>>[];
    final seen = <String>{};
    for (var i = 0; i < fullNames.length; i++) {
      final a = abbrs[i];
      final f = fullNames[i];
      final key = "$a|$f";
      if (!seen.contains(key)) {
        legend.add({"abbr": a, "full": f});
        seen.add(key);
      }
    }

    // Fade-in voor titel/description/legenda (subtiel)
    final headerAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: headerAnim,
      builder: (context, child) {
        return Opacity(
          opacity: headerAnim.value,
          child: Transform.translate(
            offset: Offset(0, (1 - headerAnim.value) * 8),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.circle, size: 10, color: Color(0xFFC7E8A9)),
              SizedBox(width: 8),
              Text(
                "Confusion matrix",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Toont welke oefeningen door elkaar worden gehaald.",
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
          ),
          const SizedBox(height: 14),

          // Matrix (geen horizontale scroll) + cell stagger animatie
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: const Color(0xFF0F1815),
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: _MatrixTable(
                      labels: abbrs,
                      values: values,
                      cellColor: cellColor,
                      maxWidth: constraints.maxWidth,
                      controller: _controller, // <-- animatie doorgeven
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: const [
              Icon(Icons.circle, size: 8, color: Colors.white70),
              SizedBox(width: 8),
              Text(
                "Legenda",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final item in legend)
                _legendChip(abbr: item["abbr"]!, full: item["full"]!),
            ],
          ),
        ],
      ),
    );
  }
}

class _MatrixTable extends StatelessWidget {
  final List<String> labels; // afkortingen
  final List<List<int>> values;
  final Color Function(int) cellColor;
  final double maxWidth;
  final AnimationController controller;

  const _MatrixTable({
    required this.labels,
    required this.values,
    required this.cellColor,
    required this.maxWidth,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final n = labels.length;

    // Smalle y-as kolom dankzij afkortingen
    final labelColumnWidth = 56.0;
    final availableWidth = maxWidth - labelColumnWidth;

    // cell size dynamisch zodat alles past
    final cellSize = (availableWidth / n).clamp(22.0, 44.0);

    // Fonts schalen mee
    final headerFont = (cellSize * 0.30).clamp(9.0, 12.0);
    final rowLabelFont = (cellSize * 0.32).clamp(10.0, 13.0);
    final cellFont = (cellSize * 0.34).clamp(10.0, 14.0);

    Widget headerCell(String text) {
      return SizedBox(
        width: cellSize,
        height: cellSize,
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: headerFont,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
        ),
      );
    }

    Widget rowLabelCell(String text) {
      return SizedBox(
        width: labelColumnWidth,
        height: cellSize,
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: Colors.white70,
              fontSize: rowLabelFont,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
        ),
      );
    }

    Widget matrixCell(int v, bool isDiagonal, int i, int j) {
      final bg = cellColor(v);

      // Consistente tekstkleur op basis van luminance
      final isBgLight = bg.computeLuminance() > 0.55;
      final textColor = isBgLight ? Colors.black : Colors.white;

      // ✅ Stagger: elk vakje krijgt eigen interval
      final total = max(1, n * n);
      final idx = (i * n + j);
      final start = 0.20 + (idx / total) * 0.55; // start na headers
      final end = (start + 0.22).clamp(0.0, 1.0);

      final anim = CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      );

      return AnimatedBuilder(
        animation: anim,
        builder: (context, child) {
          final t = anim.value;
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: (0.92 + 0.08 * t).clamp(0.92, 1.0),
              child: child,
            ),
          );
        },
        child: Container(
          width: cellSize,
          height: cellSize,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: isDiagonal
                ? Border.all(color: const Color(0xFFC7E8A9), width: 1.2)
                : Border.all(color: const Color(0xFF2A3531), width: 1),
          ),
          child: Center(
            child: Text(
              "$v",
              style: TextStyle(
                color: v == 0 ? Colors.white38 : textColor,
                fontSize: cellFont,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
          ),
        ),
      );
    }

    final headerRow = Row(
      children: [
        SizedBox(width: labelColumnWidth, height: cellSize),
        ...labels.map(headerCell),
      ],
    );

    final rows = List.generate(n, (i) {
      return Row(
        children: [
          rowLabelCell(labels[i]),
          ...List.generate(n, (j) {
            final v = values[i][j];
            return matrixCell(v, i == j, i, j);
          }),
        ],
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [headerRow, const SizedBox(height: 6), ...rows],
    );
  }
}
