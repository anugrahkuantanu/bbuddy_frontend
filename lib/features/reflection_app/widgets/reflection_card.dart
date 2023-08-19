import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/model.dart';

class ReflectionCard extends StatelessWidget {
  final String heading;
  final List<dynamic> topicReflections; 
  final Reflection reflection;
  final void Function(List<dynamic>, Reflection)? onTap;
  final double? cardWidth;
  final double? cardHeight;
  final Gradient? gradient;

  ReflectionCard({
    required this.heading,
    required this.topicReflections,
    required this.reflection,
    this.onTap,
    this.cardWidth,
    this.cardHeight,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(17, 32, 55, 1.0),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Color(0xFFff9a96),
          width: 1.50,
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient ?? null, // This will apply the gradient if provided, otherwise it will be null
        ),
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              onTap!(topicReflections, reflection);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    heading,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topicReflections.isNotEmpty ? topicReflections[0].topic : '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        topicReflections.length > 1 ? topicReflections[1].topic : '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
