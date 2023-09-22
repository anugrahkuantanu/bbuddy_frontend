import 'package:flutter/material.dart';
import '../utils/button_data.dart';
import 'package:provider/provider.dart';

import '../../config/app_theme.dart';
import '../classes/route_manager.dart';
import '../utils/bottom_util.dart';

// ignore: must_be_immutable
class BottomBar extends StatelessWidget {
  int indexColor = 0;
  int len = 0;

  List<ButtonData>? buttonDatas;
  BottomBar({Key? key, this.buttonDatas}) : super(key: key) {
    buttonDatas = buttonDatas ??
        [
          ButtonData(icon: Icons.home, label: 'Home', link: '/'),
          ButtonData(
              icon: Icons.check_circle, label: 'Check-In', link: '/checkIn'),
          ButtonData(
              icon: Icons.lightbulb,
              label: 'Reflections',
              link: '/reflections'),
          ButtonData(
              icon: Icons.check_box_outline_blank,
              label: 'Goals',
              link: '/goals'),
        ];
  }

  List<ButtonData> get buttonData => buttonDatas!;

  @override
  Widget build(BuildContext context) {
    len = buttonDatas!.length;
    var tm = context.read<ThemeProvider>();
    indexColor = tm.index;

    if (len > 1) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: indexColor,
        onTap: (val) {
          tm.setNavIndex(val);
          indexColor = val;
          navigator(context);
        },
        items: buttonData
            .map(
              (e) => bottomNavigationBarItem(
                icon: Icon(e.icon),
                label: e.label,
              ),
            )
            .toList(),
      );
    } else {
      return Container();
    }
  }

  void navigator(BuildContext context) {
    Nav.to(context, buttonData[indexColor].link!);
  }
}
