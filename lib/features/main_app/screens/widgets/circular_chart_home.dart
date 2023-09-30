import 'package:bbuddy_app/config/config.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import './widget.dart';

// class NeededCheckinReflectionWidget extends StatelessWidget {
//   final int? checkInCount;
//   final int? reflectionCount;

//   const NeededCheckinReflectionWidget({
//     Key? key,
//     this.checkInCount,
//     this.reflectionCount,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var tm = context.watch<ThemeProvider>();
//     Color textColor = tm.isDarkMode
//         ? const Color.fromRGBO(238, 238, 238, 0.933)
//         : AppColors.textdark;

//     //ScreenUtil.init(context, designSize: Size(414, 896));
//     return Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: 40.w),
//           child: checkInCount != null
//               ? CircularChartWidget(
//                   radius: 120.0.w,
//                   progress: checkInCount! / 3,
//                   color: Colors.blue,
//                   label: 'Check-in',
//                   text_color: textColor,
//                 )
//               : Padding(
//                   padding: EdgeInsets.only(left: 50.w),
//                   child: const CircularProgressIndicator()),
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: 40.w),
//           child: reflectionCount != null
//               ? CircularChartWidget(
//                   radius: 120.0.w,
//                   progress: reflectionCount! / 3,
//                   color: Colors.green,
//                   label: 'Reflection',
//                   text_color: textColor,
//                 )
//               : Padding(
//                   padding: EdgeInsets.only(left: 50.w),
//                   child: const CircularProgressIndicator()),
//         ),
//       ],
//     );
//   }
// }

class NeededCheckinReflectionWidget extends StatelessWidget {
  const NeededCheckinReflectionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    Color textColor = tm.isDarkMode
        ? const Color.fromRGBO(238, 238, 238, 0.933)
        : AppColors.textdark;
    final counterStats = Provider.of<CounterStats>(context);

    //ScreenUtil.init(context, designSize: Size(414, 896));
    return counterStats.errorMessage == ''
        ? Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40.w),
                child: counterStats.isLoading
                    ? Padding(
                        padding: EdgeInsets.only(left: 50.w),
                        child: const CircularProgressIndicator())
                    : CircularChartWidget(
                        progress:
                            int.tryParse(counterStats.checkInCounter!.value)! /
                                3,
                        color: Colors.blue,
                        label: 'Check-in',
                        radius: 120.0.w),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40.w),
                child: counterStats.isLoading
                    ? Padding(
                        padding: EdgeInsets.only(left: 50.w),
                        child: const CircularProgressIndicator())
                    : CircularChartWidget(
                        radius: 120.0.w,
                        progress: int.tryParse(
                                counterStats.reflectionCounter!.value)! /
                            3,
                        color: Colors.green,
                        label: 'Reflection',
                        text_color: textColor,
                      ),
              )
            ],
          )
        : Text(counterStats.errorMessage);
  }
}
