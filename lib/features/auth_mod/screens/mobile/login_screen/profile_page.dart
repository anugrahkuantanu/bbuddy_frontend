import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../login_screen/login_page.dart';
import '../../../services/login.dart';
import '/core/services/storage.dart';


class ProfilePage extends StatefulWidget {
  final int selectedIndex;

  ProfilePage({Key? key, this.selectedIndex = 3}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void logout(BuildContext context) {
    SecureStorage storage = SecureStorage.instance;
    storage.clear();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.CheckLoginStatus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  LoginPage()),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double _drawerIconSize = 24;
    double _drawerFontSize = 17;
    double screenWidth = MediaQuery.of(context).size.width;
    final userDetails = Provider.of<UserDetailsProvider>(context);
    //print(userDetails.details?.firstName);
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF2D425F),
        elevation: 0,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz, color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  // PopupMenuItem<String>(
                  //   value: 'edit',
                  //   child: Text('Edit Profile'),
                  // ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Log out'),
                  ),
                ];
              },
              onSelected: (String value) {
                if (value == 'edit') {
                  // edit profile action
                } else if (value == 'logout') {
                   
                  //   logout(context);
                  // // logout action
                }
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 150.w),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: EdgeInsets.all(20.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    userDetails.details != null &&
                            userDetails.details?.firstName != null &&
                            userDetails.details?.lastName != null
                        ? Text(
                            userDetails.details!.firstName +
                                ' ' +
                                userDetails.details!.lastName,
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF404659)),
                          )
                        : CircularProgressIndicator(),
                    SizedBox(height: 100.h),
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Column(
                        children: [
                          userDetails.details != null
                              ? UserInfoItem(
                                  icon: Icons.email,
                                  label: 'Email',
                                  value: userDetails.details!.email,
                                )
                              : CircularProgressIndicator(),
                          SizedBox(height: 50.h),
                          userDetails.details != null
                              ? UserInfoItem(
                                  icon: Icons.phone,
                                  label: 'Phone',
                                  value: userDetails.details!.phone ?? '-',
                                )
                              : CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  UserInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final displayValue = value.isNotEmpty ? value : '-';

    return Row(
      children: [
        Icon(icon),
        SizedBox(width: screenWidth * 0.01.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              displayValue,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
