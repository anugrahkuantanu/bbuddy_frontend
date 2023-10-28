import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EntityButton extends StatelessWidget {
  final String? entity;
  final double? iconSize;
  final VoidCallback? onTap;
  final double? fontSize;
  final IconData? icon;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  const EntityButton({
    super.key,
    this.entity = "",
    this.icon,
    this.iconSize = 24.0,
    this.onTap,
    this.fontSize = 14.0,
    this.buttonStyle,
    this.textStyle,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: ElevatedButton(
        onPressed: onTap,
        style: buttonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // Transparent background
              foregroundColor: Colors.transparent, // No ripple effect
              shadowColor: Colors.transparent, // No shadow
              elevation: 0, // No elevation
            ),
        child: Column(
          children: [
            if (icon != null)
              Icon(
                icon!,
                size: iconSize ?? 20.w,
                color: Theme.of(context).iconTheme.color,
              ),
            Text(
              entity ?? "",
              textAlign: TextAlign.center,
              style: textStyle ?? Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
