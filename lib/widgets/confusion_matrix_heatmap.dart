import 'dart:math';
import 'package:flutter/material.dart';

class ConfusionMatrixHeatmap extends StatelessWidget {
  final List<String> labels;
  final List<List<dynamic>> matrix;

  const ConfusionMatrixHeatmap({
    super.key,
    required this.labels,
    required this.matrix,
  });

  String _formatLabel(String key) {
    return key
        .replaceAll("_", " ")
        .replaceAll("cable fly", "Cable flyes")
        .replaceAll("incline benchpress", "Bench press")
        .replaceAll("machine pulldown", "Pulldown")
        .replaceAll("romanian deadlift", "Deadlift");
  }

  @override
  Widget build(BuildContext context) {
    // Matrix values naar int
    final values = matrix
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

      // Donker naar groen (past bij jouw theme)
      // (Geen gradient package nodig)
      return Color.lerp(
        const Color(0xFF1B2521), // donker
        const Color(0xFFB6EB8E), // groen
        t,
      )!;
    }

    final displayLabels = labels
        .map((e) => _formatLabel(e.toLowerCase()))
        .toList();

    return Column(
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

        // Scrollbaar (horizontaal + verticaal) voor mobiel
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
                    labels: displayLabels,
                    values: values,
                    cellColor: cellColor,
                    maxWidth: constraints.maxWidth,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MatrixTable extends StatelessWidget {
  final List<String> labels;
  final List<List<int>> values;
  final Color Function(int) cellColor;

  const _MatrixTable({
    required this.labels,
    required this.values,
    required this.cellColor,
  });

  @override
  Widget build(BuildContext context) {
    const cellSize = 44.0; // lekker tappable / leesbaar

    Widget headerCell(String text) {
      return SizedBox(
        width: cellSize,
        height: cellSize,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    Widget rowLabelCell(String text) {
      return SizedBox(
        width: 110, // ruimte voor oefening naam
        height: cellSize,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    Widget matrixCell(int v, bool isDiagonal) {
      final bg = cellColor(v);
      final textColor = v == 0 ? Colors.white38 : Colors.black;

      return Container(
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
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    // Top header row: lege hoek + kolomnamen
    final headerRow = Row(
      children: [
        const SizedBox(width: 110, height: cellSize), // linkerboven hoek leeg
        ...labels.map(headerCell),
      ],
    );

    // Data rows
    final rows = List.generate(labels.length, (i) {
      return Row(
        children: [
          rowLabelCell(labels[i]),
          ...List.generate(labels.length, (j) {
            final v = values[i][j];
            final isDiagonal = i == j;
            return matrixCell(v, isDiagonal);
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
