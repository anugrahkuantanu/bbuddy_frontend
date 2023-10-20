import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EntityButton extends StatelessWidget {

  final String? entity;
  final double? iconSize;
  final VoidCallback? onTap;
  final double? fontSize;
  final IconData? icon;
  final ButtonStyle? buttonStyle;
  final TextStyle? style;

  const EntityButton({
    this.entity = "",
    this.icon,
    this.iconSize = 24.0,
    this.onTap,
    this.fontSize = 14.0,
    this.buttonStyle,
    this.style,
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
          if (icon != null) Icon(
            icon!, 
            size: iconSize ?? 20.w, 
            color: Theme.of(context).iconTheme.color,),
          Text(
            entity ?? "",
            textAlign: TextAlign.center,
            style: style ?? Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

