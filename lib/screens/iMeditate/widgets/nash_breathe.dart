import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:iMomentum/screens/iMeditate/utils/utils.dart';
import 'package:tinycolor/tinycolor.dart';

class ZenMode extends StatefulWidget {
  ZenMode({this.duration});
  final Duration duration;
  @override
  _ZenModeState createState() => _ZenModeState();
}

class _ZenModeState extends State<ZenMode> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
//      duration: widget.duration,
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _controller.addListener(() => setState(() {}));
    TickerFuture tickerFuture = _controller.repeat();
    tickerFuture.timeout(widget.duration, onTimeout: () {
      _controller.forward(from: 0);
      _controller.stop(canceled: true);
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 0.75,
        child: CustomPaint(
          painter: BreathePainter(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOutQuart,
              reverseCurve: Curves.easeOutQuart,
            ),
            color: Theme.of(context).accentColor,
            isDarkMode: isDark(context),
          ),
//          size: Size.fromWidth(),
        ),
      ),
    );
  }
}

class BreathePainter extends CustomPainter {
  BreathePainter(
    this.animation, {
    this.isDarkMode,
    this.count = 6,
    this.color,
  })  : circlePaint = Paint()
          ..color = isDarkMode
              ? color
              : TinyColor(color).lighten(15).saturate(28).color
          ..blendMode = isDarkMode ? BlendMode.screen : BlendMode.modulate,
        super(repaint: animation);

  final Animation<double> animation;
  final int count;
  final Paint circlePaint;
  final Color color;
  final bool isDarkMode;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide * 0.25) * animation.value;
    for (int index = 0; index < count; index++) {
      final indexAngle = (index * math.pi / count * 2);
      final angle = indexAngle + (math.pi * 1.5 * animation.value);
      final offset = Offset(math.sin(angle), math.cos(angle)) * radius * 0.985;
      canvas.drawCircle(center + offset * animation.value, radius, circlePaint);
    }
  }

  @override
  bool shouldRepaint(BreathePainter oldDelegate) =>
      animation != oldDelegate.animation;
}
