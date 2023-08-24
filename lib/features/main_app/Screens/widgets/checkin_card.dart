import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckInCard extends StatelessWidget {
  final double? titlesize;
  final double? bodysize;
  final String? title;
  final String? body;
  final String? subtitle;
  final Color? text_color;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final double? height;
  final double? width;
  final Widget? vectorBottom;
  final Widget? vectorTop;
  final double? borderRadius;
  final Widget? icon;
  final Function()? onTap;
  final Color? borderColor; // New parameter for border color

  const CheckInCard({
    Key? key,
    this.titlesize,
    this.bodysize,
    this.title,
    this.body,
    this.subtitle,
    this.text_color,
    this.gradientStartColor,
    this.gradientEndColor,
    this.height,
    this.width,
    this.vectorBottom,
    this.vectorTop,
    this.borderRadius,
    this.icon,
    this.onTap,
    this.borderColor, // Initialize the new parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius ?? 20),
      onTap: onTap ?? () {},
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          gradient: LinearGradient(
            colors: [
              gradientStartColor ?? Color(0xff441DFC),
              gradientEndColor ?? Color(0xff4E81EB),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          // border: Border.all(
          //   color: borderColor?? Colors.red, // Set the border color dynamically
          //   width: 2, // Set the border width
          // ),
        ),
        child: Stack(
          children: [
            if (icon != null)
              Container(
                width: ((screenWidth + 100.w) / 4),
                height: ((screenWidth) / 6),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 25.w,
                    top: 25.w,
                    bottom: 25.w,
                    right: 25.w,
                  ),
                  child: Icon(
                    icon as IconData?,
                    size: ((screenWidth - 80.w) / 3),
                    color: text_color ?? Colors.white,
                  ),
                ),
              ),
            if (icon == null)
              SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    top: 20.w,
                    bottom: 20.w,
                    right: 20.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      title != null
                          ? Text(
                              title!,
                              style: TextStyle(
                                fontSize: titlesize ?? 18.w,
                                fontWeight: FontWeight.bold,
                                color: text_color ?? Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          : LinearProgressIndicator(),
                      body != null
                          ? Text(
                              body!,
                              style: TextStyle(
                                fontSize: bodysize ?? 16.w,
                                color: text_color ?? Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          : LinearProgressIndicator(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
