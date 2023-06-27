
import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final List<Offset> vertices;

  PolygonPainter({required this.vertices});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (vertices.length > 0) {
      final path = Path();
      path.moveTo(vertices[0].dx, vertices[0].dy);
      for (int i = 1; i < vertices.length; i++) {
        path.lineTo(vertices[i].dx, vertices[i].dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
