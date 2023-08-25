import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../../../../../../app.dart';
import '../../widgets/widget.dart';
import '../../../services/service.dart';
import '../../screen.dart';
import '/core/utils/utils.dart';

class LoginFormBloc extends StatefulWidget {
  @override
  _LoginFormBlocState createState() => _LoginFormBlocState();
}

class _LoginFormBlocState extends State<LoginFormBloc> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> loginController = {
    'username': TextEditingController(),
    'password': TextEditingController(),
  };
  bool usernameExist = true;
  bool correctPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LoginLogo(),
          SizedBox(height: 20.0),
          Container(
            child: TextFormField(
              controller: loginController['username'],
              decoration: ThemeHelper().textInputDecoration(
                  'User Name', 'Enter your user name'),
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please enter your username";
                }
                if (!usernameExist) {
                  return 'The username you entered isn\'t connected to an account';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  usernameExist = true;
                });
              },
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          SizedBox(height: 30.0),
          Container(
            child: TextFormField(
              controller: loginController['password'],
              obscureText: true,
              decoration: ThemeHelper().textInputDecoration(
                  'Password', 'Enter your password'),
              validator: (val) {
                if (val!.isEmpty) {
                  return "Please enter your password";
                }
                if (!correctPassword) {
                  return 'Incorrect password';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  correctPassword = true;
                });
              },
            ),
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
          ),
          SizedBox(height: 15.0),
          Button(
            label: 'Sign In',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                FormData loginData = FormData();

                loginData.fields.add(MapEntry('username',
                    loginController['username']!.text));
                loginData.fields.add(MapEntry('password',
                    loginController['password']!.text));

                final errorMessage =
                    await loginForAccessToken(loginData);
                    
                if (errorMessage.isEmpty) {
                  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                  userProvider.CheckLoginStatus();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyApp()));
                } else if (errorMessage.contains(
                    'The username you entered isn\'t connected to an account')) {
                  usernameExist = false;
                  _formKey.currentState!.validate();
                } else if (errorMessage
                    .contains('Incorrect password')) {
                  correctPassword = false;
                  _formKey.currentState!.validate();
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          SizedBox(height: 15.0),
          Button(
            label: 'Sign Up',
            onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegistrationPage()));
                },
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    loginController['username']?.dispose();
    loginController['password']?.dispose();
    super.dispose();
  }
}