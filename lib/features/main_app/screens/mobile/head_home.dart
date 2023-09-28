import 'package:bbuddy_app/features/features.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../auth_mod/screens/screen.dart';
import '../widgets/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../services/service.dart';
import '../../../auth_mod/services/service.dart';

class HeadHomePageWidget extends StatelessWidget {
  final BuildContext context;
  final Color? text_color;

  const HeadHomePageWidget(this.context, {this.text_color});

  static String? get userId => null;

  Future<String?> getFirstName() async {
    String? getUserId = await FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(getUserId);
    String? name; // Declare and initialize the 'name' variable
    try {
      final userData = await userRef.get();
      name = userData.data()?['firstName'];
    } catch (e) {
      print('Error retrieving user data: $e');
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
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
                                builder: (context) =>
                                    const ProfileController()),
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
                        FutureBuilder<String?>(
                          future: getFirstName(),
                          builder: (context, snapshot) {
                            // print("first name: ${snapshot.data}");
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data ?? 'anonym',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: text_size_xl,
                                  color: text_color ?? Colors.white,
                                ),
                              );
                            }
                          },
                        ),
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
              checkInCount: int.tryParse(counter_stats.checkInCounter?.value ??
                  ''), // Number of check-ins completed
              reflectionCount: int.tryParse(
                  counter_stats.reflectionCounter?.value ??
                      ''), // Number of reflections completed
            ),
          ),
        )
      ],
    );
  }
}
