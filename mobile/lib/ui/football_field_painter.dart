import 'package:flutter/material.dart';
import 'dart:math' as math;

// Custom painter to draw football field lines
class FootballFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw center line
    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paint,
    );

    // Draw center circle
    canvas.drawCircle(center, 40, paint);

    // Draw center spot
    canvas.drawCircle(center, 5, paint..style = PaintingStyle.fill);

    // Draw penalty areas
    final penaltyAreaWidth = size.width * 0.4;
    final penaltyAreaDepth = 100.0;

    // Left penalty area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (size.width - penaltyAreaWidth) / 2,
          size.height - penaltyAreaDepth,
          penaltyAreaWidth,
          penaltyAreaDepth,
        ),
        const Radius.circular(8),
      ),
      paint,
    );

    // Right penalty area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (size.width - penaltyAreaWidth) / 2,
          0,
          penaltyAreaWidth,
          penaltyAreaDepth,
        ),
        const Radius.circular(8),
      ),
      paint,
    );

    // Draw goal areas
    final goalAreaWidth = size.width * 0.2;
    final goalAreaHeight = 30.0;

    // Left goal area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (size.width - goalAreaWidth) / 2,
          size.height - goalAreaHeight,
          goalAreaWidth,
          goalAreaHeight,
        ),
        const Radius.circular(4),
      ),
      paint,
    );

    // Right goal area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (size.width - goalAreaWidth) / 2,
          0,
          goalAreaWidth,
          goalAreaHeight,
        ),
        const Radius.circular(4),
      ),
      paint,
    );

    // Draw penalty spots
    canvas.drawCircle(
      Offset(size.width / 2, penaltyAreaDepth + 20),
      4,
      paint..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height - penaltyAreaDepth - 20),
      4,
      paint..style = PaintingStyle.fill,
    );

    // Draw corner arcs
    final cornerRadius = 15.0;
    final cornerPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Top-left corner
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(0, 0), radius: cornerRadius),
      0,
      math.pi / 2,
      false,
      cornerPaint,
    );

    // Top-right corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width, 0), radius: cornerRadius),
      math.pi / 2,
      math.pi / 2,
      false,
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(0, size.height), radius: cornerRadius),
      -math.pi / 2,
      math.pi / 2,
      false,
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width, size.height), radius: cornerRadius),
      math.pi,
      math.pi / 2,
      false,
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
