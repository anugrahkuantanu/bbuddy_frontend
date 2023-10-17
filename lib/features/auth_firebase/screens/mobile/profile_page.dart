import 'package:bbuddy_app/core/classes/route_manager.dart';
import 'package:bbuddy_app/core/helpers/actions_helper.dart';
import 'package:bbuddy_app/features/auth_firebase/screens/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  final int selectedIndex;

  const ProfilePage({Key? key, this.selectedIndex = 3}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  Future<Map<String, String?>> getUserData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      List<String>? getName = FirebaseAuth.instance.currentUser?.displayName?.split(" ");
      String? getEmail = FirebaseAuth.instance.currentUser?.email;

      String? firstName = getName?.first ?? '';
      String? lastName = getName?.last ?? '';
      String? email = getEmail ?? '';

      if (userId != null) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
        final userData = await userRef.get();
        firstName = userData.data()?['firstName'] ?? firstName;
        lastName = userData.data()?['lastName'] ?? lastName;
        email = userData.data()?['email'] ?? email;
      }

      return {'firstName': firstName, 'lastName': lastName, 'email': email};
    } catch (e) {
      print('Error retrieving user data: $e');
      return {'firstName': null, 'lastName': null, 'email': null};
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // final userDetails = Provider.of<UserDetailsProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Nav.toNamed(context, '/'),
        ),
        centerTitle: true,
        actions: actionsMenu(context),
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, String?>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!['firstName'] == null) {
              return Center(child: Text('No data available'));
            } else {
              return Padding(
              padding: EdgeInsets.only(top: 150.w),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: EdgeInsets.all(20.w),
                width: double.infinity,
                height: 400.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.w),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                  child: Column(
                    children: [
                      UserInfoItem(
                        icon: Icons.person,
                        label: 'Firstname:',
                        value: snapshot.data!['firstName'] ?? '',

                      ),
                      SizedBox(height: 50.h),
                      UserInfoItem(
                        icon: Icons.person_outline,
                        label: 'Lastname:',
                        value: snapshot.data!['lastName'] ?? '',
                      ),
                      SizedBox(height: 50.h),
                      UserInfoItem(
                        icon: Icons.email,
                        label: 'Email',
                        value: snapshot.data!['email'] ?? '',
                      ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../screen.dart';
// import '../../../auth_mod/screens/mobile/login_page.dart';
// import '../../../auth_mod/services/login.dart';
// import '../../../../../core/core.dart';
// import '../../../auth_mod/services/service.dart';
// import '../../../auth_mod/screens/screen.dart';
// import '../../../auth_mod/screens/widgets/widget.dart';

// class ProfilePage extends StatefulWidget {
//   final int selectedIndex;

//   const ProfilePage({Key? key, this.selectedIndex = 3}) : super(key: key);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }



// class _ProfilePageState extends State<ProfilePage> {

//   Future<String?> getFirstName() async {
//   try {
//     String? userId = await FirebaseAuth.instance.currentUser?.uid;
//     List<String>? getName = await FirebaseAuth.instance.currentUser?.displayName?.split(" ");

//     String? googleFirstName = getName?.first;

//     if (googleFirstName != null && googleFirstName.isNotEmpty) {
//       return googleFirstName;
//     } else if (userId != null) {
//       final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
//       final userData = await userRef.get();
//       return userData.data()?['firstName'];
//     }
//   } catch (e) {
//     print('Error retrieving user data: $e');
//   }
//     return null;
//   }

//   Future<String?> getLastName() async {
//   try {
//     String? userId = await FirebaseAuth.instance.currentUser?.uid;
//     List<String>? getName = await FirebaseAuth.instance.currentUser?.displayName?.split(" ");

//     String? googleLastName = getName?.last;

//     if (googleLastName != null && googleLastName.isNotEmpty) {
//       return googleLastName;
//     } else if (userId != null) {
//       final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
//       final userData = await userRef.get();
//       return userData.data()?['lastName'];
//     }
//   } catch (e) {
//     print('Error retrieving user data: $e');
//   }
//     return null;
//   }

//   Future<String?> getEmail() async {
//   try {
//     String? userId = await FirebaseAuth.instance.currentUser?.uid;
//     String? getEmail = await FirebaseAuth.instance.currentUser?.email;

//     String? googleEmail = getEmail;

//     if (googleEmail != null && googleEmail.isNotEmpty) {
//       return googleEmail;
//     } else if (userId != null) {
//       final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
//       final userData = await userRef.get();
//       return userData.data()?['email'];
//     }
//   } catch (e) {
//     print('Error retrieving user data: $e');
//   }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//     final userDetails = Provider.of<UserDetailsProvider>(context);
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: const Text('Profile'),
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () => Nav.toNamed(context, '/'),
//         ),
//         centerTitle: true,
//         actions: actionsMenu(context),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 150.w),
//               child: Container(
//                 alignment: Alignment.center,
//                 margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
//                 padding: EdgeInsets.all(20.w),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10.w),
//                   boxShadow: [
//                     const BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20.h),
//                     userDetails.details != null &&
//                             userDetails.details?.firstName != null &&
//                             userDetails.details?.lastName != null
//                         ? Text(
//                             userDetails.details!.firstName +
//                                 ' ' +
//                                 userDetails.details!.lastName,
//                             style: TextStyle(
//                                 fontSize: 22.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFF404659)),
//                           )
//                         : const CircularProgressIndicator(),
//                     SizedBox(height: 100.h),
//                     Container(
//                       padding: EdgeInsets.all(10.w),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.w),
//                       ),
//                       child: Column(
//                         children: [
//                           userDetails.details != null
//                               ? UserInfoItem(
//                                   icon: Icons.email,
//                                   label: 'Email',
//                                   value: userDetails.details!.email,
//                                 )
//                               : const CircularProgressIndicator(),
//                           SizedBox(height: 50.h),
//                           userDetails.details != null
//                               ? UserInfoItem(
//                                   icon: Icons.phone,
//                                   label: 'Phone',
//                                   value: userDetails.details!.phone ?? '-',
//                                 )
//                               : const CircularProgressIndicator(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }
