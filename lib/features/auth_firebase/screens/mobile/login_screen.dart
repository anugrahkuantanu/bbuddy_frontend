import 'package:bbuddy_app/architect.dart';
import 'package:bbuddy_app/features/auth_mod/screens/widgets/button.dart';
import 'package:bbuddy_app/features/auth_mod/screens/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../blocs/bloc.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
    );

    final passwordController = useTextEditingController(
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log in',
        ),
        centerTitle: true,
        actions: actionsMenuLogin(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 80.0.h),
            LoginLogo(),
            SizedBox(height: 40.0.h),
            Container(
              child: TextField(
                controller: emailController,
                decoration: ThemeHelper().textInputDecoration(labelText: 'Email', hintText: 'Enter your email'),
                style: TextStyle(
                  color: Colors.black,  // This sets the color of the text that the user types
                ),
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.dark,
              ),
              decoration: ThemeHelper().inputBoxDecorationShaddow(),
            ),
            SizedBox(height: 10.h,),
            Container(
              child: TextField(
              controller: passwordController,
                decoration: ThemeHelper().textInputDecoration(labelText: 'Password', hintText: 'Enter your password'),
                style: TextStyle(
                  color: Colors.black,  // This sets the color of the text that the user types
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
            SizedBox(height: 10.0.h),
            Button(
              label: 'Google',
              onPressed: () {
                context.read<AppBloc>().add(
                      AppEventGoogleLogin(),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}