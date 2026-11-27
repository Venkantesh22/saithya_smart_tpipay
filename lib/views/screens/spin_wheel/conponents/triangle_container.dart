import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  final Color color;
  final bool shadow;

  TrianglePainter({required this.color, this.shadow = true});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Path path = Path();
    path.moveTo(size.width / 2, size.height); // bottom center
    path.lineTo(0, 0); // top left
    path.lineTo(size.width, 0); // top right
    path.close();

    if (shadow) {
      canvas.drawShadow(path, Colors.black45, 4, true);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
