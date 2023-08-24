import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../main_app/Screens/widgets/widget.dart';

class GoalTrackingWidget extends StatelessWidget {
  final int finishedCount;
  final int milestone;
  final Color? grafikcolor;

  const GoalTrackingWidget(
      {required this.finishedCount, required this.milestone, this.grafikcolor});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(414, 896));
    double screenWidth = MediaQuery.of(context).size.width;

    final double progress =
        finishedCount / milestone; // Calculate the progress value

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 150.0.w,
        height: 150.0.w,
        child: CircularChartWidget(
          radius: 120.w,
          progress: progress,
          color: grafikcolor ?? Color.fromARGB(255, 59, 157, 157),
          label: '${finishedCount}/${milestone}',
        ),
      ),
    );
  }
}