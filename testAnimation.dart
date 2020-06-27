import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  AnimatedText({this.text});
  final String text;
  @override
  _AnimatedTextState createState() => new _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation =
        new ColorTween(begin: Colors.red, end: Colors.blue).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _controller.forward();

    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontSize: 40.0, fontWeight: FontWeight.bold, color: _animation.value),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => new _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: AnimatedText(text: "Number $counter")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            ++counter;
          });
        },
      ),
    );
  }
}

void main() {
  runApp(new MaterialApp(home: new MainWidget()));
}
