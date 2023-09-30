import 'package:bbuddy_app/config/config.dart';
import 'package:bbuddy_app/features/features.dart';
import 'package:flutter/material.dart';
import '../widgets/widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../services/service.dart';

class HeadHomePageWidget extends StatelessWidget {
  const HeadHomePageWidget({super.key});

  // Future<String?> getFirstName() async {
  //   String? getUserId = await FirebaseAuth.instance.currentUser?.uid;
  //   List<String>? getName =
  //       await FirebaseAuth.instance.currentUser!.displayName!.split(" ");
  //   print("my name: ${getName[0].toString()}");

  //   // String? getUserId = await FirebaseAuth.instance.currentUser?.uid;
  //   final userRef =
  //       FirebaseFirestore.instance.collection('users').doc(getUserId);
  //   String? name; // Declare and initialize the 'name' variable
  //   try {
  //     final userData = await userRef.get();
  //     name = userData.data()?['firstName'];
  //   } catch (e) {
  //     print('Error retrieving user data: $e');
  //   }
  //   return name;
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var tm = context.watch<ThemeProvider>();
    Color textColor = tm.isDarkMode
        ? const Color.fromRGBO(238, 238, 238, 0.933)
        : AppColors.textdark;

    double textSizeS = 16.0.w;
    double textSizeXl = 20.0.w;

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
                          color: textColor,
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
                            fontSize: textSizeS,
                            color: textColor,
                          ),
                        ),
                        const Text('xyz'),
                        // FutureBuilder<String?>(
                        //   future: getFirstName(),
                        //   builder: (context, snapshot) {
                        //     // print("first name: ${snapshot.data}");
                        //     if (snapshot.connectionState ==
                        //         ConnectionState.waiting) {
                        //       return const CircularProgressIndicator();
                        //     } else if (snapshot.hasError) {
                        //       return Text('Error: ${snapshot.error}');
                        //     } else {
                        //       return Text(
                        //         snapshot.data ?? 'anonym',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.w600,
                        //           fontSize: textSizeXl,
                        //           color: textColor,
                        //         ),
                        //       );
                        //     }
                        //   },
                        // ),
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
          left: (screenWidth - 0.95 * screenWidth) / 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 1.5),
            height: 150.w, // Increase the height value to make it taller
            width:
                1.3 * screenWidth, // Increase the width value to make it wider
            child: const NeededCheckinReflectionWidget(),
            // child: NeededCheckinReflectionWidget(
            //   checkInCount: int.tryParse(counterStats.checkInCounter?.value ??
            //       '0'), // Number of check-ins completed
            //   reflectionCount: int.tryParse(
            //       counterStats.reflectionCounter?.value ??
            //           '0'), // Number of reflections completed
            // ),
          ),
        )
      ],
    );
  }
}
