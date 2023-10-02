import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalCard extends StatelessWidget {
  final Color? textColor;
  final double? titlesize;
  final double? bodysize;
  final String? title;
  final String? body;
  final String? subtitle;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final double? height;
  final double? width;
  final Widget? vectorBottom;
  final Widget? vectorTop;
  final double? borderRadius;
  final IconData? icon;
  final Function()? onTap;

  const PersonalCard({
    Key? key,
    this.onTap,
    this.textColor,
    this.titlesize,
    this.bodysize,
    this.title,
    this.body,
    this.subtitle,
    this.gradientStartColor,
    this.gradientEndColor,
    this.height,
    this.width,
    this.vectorBottom,
    this.vectorTop,
    this.borderRadius,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap ?? () {},
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              gradientStartColor ?? const Color(0xff441DFC),
              gradientEndColor ?? const Color(0xff4E81EB),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, top: 20.w, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title != null ? title! : '',
                      style: TextStyle(
                          fontSize: titlesize ?? 18.w,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                    Row(
                      children: [
                        if (icon != null)
                          SizedBox(
                            width: ((screenWidth + 100.w) / 4),
                            height: ((screenWidth) / 6),
                            child: Icon(
                              icon,
                              size: ((screenWidth - 80.w) / 3),
                              color: textColor ?? Colors.white,
                            ),
                          ),
                        if (icon == null) SizedBox(height: 50.w),
                        Expanded(
                          child: Text(
                            body ?? '',
                            style: TextStyle(
                              fontSize: bodysize ?? 16.w,
                              color: textColor ?? Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    )
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
