import 'package:flutter/material.dart';

class GlowText extends StatelessWidget {
  const GlowText({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 32,
  });

  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        shadows: [
          Shadow(
            blurRadius: 16,
            color: color,
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
