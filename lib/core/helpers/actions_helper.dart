import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../core.dart';

List<Widget> actionsMenu(BuildContext context) {
  return [
      // IconButton(
      //   onPressed: () {
      //     Nav.to(context, '/profile');
      //   },
      //   icon: const Icon(Icons.account_circle_outlined)
      // ),
      const DayNightSwitch(),
    ActionTopButtons()
  ];
}

List<Widget> actionsMenuLogin(BuildContext context) {
  return [
    const DayNightSwitch(),
  ];
}
