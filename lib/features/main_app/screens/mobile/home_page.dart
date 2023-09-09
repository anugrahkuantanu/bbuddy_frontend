import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/widget.dart';
import '../../../../../core/core.dart';
import '/config/config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
    var tm = context.watch<ThemeProvider?>();
    Color textColor = tm?.isDarkMode ?? false ? AppColors.textlight : AppColors.textdark;

    // var tm = context.watch<ThemeProvider?>();
    // Color? textColor = tm?.isDarkMode ? AppColors.textlight : AppColors.textdark;
    
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: HeadHomePageWidget(context, text_color: textColor),
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
              child: CheckInHistoryCard(
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }


  void onSeeAllTapped() {
  }


  void onDepressionHealingTapped() {
  }

  void onSearchIconTapped() {
  }
}

