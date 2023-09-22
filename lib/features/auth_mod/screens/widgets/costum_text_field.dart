import 'package:flutter/material.dart';
import '/core/utils/utils.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;

  CustomTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        controller: controller,
        decoration: ThemeHelper().textInputDecoration(labelText:label, hintText: hint),
        obscureText: isPassword,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}