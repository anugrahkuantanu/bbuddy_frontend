import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbuddy_app/architect.dart';
import 'package:bbuddy_app/features/auth_firebase/blocs/bloc.dart';
import 'package:bbuddy_app/features/auth_firebase/screens/widgets/widget.dart';

class ForgetPasswordScreen extends HookWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Password Reset',
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        // Added GestureDetector
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20.0.h),
                const Logo(),
                SizedBox(height: 10.0.h),
                Container(
                  child: TextField(
                    controller: emailController,
                    decoration: ThemeHelper().textInputDecoration(
                        labelText: 'Email', hintText: 'Enter your email'),
                    style: const TextStyle(
                      color: Colors
                          .black, // This sets the color of the text that the user types
                    ),
                    keyboardType: TextInputType.emailAddress,
                    keyboardAppearance: Brightness.dark,
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(height: 20.0.h),
                Button(
                  label: 'Reset Password',
                  onPressed: () {
                    final email = emailController.text;
                    context.read<AppBloc>().add(AppEventForgotPassword(email));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
