import 'package:flutter/material.dart';
import '../../../../utils/theme_helper.dart';

class Button extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  Button({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle().copyWith(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(17, 32, 55, 1.0))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}