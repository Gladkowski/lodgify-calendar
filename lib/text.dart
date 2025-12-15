import 'package:flutter/material.dart';
import 'package:mobile_recruitment_test/colors.dart';

enum LTextType { 
  small(12), 
  medium(16);

  const LTextType(this.font);
  final double font;
 }

class LText extends StatelessWidget {
  const LText({
    super.key,
    required this.text,
    required this.type,
    this.color,
    this.fontWeight,
  });

  final String text;
  final LTextType type;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: type.font,
        color: color ?? LColors.shade85,
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    );
  }
}
