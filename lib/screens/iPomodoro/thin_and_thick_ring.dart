//import 'dart:math';
//
//import 'package:flutter/material.dart';
//import 'package:iMomentum/app/constants/theme.dart';
//
//import 'package:tinycolor/tinycolor.dart';
//import 'dart:math' as math;
//
////class AnotherCountdownCircle extends StatefulWidget {
////  AnotherCountdownCircle({this.duration});
////  final Duration duration;
////
////  @override
////  _AnotherCountdownCircleState createState() => _AnotherCountdownCircleState();
////}
////
////class _AnotherCountdownCircleState extends State<AnotherCountdownCircle>
////    with SingleTickerProviderStateMixin {
////  AnimationController _controller;
////
////  @override
////  void initState() {
////    super.initState();
////    _controller = AnimationController(
////      duration: widget.duration,
////      vsync: this,
////    );
////    _controller.forward().orCancel;
////  }
////
////  @override
////  void didUpdateWidget(AnotherCountdownCircle oldWidget) {
////    _controller.reset();
////    _controller.forward();
////    super.didUpdateWidget(oldWidget);
////  }
////
////  @override
////  void dispose() {
////    _controller.dispose();
////    super.dispose();
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    return AspectRatio(
////      aspectRatio: 1.0,
////      child: CustomPaint(
////        painter: MyCircleCountdownPainter(
////          thinRing: Colors.grey[200].withOpacity(0.5),
////          thickRing: Colors.white,
////          animation: Tween<double>(begin: 0.0, end: pi * 2).animate(
////              CurvedAnimation(parent: _controller, curve: Curves.linear)),
////        ),
////      ),
////    );
////  }
////}
//
//class ThinAndThickRing extends CustomPainter {
//  ThinAndThickRing({this.animation, this.thinRing, this.thickRing})
//      : super(repaint: animation);
//  final Animation<double> animation;
//
//  // The color of the thinRing
//
//  // The color of the ticking circle
//  final Color thinRing;
//  final Color thickRing;
//
//  Paint circlePaint = Paint()
//    ..color = Colors.grey[300]
//    ..strokeWidth = 4.0
//    ..style = PaintingStyle.stroke
//    ..strokeCap = StrokeCap.round;
//
//  Paint fillerPaint = Paint()
//    ..strokeWidth = 15
//    ..style = PaintingStyle.stroke
//    ..strokeCap = StrokeCap.round;
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    final center = size.center(Offset.zero);
//    final radius = (size.shortestSide * 0.45);
//    final rect = Rect.fromCircle(center: center, radius: radius);
//    // Draw the thin ring
//    canvas.drawCircle(
//      center, //Offset c
//      radius, //Double radius
//      circlePaint..color = thinRing, //Paint paint
//    );
//
//    final Gradient gradient = LinearGradient(
//      begin: Alignment.topCenter,
//      end: Alignment.bottomCenter,
//      colors: <Color>[
//        TinyColor(thickRing).lighten(8).color,
//        thickRing,
//        TinyColor(thickRing).darken(5).color,
//      ],
//      stops: [0.0, 0.5, 1.0],
//    );
//
//    /// Draw the countdown circle based on [animation.value]
////    canvas.save();
////    double progress = (1.0 - animation.value) * 2 * math.pi;
//    canvas.drawArc(
//      rect, //Rect rect,
//      math.pi * 1.5, //double startAngle,
////      0,
////      progress, //double sweepAngle,
//      animation.value,
//      false, //bool useCenter,
//      fillerPaint..shader = gradient.createShader(rect), //Paint paint
//    );
//  }
//
//  @override
//  bool shouldRepaint(ThinAndThickRing oldDelegate) {
//    return animation != oldDelegate.animation;
//  }
//}
//
//class CustomTimerPainter extends CustomPainter {
//  CustomTimerPainter({
//    this.animation,
//    this.backgroundColor,
//    this.color,
//  }) : super(repaint: animation);
//
//  final Animation<double> animation;
//  final Color color, backgroundColor;
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    final center = size.center(Offset.zero);
//    final radius = (size.shortestSide * 0.45);
//    final rect = Rect.fromCircle(center: center, radius: radius);
//
//    Paint paint = Paint()
//      ..color = color
//      ..strokeWidth = 5.0
//      ..strokeCap = StrokeCap.butt
//      ..style = PaintingStyle.stroke;
//
//    Paint fillerPaint = Paint()
//      ..color = backgroundColor
//      ..strokeWidth = 15.0
//      ..strokeCap = StrokeCap.butt
//      ..style = PaintingStyle.stroke;
//
//    canvas.drawCircle(size.center(Offset.zero), radius, paint);
//    paint.color = color;
//    double progress = (1.0 - animation.value) * 2 * math.pi;
//    canvas.drawArc(rect, 0, -progress, false, fillerPaint);
//  }
//
//  @override
//  bool shouldRepaint(CustomTimerPainter old) {
//    return animation.value != old.animation.value || color != old.color;
//
////     ||   backgroundColor != old.backgroundColor;
//  }
//}
