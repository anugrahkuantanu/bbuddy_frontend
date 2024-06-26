import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/config.dart';
import '../core.dart';

// ignore: must_be_immutable
class ActionButtons extends StatelessWidget {
  List<ButtonData>? buttonDatas;
  ActionButtons({
    Key? key,
    this.buttonDatas,
  }) : super(key: key) {
    buttonDatas = buttonDatas ??
        [
          ButtonData(icon: Icons.home, label: 'Home', link: '/'),
          ButtonData(icon: Icons.people, label: 'Profile', link: '/profile'),
          ButtonData(icon: Icons.logout, label: 'Logout', link: '/logout'),
        ];
  }

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();
    return PopupMenuButton(
      tooltip: 'Menu Buttons',
      onSelected: (ButtonData bd) => handleClick(bd.link!, context),
      itemBuilder: (context) {
        return buttonDatas!
            .map((choice) => PopupMenuItem<ButtonData>(
                  value: choice,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        choice.icon,
                        color:
                            tm.isDarkMode == true ? Colors.white : Colors.black,
                      ),
                      Text(choice.label),
                    ],
                  ),
                ))
            .toList();
      },
    );
  }

  void handleClick(String link, BuildContext context) {
    if (link == '/logout') {
      doLogout(context);
    }
    Nav.to(context, link);
  }
}
