import 'package:flutter/material.dart';
import 'package:mobile_recruitment_test/ui/colors.dart';

class LodgifyIconButton extends StatelessWidget {
  const LodgifyIconButton({super.key, required this.iconData, this.onPressed, this.isExpanded = true});

  final IconData iconData;
  final VoidCallback? onPressed;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: _borderRadius,
    child: Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(borderRadius: _borderRadius, color: _bgColor),
        child: InkWell(
          onTap: onPressed,
          child: Padding(padding: EdgeInsets.all(16), child: Icon(iconData, size: 24, color: _textColor)),
        ),
      ),
    ),
  );

  Color get _bgColor => onPressed == null ? LColors.shade1 : LColors.brand;

  Color get _textColor => onPressed == null ? LColors.disabledText : LColors.shade85;
}

final _borderRadius = BorderRadius.circular(16);
