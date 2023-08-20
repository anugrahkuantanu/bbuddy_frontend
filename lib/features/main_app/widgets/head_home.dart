import 'package:flutter/material.dart';
import '../../auth_mod/screens/screen.dart';
import '../widgets/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../services/service.dart';
import '../../auth_mod/services/service.dart';



class HeadHomePageWidget extends StatelessWidget {
  final BuildContext context;
  final Color? text_color;

  const HeadHomePageWidget(this.context, {this.text_color});

  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserDetailsProvider>(context);
    final counter_stats = Provider.of<CounterStats>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    
    double text_size_s = 16.0.w;
    double text_size_xl = 20.0.w;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 0.7 * screenWidth,
              /*decoration: BoxDecoration(
                color: Color(0xFF2D425F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),*/
              child: Stack(
                children: [
                  Positioned(
                    top: 25.w,
                    right: 10.w,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.person,
                          size: 30.w,
                          color: text_color ?? Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 25.w,
                    left: 10.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: text_size_s,
                            color: text_color ?? Colors.white,
                          ),
                        ),
                        userDetails.details != null &&
                                userDetails.details?.firstName != null
                            ? Text(
                                userDetails.details!.firstName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: text_size_xl,
                                  color: text_color ?? Colors.white,
                                ),
                              )
                            : CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0.25 * screenWidth,
          //top: 0.12 * screenHeight,
          left: (screenWidth - 0.95 * screenWidth) / 2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 1.5),
            height: 150.w, // Increase the height value to make it taller
            //height: 0.15 * screenHeight, // Increase the height value to make it taller
            width:
                1.3 * screenWidth, // Increase the width value to make it wider
            child: NeededCheckinReflectionWidget(
              text_color: text_color ?? Colors.white,
              checkInCount: int.tryParse(counter_stats.checkInCounter?.value ?? ''), // Number of check-ins completed
              reflectionCount: int.tryParse(counter_stats.reflectionCounter?.value ?? ''), // Number of reflections completed
            ),
          ),
        )
      ],
    );
  }
}