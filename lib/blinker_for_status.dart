import 'package:flutter/material.dart';
import 'circle_for_blinker.dart';

class BlinkingPoint extends StatefulWidget {
  final double xCoor;
  final double yCoor;
  final Color pointColor;
  final double pointSize;
  final bool stop;

  const BlinkingPoint({super.key,
    required this.xCoor,
    required this.yCoor,
    required this.pointColor,
    required this.pointSize,
    this.stop = false,
  });

  @override
  BlinkingPointState createState() => BlinkingPointState();
}

class BlinkingPointState extends State<BlinkingPoint>
    with SingleTickerProviderStateMixin {
  late Animation animationSize;
  late AnimationController animationControllerSize;


  @override
  void initState() {
    super.initState();
    animationControllerSize = AnimationController(
      duration: const Duration(milliseconds: 1050),
      vsync: this,
    );

    animationSize = Tween(begin: widget.stop ? widget.pointSize * 4 : 0.0, end: widget.pointSize * 4)
        .animate(animationControllerSize);
    animationSize.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationControllerSize.reset();
      } else if (status == AnimationStatus.dismissed) {
        animationControllerSize.forward();
      }
    });
    animationControllerSize.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LogoAnimation(
      xCoor: widget.xCoor,
      yCoor: widget.yCoor,
      pointColor: widget.pointColor,
      pointSize: widget.pointSize,
      animation: animationSize,
    );
  }

  @override
  void dispose() {
    animationControllerSize.dispose();
    super.dispose();
  }
}

class LogoAnimation extends AnimatedWidget {
  final double xCoor;
  final double yCoor;
  final Color pointColor;
  final double pointSize;


  LogoAnimation({
    Key? key,
    required Animation animation,
    required this.xCoor,
    required this.yCoor,
    required this.pointColor,
    required this.pointSize,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable as Animation;
    return CustomPaint(
      foregroundPainter: Circle(
        xCoor: xCoor,
        yCoor: yCoor,
        color: pointColor,
        pointSize: pointSize,
        blinkRadius: animation.value,
      ),
    );
  }
}

class ColorAnimation extends AnimatedWidget {

  final Widget child;


  const ColorAnimation({
    Key? key,
    required Animation animation,
    required this.child
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable as Animation<double>;
    return FadeTransition(
        opacity: animation,
        child:child);
  }
}