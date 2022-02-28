import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final Color textColor;
  final BorderSide borderSide;
  final Size size;
  final String prefix;
  final EdgeInsetsGeometry? padding;
  final double labelFontSize;
  const CustomButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onPressed,
    required this.size,
    required this.textColor,
    required this.borderSide,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
    this.prefix = '',
    this.labelFontSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            padding: padding,
            backgroundColor: color,
            side: borderSide,
            shadowColor: const Color(0xFF323247)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefix == '' ? const SizedBox.shrink() : SvgPicture.asset(prefix),
            prefix == '' ? const SizedBox.shrink() : const SizedBox(width: 15),
            Text(
              label,
              style: TextStyle(
                fontSize: labelFontSize,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
