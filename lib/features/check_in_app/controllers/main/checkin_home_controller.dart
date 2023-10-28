import 'package:bbuddy_app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../screens/mobile/checkIn_home.dart' as mobile;

class CheckInHomeController extends StatelessController {
  final String _title = 'Check-In';
  const CheckInHomeController({Key? key}) : super(key: key);

  @override
  bool get auth => true;

  @override

  Display view(BuildContext context) {
    var tm = context.read<ThemeProvider?>();
    tm?.setNavIndex(1);
    return Display(
      title: _title,
      mobile: const mobile.CheckInHome(),
    );
  }
}
