import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/config.dart';
import '../../../core/core.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    var tm = context.read<ThemeProvider>();
    index = tm.index;
  }

  @override
  Widget build(BuildContext context) {
    var tm = context.read<ThemeProvider>();
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (val) {
          tm.setNavIndex(val);
          setState(() {
            index = val;
            navigator();
          });
        },
        items: [
          bottomNavigationBarItem(icon: const Icon(Icons.home), label: 'Home'),
          bottomNavigationBarItem(
              icon: const Icon(Icons.people), label: 'CheckIn'),
          bottomNavigationBarItem(
              icon: const Icon(Icons.contact_mail), label: 'Reflection'),
          bottomNavigationBarItem(
              icon: const Icon(Icons.newspaper), label: 'Goals'),
        ]);
  }

  void navigator() {
    switch (index) {
      case 0:
        Nav.to(context, '/');
        break;
      case 1:
        Nav.to(context, '/checkIn');
        break;
      case 2:
        Nav.to(context, '/reflections');
        break;
      case 3:
        Nav.to(context, '/goals');
        break;
      default:
    }
  }
}
