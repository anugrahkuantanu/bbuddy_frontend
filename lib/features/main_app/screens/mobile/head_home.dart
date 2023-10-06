import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/main_app/screens/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeadHomePageWidget extends StatelessWidget {
  const HeadHomePageWidget({super.key});


  Future<String?> getFirstName() async {
  try {
    String? userId = await FirebaseAuth.instance.currentUser?.uid;
    List<String>? getName = await FirebaseAuth.instance.currentUser?.displayName?.split(" ");

    String? googleFirstName = getName?.first;

    if (googleFirstName != null && googleFirstName.isNotEmpty) {
      return googleFirstName;
    } else if (userId != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final userData = await userRef.get();
      return userData.data()?['firstName'];
    }
  } catch (e) {
    print('Error retrieving user data: $e');
  }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
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
                          color: Theme.of(context).iconTheme.color,
                        ),
                        onPressed: () {
                          Nav.to(context, '/profile');
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
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        // const Text('xyz'),
                        FutureBuilder<String?>(
                          future: getFirstName(),
                          builder: (context, snapshot) {
                            // print("first name: ${snapshot.data}");
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data ?? 'anonym',
                                style: Theme.of(context).textTheme.headlineSmall,
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
        top: 0.25 * screenWidth,  // Adjust vertical position as needed
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 1.5),
            height: 150.w, // Increase the height value to make it taller
            width: 1.3 * screenWidth, // Increase the width value to make it wider
            child: const NeededCheckinReflectionWidget(),
          ),
        ),
      ),
      ],
    );
  }
}
