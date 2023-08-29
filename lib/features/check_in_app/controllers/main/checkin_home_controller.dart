import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../screens/mobile/checkIn_home.dart' as mobile;

class CheckInHomeController extends StatefulController {
  final String _title = 'Check-In';
  const CheckInHomeController({Key? key}) : super(key: key);

  @override
  _CheckInHomeControllerState createState() => _CheckInHomeControllerState();
}

class _CheckInHomeControllerState extends ControllerState<CheckInHomeController> {
  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: widget._title,
      mobile: const mobile.CheckInHome(
      ),
    );
  }
}
