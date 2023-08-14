import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class EntityButton extends StatelessWidget {
  final String? entity;
  final IconData? icon;
  final double? emojiSize;
  final Color? textColor;
  final VoidCallback? onTap;
  final double? fontSize;

  EntityButton({
    this.entity = "",
    this.icon,
    this.emojiSize = 24.0, // Assuming 24.0 as the default size
    this.textColor = Colors.black, // Assuming black as the default color
    this.onTap,
    this.fontSize = 14.0, // Assuming 14.0 as the default font size
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            if (icon != null) Icon(icon!, size: emojiSize, color: textColor), // Handling null for icon
            Text(
              entity ?? "", // If entity is null, use an empty string
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


// class EntityButton extends StatelessWidget {
//   final String entity;
//   final IconData icon;
//   final double emojiSize;
//   final Color textColor;
//   final VoidCallback onTap;
//   final double fontSize;

//   EntityButton({
//     required this.entity,
//     required this.icon,
//     required this.emojiSize,
//     required this.textColor,
//     required this.onTap,
//     required this.fontSize,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width / 5,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Column(
//           children: [
//             Icon(icon, size: emojiSize, color: textColor),
//             Text(
//               entity,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: fontSize, // Or use a dynamic computation based on screen size
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
