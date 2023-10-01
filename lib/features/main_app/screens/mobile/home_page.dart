import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbuddy_app/features/main_app/screens/widgets/widget.dart';
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkin_history_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    Color textColor = tm.isDarkMode
        ? const Color.fromRGBO(238, 238, 238, 0.933)
        : AppColors.textdark;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: const HeadHomePageWidget(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 28.w, bottom: 12.w),
              child: Text(
                "Check-In Story",
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.w),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: Builder(
                builder: (context) => CheckInHistoryCard(
                  bloc: context.read<CheckInHistoryBloc>(), // Use existing BLoC
                  textColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
