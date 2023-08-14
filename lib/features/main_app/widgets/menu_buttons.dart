import 'package:flutter/material.dart';

import '../../../core/classes/classes.dart';

class MenuButtons extends StatelessWidget {
  const MenuButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'Menu Buttons',
      onSelected: (value) => handleClick(value.toString(), context),
      itemBuilder: (context) {
        return ['Home', 'Check-In', 'Reflections', 'Goals']
            .map((choice) => PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                ))
            .toList();
      },
    );
  }

  void handleClick(String index, BuildContext context) {
    switch (index) {
      case 'Home':
        Nav.to(context, '/');
        break;
      case 'Check-In':
        Nav.to(context, '/checkIn');
        break;
      case 'Reflections':
        Nav.to(context, '/reflections');
        break;
      case 'Goals':
        Nav.to(context, '/goals');
        break;
      default:
    }
  }
}
