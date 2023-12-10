import 'package:flutter/material.dart';

class RotatingImage extends StatelessWidget {
  final AnimationController animationController;
  final String imagePath;
  final double width;
  final double height;
  final Color color;

  const RotatingImage({
    required this.animationController,
    required this.imagePath,
    this.width = 40,
    this.height = 40,
    this.color = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: animationController.value * 2.0 * 3.1415926535897932,
          child: child,
        );
      },
      child: Center(
        child: Image.asset(
          imagePath,
          color: color,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
