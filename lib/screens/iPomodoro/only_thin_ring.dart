import 'package:flutter/material.dart';

class CircleRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, double.infinity),
      painter: CirclePainter(),
    );
  }
}

class CirclePainter extends CustomPainter {
  var wavePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..isAntiAlias = true;
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    canvas.drawCircle(Offset(centerX, centerY), 100.0, wavePaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return false;
  }
}

class OnlyThinRing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter: CircleCountdownPainter(),
      ),
    );
  }
}

class CircleCountdownPainter extends CustomPainter {
  Paint circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide * 0.45);

    // Draw the thin ring
    canvas.drawCircle(
      center,
      radius,
      circlePaint..color = Colors.grey[200].withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(CircleCountdownPainter oldDelegate) {
    return false;
  }
}
