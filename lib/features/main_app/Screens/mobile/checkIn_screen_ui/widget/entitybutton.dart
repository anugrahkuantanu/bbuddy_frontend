import 'package:flutter/material.dart';

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
        backgroundColor: Colors.transparent,   // Transparent background
        foregroundColor: Colors.transparent, // No ripple effect
        shadowColor: Colors.transparent, // No shadow
        elevation: 0, // No elevation
      ),
      child: Column(
        children: [
          if (emoji != null) Text(emoji!, style: TextStyle(fontSize: emojiSize, color: textColor)),
          if (icon != null) Icon(icon!, size: emojiSize, color: textColor),
          Text(
            entity ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

