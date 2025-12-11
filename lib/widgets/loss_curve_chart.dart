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
    final left = 50.0;
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
        // Titel
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
          onPanUpdate: (d) => _updateHover(
            d.localPosition,
            (context.findRenderObject() as RenderBox).size,
          ),
          onPanEnd: (_) => setState(() => hoverX = null),

          child: SizedBox(
            height: 300,
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
    // Kleuren
    const axisColor = Color(0xFFE0F2D8);
    const lineColor = Color(0xFFC7E8A9);

    // Marges
    const left = 50.0;
    const right = 40.0;
    const top = 20.0;
    const bottom = 50.0;

    final usableWidth = size.width - left - right;
    final usableHeight = size.height - top - bottom;

    // Min/max loss
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;

    // ===== AS-STELSEL =====
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1.8;

    // Y-as
    canvas.drawLine(
      Offset(left, top),
      Offset(left, size.height - bottom),
      axisPaint,
    );

    // X-as
    canvas.drawLine(
      Offset(left, size.height - bottom),
      Offset(size.width - right, size.height - bottom),
      axisPaint,
    );

    // Kleine subtiele ticks op de Y-as
    for (int i = 0; i <= 4; i++) {
      final y = top + (usableHeight / 4) * i;
      canvas.drawLine(
        Offset(left - 5, y),
        Offset(left, y),
        axisPaint..strokeWidth = 1,
      );
    }

    // ===== LIJN + GLOW + GRADIENT =====
    Path curve = Path();
    Path fill = Path();
    bool started = false;

    int visiblePoints = (progress * (values.length - 1)).floor();

    for (int i = 0; i <= visiblePoints; i++) {
      double t = i / (values.length - 1);
      double x = left + t * usableWidth;

      double normalized = (values[i] - minY) / range;
      double y = (size.height - bottom) - normalized * usableHeight;

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

    // Gradient onder curve
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

    // Lijn zelf
    canvas.drawPath(
      curve,
      Paint()
        ..color = lineColor
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    // ===== HOVER / SLIDE TOOLTIP =====
    if (hoverX != null) {
      double x = hoverX!.clamp(left, size.width - right);

      // Index bepalen
      double t = ((x - left) / usableWidth).clamp(0, 1);
      int index = (t * (values.length - 1)).round();

      double normalized = (values[index] - minY) / range;
      double y = (size.height - bottom) - normalized * usableHeight;

      // Highlight dot
      canvas.drawCircle(Offset(x, y), 6, Paint()..color = Colors.white);

      // Tooltip background
      const tooltipWidth = 130.0;
      const tooltipHeight = 50.0;

      double tipX = x + 10;
      double tipY = y - 60;

      // Zorg dat tooltip niet buiten beeld valt
      if (tipX + tooltipWidth > size.width) tipX -= tooltipWidth + 20;
      if (tipY < 0) tipY = y + 10;

      final tooltipRect = RRect.fromLTRBR(
        tipX,
        tipY,
        tipX + tooltipWidth,
        tipY + tooltipHeight,
        const Radius.circular(10),
      );

      // Tooltip shadow + background
      canvas.drawRRect(
        tooltipRect,
        Paint()
          ..color = const Color(0xFF1C1F1D).withOpacity(0.9)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Tooltip tekst
      final tp = TextPainter(
        text: TextSpan(
          text: "Epoch $index\nLoss: ${values[index].toStringAsFixed(3)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            height: 1.4,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: tooltipWidth - 15);

      tp.paint(canvas, Offset(tipX + 8, tipY + 6));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
