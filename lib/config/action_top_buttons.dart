import 'package:flutter/material.dart';

import '../core/core.dart';
import '../features/main_app/app.dart';

// ignore: must_be_immutable
class ActionTopButtons extends ActionButtons {
  ActionTopButtons({Key? key})
      : super(key: key, buttonDatas: [
          ButtonData(
            icon: Icons.home,
            label: 'Main App',
            link: App.home,
          ),
          ButtonData(
            icon: Icons.account_circle_outlined,
            label: 'Prifile',
            link: '/profile',
          ),
        //       IconButton(
        // onPressed: () {
        //   Nav.to(context, '/profile');
        // },
        // icon: const Icon(Icons.account_circle_outlined)),
          ButtonData(
            icon: Icons.logout,
            label: 'Logout',
            link: '/logout',
          ),
        ]);
}
