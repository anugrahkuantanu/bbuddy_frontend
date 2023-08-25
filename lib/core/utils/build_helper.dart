import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        child: Text(
          'Error: $errorMessage',
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ),
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
