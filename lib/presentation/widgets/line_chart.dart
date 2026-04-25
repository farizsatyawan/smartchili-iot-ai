import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> data;
  final Color color;

  const LineChartWidget({
    super.key,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    if (data.length < 2) {
      return const Center(child: Text('Menunggu data...'));
    }

    return CustomPaint(
      size: Size.infinite,
      painter: _LineChartPainter(data: data, color: color),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _LineChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final minVal = data.reduce((a, b) => a < b ? a : b);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1.0 : maxVal - minVal;

    final leftPad = 28.0;
    final chartWidth = size.width - leftPad;

    // ================= GRID =================
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.12)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // ================= Y LABEL =================
    for (int i = 0; i <= 4; i++) {
      final value = maxVal - (range * i / 4);
      final y = size.height * i / 4;

      final tp = TextPainter(
        text: TextSpan(
          text: value.toStringAsFixed(0),
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(0, y - 6));
    }

    // ================= COMPUTE POINTS =================
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = leftPad + chartWidth * i / (data.length - 1);

      final normalized = (data[i] - minVal) / range;

      final y = size.height -
          (normalized * size.height * 0.9) -
          size.height * 0.05;

      points.add(Offset(x, y));
    }

    // ================= AREA FILL =================
    final fillPath = _buildSmoothPath(points);
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.lineTo(points.first.dx, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.28), color.withOpacity(0.02)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawPath(fillPath, fillPaint);

    // ================= LINE =================
    final linePath = _buildSmoothPath(points);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // ================= END DOT =================
    final dotBg = Paint()..color = Colors.white;
    final dotFg = Paint()..color = color;

    canvas.drawCircle(points.last, 7, dotBg);
    canvas.drawCircle(points.last, 5, dotFg);

    // ================= LAST VALUE LABEL =================
    final lastVal = data.last.toStringAsFixed(1);

    final tp = TextPainter(
      text: TextSpan(
        text: lastVal,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(points.last.dx - tp.width / 2, points.last.dy - 20),
    );
  }

  Path _buildSmoothPath(List<Offset> points) {
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        (points[i - 1].dx + points[i].dx) / 2,
        points[i].dy,
      );
      path.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        points[i].dx,
        points[i].dy,
      );
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color;
  }
}

// ================= TOGGLE BUTTON =================

class ChartToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const ChartToggleButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withOpacity(0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? activeColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:
                isActive ? activeColor : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}