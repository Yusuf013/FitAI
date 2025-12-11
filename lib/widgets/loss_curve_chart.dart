import 'package:flutter/material.dart';

class LossCurveAnimated extends StatefulWidget {
  final List<dynamic> values;

  const LossCurveAnimated({super.key, required this.values});

  @override
  State<LossCurveAnimated> createState() => _LossCurveAnimatedState();
}

class _LossCurveAnimatedState extends State<LossCurveAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _t;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _t = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic, // smooth animatie
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cleaned = widget.values.map((v) => (v as num).toDouble()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.circle, size: 12, color: Color(0xFFC7E8A9)),
            SizedBox(width: 8),
            Text(
              "Verlies curve",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 260,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _t,
            builder: (_, __) {
              return CustomPaint(
                painter: _LossPainter(values: cleaned, progress: _t.value),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Deze lijn laat zien hoe de AI steeds minder fouten maakt "
            "tijdens het trainen. Hoe lager de lijn, hoe beter de AI jouw "
            "oefeningen leert herkennen.",
            style: TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _LossPainter extends CustomPainter {
  final List<double> values;
  final double progress;

  _LossPainter({required this.values, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // === volledig gecentreerde assen ===
    const horizontalMargin = 40.0;
    const topMargin = 20.0;
    const bottomMargin = 40.0;

    final usableWidth = size.width - (horizontalMargin * 2);
    final usableHeight = size.height - topMargin - bottomMargin;

    final axisPaint = Paint()
      ..color = const Color(0xFFC7E8A9)
      ..strokeWidth = 2;

    final linePaint = Paint()
      ..color = const Color(0xFFC7E8A9)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // === Assen tekenen (mooi gecentreerd) ===
    final leftX = horizontalMargin;
    final rightX = size.width - horizontalMargin;
    final bottomY = size.height - bottomMargin;
    final topY = topMargin;

    canvas.drawLine(Offset(leftX, topY), Offset(leftX, bottomY), axisPaint);
    canvas.drawLine(Offset(leftX, bottomY), Offset(rightX, bottomY), axisPaint);

    // === Schaalberekening ===
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;

    Path path = Path();

    // hoeveel punten tekenen
    final lastIndex = (progress * (values.length - 1)).floor();

    for (int i = 0; i <= lastIndex; i++) {
      final t = i / (values.length - 1);

      final x = leftX + (t * usableWidth);

      final normalized = (values[i] - minY) / range;
      final y = bottomY - (normalized * usableHeight);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
