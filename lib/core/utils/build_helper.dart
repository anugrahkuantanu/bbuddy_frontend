import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/screens/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/config/config.dart';

class ErrorUI extends StatelessWidget {
  final String errorMessage;
  final String? title;

  ErrorUI({required this.errorMessage, this.title});

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    return Scaffold(
        appBar: AppBar(
        backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
        title: Text(title ?? ""),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
            body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
          'Error: $errorMessage',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class NotEnoughtReflection extends StatelessWidget {
  final String response;
  final String? title;

  NotEnoughtReflection({required this.response, this.title});

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    return Scaffold(
        appBar: AppBar(
        backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
        title: Text(title ?? ""),
        automaticallyImplyLeading: false,
        leading: IconButton(
        icon: Icon(Icons.arrow_back), // add your custom icon here
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoalHome()),
        );
       },
      ),
      ),
      backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            'Reason: $response',
            style: TextStyle(color: Colors.white, fontSize: 25.0.w),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class LoadingUI extends StatelessWidget {
  final String? title;

  LoadingUI({required this.title});

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    return Scaffold(
        appBar: AppBar(
        backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
        title: Text(title ?? ""),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
