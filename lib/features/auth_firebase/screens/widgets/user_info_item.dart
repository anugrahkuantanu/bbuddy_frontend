import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color; 

  UserInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.color = Colors.black, 
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final displayValue = value.isNotEmpty ? value : '-';

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 15.0),  // Add padding here
          child: Icon(icon, color: color),
        ),
        SizedBox(width: screenWidth * 0.01.w),
        Expanded(  // <-- Wrap with Expanded
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  overflow: TextOverflow.ellipsis,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                displayValue,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  overflow: TextOverflow.ellipsis,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class UserInfoItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final Color color; 

//   UserInfoItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//     this.color = Colors.black, 
//   });

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     final displayValue = value.isNotEmpty ? value : '-';

//     return Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(right: 15.0),  // Add padding here
//           child: Icon(icon, color: color),
//         ),
//         SizedBox(width: screenWidth * 0.01.w),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16.sp,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               displayValue,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14.sp,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
