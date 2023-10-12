import 'package:bbuddy_app/architect.dart';
import 'package:bbuddy_app/features/auth_mod/screens/widgets/button.dart';
import 'package:bbuddy_app/features/auth_mod/screens/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../blocs/bloc.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();

    final passwordController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log in',
        ),
        centerTitle: true,
        actions: actionsMenuLogin(context),
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
                LoginLogo(),
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
                SizedBox(height: 20.0.h),
                Button(
                  label: 'Sing In',
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;
                    context.read<AppBloc>().add(
                          AppEventLogIn(
                            email: email,
                            password: password,
                          ),
                        );
                  },
                ),
                SizedBox(height: 10.0.h),
                Button(
                  label: 'Sign Up',
                  onPressed: () {
                    context.read<AppBloc>().add(
                          const AppEventGoToRegistration(),
                        );
                  },
                ),
                SizedBox(height: 5.0.h),
                TextButton(
                  onPressed: () {
                    Nav.to(context, '/forget_password');
                  },
                  child: const Text('Forget password?'),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
                Text(
                  'Or continue with',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 5.0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                        onTap: () {
                          context.read<AppBloc>().add(
                                AppEventGoogleLogin(),
                              );
                        },
                        imagePath: 'assets/images/google.png'),

                    SizedBox(width: 25.0.w),

                    // apple button
                    SquareTile(
                        onTap: () {
                          context.read<AppBloc>().add(
                                AppEventAppleLogin(),
                              );
                        },
                        imagePath: 'assets/images/apple.png')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
