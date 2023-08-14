import 'package:flutter/material.dart';

class EntityButton extends StatelessWidget {
  final String? entity;
  final String? emoji; // Change this to accept a String for the emoji
  final double? emojiSize;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? fontSize;
  final IconData? icon;

  const EntityButton({
    this.entity = "",
    this.emoji,  // Adjust this as well
    this.icon,
    this.emojiSize = 24.0,
    this.textColor = Colors.black,
    this.onTap,
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            if (emoji != null) Text(emoji!, style: TextStyle(fontSize: emojiSize, color: textColor)), // Use Text widget to display emoji
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
      ),
    );
  }
}
