import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import '../../services/login.dart';
import '/config/config.dart';
import '../../../../../core/core.dart';
import '../../services/service.dart';
import '../screen.dart';
import '../widgets/widget.dart';



class ProfilePage extends StatefulWidget {
  final int selectedIndex;

  ProfilePage({Key? key, this.selectedIndex = 3}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void logout(BuildContext context) {
    Cache.instance.clear();
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
    var tm = context.watch<ThemeProvider>();
    //print(userDetails.details?.firstName);
    return Scaffold(
      backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
        title: const Text('Profile'),
        centerTitle: true,
        actions: actionsMenu(context),
        // automaticallyImplyLeading: false,
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


