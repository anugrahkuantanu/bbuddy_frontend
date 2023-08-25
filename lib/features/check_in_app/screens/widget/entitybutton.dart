import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EntityButton extends StatelessWidget {

  final String? entity;
  final String? emoji; // Change this to accept a String for the emoji
  final double? emojiSize;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? fontSize;
  final IconData? icon;
  final Color? backgroundColor;
  final ButtonStyle? buttonStyle;

  const EntityButton({
    this.entity = "",
    this.emoji,  // Adjust this as well
    this.icon,
    this.emojiSize = 24.0,
    this.textColor = Colors.black,
    this.onTap,
    this.fontSize = 14.0,
    this.backgroundColor,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: buttonStyle ?? ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.transparent,   // Transparent background
        foregroundColor: Colors.transparent, // No ripple effect
        shadowColor: Colors.transparent, // No shadow
        elevation: 0, // No elevation
      ),
      child: Column(
        children: [
          if (emoji != null) Text(emoji!, style: TextStyle(fontSize: emojiSize ?? 20.w, color: textColor ?? Colors.transparent)),
          if (icon != null) Icon(icon!, size: emojiSize ?? 20.w, color: textColor ?? Colors.transparent),
          Text(
            entity ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontSize: fontSize ?? 20.w,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

