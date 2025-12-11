import 'package:flutter/material.dart';
import 'dart:ui';

class LossCurveAnimated extends StatefulWidget {
  final List<dynamic> values;

  const LossCurveAnimated({super.key, required this.values});

  @override
  State<LossCurveAnimated> createState() => _LossCurveAnimatedState();
}

class _LossCurveAnimatedState extends State<LossCurveAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double? hoverX;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateHover(Offset pos, Size size) {
    const left = 50.0;
    final right = size.width - 40.0;

    if (pos.dx >= left && pos.dx <= right) {
      setState(() => hoverX = pos.dx);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cleaned = widget.values.map((v) => (v as num).toDouble()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
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

        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanUpdate: (details) => _updateHover(
            details.localPosition,
            (context.findRenderObject() as RenderBox).size,
          ),
          onPanEnd: (_) => setState(() => hoverX = null),

          child: SizedBox(
            height: 320,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return CustomPaint(
                  painter: _LossPainter(
                    values: cleaned,
                    progress: _controller.value,
                    hoverX: hoverX,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 8),
        const Text(
          "Beweeg over de grafiek om te zien hoeveel verlies de AI had per epoch.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

// =========================================================
// ---------------------- PAINTER --------------------------
// =========================================================

class _LossPainter extends CustomPainter {
  final List<double> values;
  final double progress;
  final double? hoverX;

  _LossPainter({
    required this.values,
    required this.progress,
    required this.hoverX,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Colors
    const axisColor = Color(0xFFE0F2D8);
    const lineColor = Color(0xFFC7E8A9);

    // Margins
    const left = 50.0;
    const right = 40.0;
    const top = 20.0;
    const bottom = 50.0;

    final usableWidth = size.width - left - right;
    final usableHeight = size.height - top - bottom;

    // Min/max
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;

    // ===== AS-STELSEL =====
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1.8;

    // Y-axis
    canvas.drawLine(
      Offset(left, top),
      Offset(left, size.height - bottom),
      axisPaint,
    );

    // X-axis
    canvas.drawLine(
      Offset(left, size.height - bottom),
      Offset(size.width - right, size.height - bottom),
      axisPaint,
    );

    // =============================
    //   ✔ Y-AS LABELS (LOSS)
    // =============================
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i <= 4; i++) {
      double fraction = i / 4;
      double yValue = maxY - fraction * range;
      double yPos = top + usableHeight * fraction;

      tp.text = TextSpan(
        text: yValue.toStringAsFixed(2),
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      );
      tp.layout();

      tp.paint(canvas, Offset(left - tp.width - 8, yPos - tp.height / 2));
    }

    // =============================
    //   ✔ X-AS LABELS (EPOCH)
    // =============================
    for (int i = 0; i < values.length; i++) {
      double t = i / (values.length - 1);
      double x = left + t * usableWidth;

      final xp = TextPainter(
        text: TextSpan(
          text: "$i",
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      xp.paint(canvas, Offset(x - xp.width / 2, size.height - bottom + 6));
    }

    // ===== LIJN + GLOW + GRADIENT =====
    Path curve = Path();
    Path fill = Path();
    bool started = false;

    int visiblePoints = (progress * (values.length - 1)).floor();

    for (int i = 0; i <= visiblePoints; i++) {
      double t = i / (values.length - 1);
      double x = left + t * usableWidth;

      double norm = (values[i] - minY) / range;
      double y = (size.height - bottom) - norm * usableHeight;

      if (!started) {
        curve.moveTo(x, y);
        fill.moveTo(x, size.height - bottom);
        fill.lineTo(x, y);
        started = true;
      } else {
        curve.lineTo(x, y);
        fill.lineTo(x, y);
      }

      fill.lineTo(x, size.height - bottom);
    }
    fill.close();

    // Glow
    canvas.drawPath(
      curve,
      Paint()
        ..color = lineColor.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Gradient fill
    canvas.drawPath(
      fill,
      Paint()
        ..shader =
            LinearGradient(
              colors: [lineColor.withOpacity(0.35), lineColor.withOpacity(0.0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(
              Rect.fromLTRB(
                left,
                top,
                size.width - right,
                size.height - bottom,
              ),
            ),
    );

    // Stroke line
    canvas.drawPath(
      curve,
      Paint()
        ..color = lineColor
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    // ===== HOVER TOOLTIP =====
    if (hoverX != null) {
      double x = hoverX!.clamp(left, size.width - right);

      double t = ((x - left) / usableWidth).clamp(0, 1);
      int index = (t * (values.length - 1)).round();

      double norm = (values[index] - minY) / range;
      double y = (size.height - bottom) - norm * usableHeight;

      // Dot
      canvas.drawCircle(Offset(x, y), 6, Paint()..color = Colors.white);

      const tooltipWidth = 130.0;
      const tooltipHeight = 50.0;

      double tipX = x + 10;
      double tipY = y - 60;

      if (tipX + tooltipWidth > size.width) tipX -= tooltipWidth + 20;
      if (tipY < 0) tipY = y + 10;

      final rect = RRect.fromLTRBR(
        tipX,
        tipY,
        tipX + tooltipWidth,
        tipY + tooltipHeight,
        const Radius.circular(10),
      );

      // Tooltip background
      canvas.drawRRect(
        rect,
        Paint()
          ..color = const Color(0xFF1C1F1D).withOpacity(0.9)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Tooltip text
      final tooltipText = TextPainter(
        text: TextSpan(
          text: "Epoch $index\nLoss: ${values[index].toStringAsFixed(3)}",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: tooltipWidth - 12);

      tooltipText.paint(canvas, Offset(tipX + 8, tipY + 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
