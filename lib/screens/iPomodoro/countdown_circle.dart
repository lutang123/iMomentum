import 'dart:math';

import 'package:flutter/material.dart';

import 'package:tinycolor/tinycolor.dart';

class CountdownCircle extends StatefulWidget {
  CountdownCircle({this.duration, this.animationController});
  final Duration duration;
  final AnimationController animationController;

  @override
  _CountdownCircleState createState() => _CountdownCircleState();
}

class _CountdownCircleState extends State<CountdownCircle>
    with SingleTickerProviderStateMixin {
  AnimationController get _controller => widget.animationController;

//  @override
//  void initState() {
//    super.initState();
////    _controller = AnimationController(
////      duration: widget.duration,
////      vsync: this,
////    );
////    _controller.forward().orCancel;
//
////    _controller.addListener(() => setState(() {}));
////    TickerFuture tickerFuture = _controller.repeat();
////    tickerFuture.timeout(widget.duration, onTimeout: () {
////      _controller.forward(from: 0);
////      _controller.stop(canceled: true);
////    });
//  }

  @override
  void dispose() {
//    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: CustomPaint(
        painter: CircleCountdownPainter(
          thinRing: Colors.grey[200].withOpacity(0.5),
          tickerRing: Colors.white,
          animation: Tween<double>(begin: 0.0, end: pi * 2).animate(
              CurvedAnimation(parent: _controller, curve: Curves.linear)),
        ),
      ),
    );
  }
}

class CircleCountdownPainter extends CustomPainter {
  CircleCountdownPainter({this.animation, this.thinRing, this.tickerRing})
      : fillerPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12.0
          ..strokeCap = StrokeCap.round,
        super(repaint: animation);

  // The color of the thinRing
  final Color thinRing;

  // The color of the ticking circle
  final Color tickerRing;

  final Animation<double> animation;
  final Paint fillerPaint;

  Paint circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide * 0.47);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw the thin ring
    canvas.drawCircle(
      center,
      radius,
      circlePaint..color = thinRing,
    );

    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        TinyColor(tickerRing).lighten(8).color,
        tickerRing,
        TinyColor(tickerRing).darken(5).color,
      ],
      stops: [0.0, 0.5, 1.0],
    );

    /// Draw the countdown circle based on [animation.value]
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(pi * 3 / 2);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawArc(
      rect,
      0,
      animation.value,
      false,
      fillerPaint..shader = gradient.createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(CircleCountdownPainter oldDelegate) {
    return animation != oldDelegate.animation;
  }
}
