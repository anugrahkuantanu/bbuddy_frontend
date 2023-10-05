import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../screen.dart';
import '../../../auth_mod/screens/mobile/login_page.dart';
import '../../../auth_mod/services/login.dart';
import '../../../../../core/core.dart';
import '../../../auth_mod/services/service.dart';
import '../../../auth_mod/screens/screen.dart';
import '../../../auth_mod/screens/widgets/widget.dart';

class ProfilePage extends StatefulWidget {
  final int selectedIndex;

  const ProfilePage({Key? key, this.selectedIndex = 3}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final userDetails = Provider.of<UserDetailsProvider>(context);
    //print(userDetails.details?.firstName);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Nav.toNamed(context, '/'),
        ),
        centerTitle: true,
        actions: const [
          MainPopupMenuButton(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 150.w),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: EdgeInsets.all(20.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.w),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
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
                                color: const Color(0xFF404659)),
                          )
                        : const CircularProgressIndicator(),
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
                              : const CircularProgressIndicator(),
                          SizedBox(height: 50.h),
                          userDetails.details != null
                              ? UserInfoItem(
                                  icon: Icons.phone,
                                  label: 'Phone',
                                  value: userDetails.details!.phone ?? '-',
                                )
                              : const CircularProgressIndicator(),
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