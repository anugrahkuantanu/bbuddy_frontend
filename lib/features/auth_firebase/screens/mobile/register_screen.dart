import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bbuddy_app/architect.dart';
import 'package:bbuddy_app/features/auth_firebase/blocs/bloc.dart';
import 'package:bbuddy_app/features/auth_firebase/screens/widgets/widget.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final verifiedPasswordController = useTextEditingController();
    final userNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final firstNameController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                const Logo(),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  child: TextField(
                    controller: lastNameController,
                    decoration: ThemeHelper().textInputDecoration(
                        labelText: 'Last name',
                        hintText: 'Enter your last name'),
                    style: const TextStyle(
                      color: Colors
                          .black, // This sets the color of the text that the user types
                    ),
                    keyboardAppearance: Brightness.dark,
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(height: 10.h),
                Container(
                  child: TextField(
                    controller: firstNameController,
                    decoration: ThemeHelper().textInputDecoration(
                        labelText: 'First name',
                        hintText: 'Enter your first name'),
                    style: const TextStyle(
                      color: Colors
                          .black, // This sets the color of the text that the user types
                    ),
                    keyboardAppearance: Brightness.dark,
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(height: 10.h),
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
                SizedBox(height: 10.h),
                Container(
                  child: TextField(
                    controller: passwordController,
                    decoration: ThemeHelper().textInputDecoration(
                        labelText: 'Password', hintText: 'Enter your password'),
                    style: const TextStyle(
                      color: Colors
                          .black, // This sets the color of the text that the user types
                    ),
                    keyboardAppearance: Brightness.dark,
                    obscureText: true,
                    obscuringCharacter: '◉',
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(height: 10.h),
                Container(
                  child: TextField(
                    controller: verifiedPasswordController,
                    decoration: ThemeHelper().textInputDecoration(
                        labelText: 'Verify Password',
                        hintText: 'Enter your password agian'),
                    style: const TextStyle(
                      color: Colors
                          .black, // This sets the color of the text that the user types
                    ),
                    keyboardAppearance: Brightness.dark,
                    obscureText: true,
                    obscuringCharacter: '◉',
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                const SizedBox(height: 50),
                Button(
                  label: 'Register',
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    final verifiedPassword = verifiedPasswordController.text;
                    final userName = userNameController.text;
                    final lastName = lastNameController.text;
                    final firstName = firstNameController.text;

                    context.read<AppBloc>().add(
                          AppEventRegister(
                            email: email,
                            password: password,
                            verifiedPassword: verifiedPassword,
                            userName: userName,
                            lastName: lastName,
                            firstName: firstName,
                          ),
                        );
                  },
                ),
                TextButton(
                  onPressed: () {
                    context.read<AppBloc>().add(const AppEventGoToLogin());
                  },
                  child: const Text('Already registered? Log in here!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
