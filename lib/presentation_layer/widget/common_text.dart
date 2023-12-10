import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final double spacing;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomText({
    required this.text,
    this.style = const TextStyle(),
    this.textAlign = TextAlign.left,
    this.spacing = 0.0,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        color: style.color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }
}
