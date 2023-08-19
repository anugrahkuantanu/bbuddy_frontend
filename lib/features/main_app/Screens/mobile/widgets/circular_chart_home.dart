import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './widget.dart';

class NeededCheckinReflectionWidget extends StatelessWidget {
  final int? checkInCount;
  final int? reflectionCount;
  final Color? text_color;

  NeededCheckinReflectionWidget({
    this.checkInCount,
    this.reflectionCount,
    this.text_color,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(414, 896));
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 40.w),
          child: checkInCount != null
              ? CircularChartWidget(
                  radius: 120.0.w,
                  progress: checkInCount! / 3,
                  color: Colors.blue,
                  label: 'Check-in',
                  text_color: text_color,
                )
              : Padding(
                  padding: EdgeInsets.only(left: 50.w),
                  child: CircularProgressIndicator()),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40.w),
          child: reflectionCount != null
              ? CircularChartWidget(
                  radius: 120.0.w,
                  progress: reflectionCount! / 3,
                  color: Colors.green,
                  label: 'Reflection',
                  text_color: text_color,
                )
              : Padding(
                  padding: EdgeInsets.only(left: 50.w),
                  child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
