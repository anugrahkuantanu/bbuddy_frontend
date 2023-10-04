import 'package:bbuddy_app/features/auth_firebase/screens/mobile/main_popup_menu_button.dart';
import 'package:flutter/material.dart';
import '../core.dart';

List<Widget> actionsMenu(BuildContext context) {
  return [
      const DayNightSwitch(),
      const MainPopupMenuButton(),
  ];
}

List<Widget> actionsMenuLogin(BuildContext context) {
  return [
    const DayNightSwitch(),
  ];
}
