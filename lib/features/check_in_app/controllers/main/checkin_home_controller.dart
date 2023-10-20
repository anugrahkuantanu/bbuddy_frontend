import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../screens/mobile/checkIn_home.dart' as mobile;

class CheckInHomeController extends StatelessController {
  final String _title = 'Check-In';
  const CheckInHomeController({Key? key}) : super(key: key);

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: const mobile.CheckInHome(),
    );
  }
}
