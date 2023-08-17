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
            label: 'Profile',
            link: '/profile',
          ),
          ButtonData(
            icon: Icons.logout,
            label: 'Logout',
            link: '/logout',
          ),
          ButtonData(
            icon: Icons.circle,
            label: 'register',
            link: '/register',
          ),
          ButtonData(
            icon: Icons.circle,
            label: 'forget',
            link: '/forget',
          ),
          ButtonData(
            icon: Icons.circle,
            label: 'testlogin',
            link: '/testlogin',
          ),
        ]);
}
