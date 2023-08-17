import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/model.dart';
import '../../../services/login.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../screens/screen.dart';
import 'package:provider/provider.dart';
import '/config/config.dart';
import './widgets/widget.dart';

import '../../../../../core/core.dart';

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
        decoration: ThemeHelper().textInputDecoration(label, hint),
        obscureText: isPassword,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}


class RegistrationBloc {
  
  final registrationController = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'username': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'password': TextEditingController(),
  };

  Future<String> register(UserCreate user) async {
      // Using the `registerUser` function from the provided code to connect to the backend and register the user.
      String errorMessage = await registerUser(user);
      return errorMessage;
  }
}



class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final bloc = RegistrationBloc();
  bool isRegistering = false;
  bool isEmailAlreadyRegistered = false;
  bool isUsernameAlreadyRegistered = false;
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        actions: actionsMenuLogin(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: 'First Name*',
                  hint: 'Enter your first name',
                  controller: bloc.registrationController['firstName']!,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your first name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Last Name*',
                  hint: 'Enter your last name',
                  controller: bloc.registrationController['lastName']!,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your last name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Username*',
                  hint: 'Enter your username',
                  controller: bloc.registrationController['username']!,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your username";
                    }
                    if (isUsernameAlreadyRegistered) {
                      return 'Username is already registered';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Email*',
                  hint: 'Enter your email',
                  controller: bloc.registrationController['email']!,
                  validator: (val) {
                      if (val!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                              .hasMatch(val)) {
                        return "Enter a valid email address";
                      }
                      if (isEmailAlreadyRegistered) {
                        return 'Email address is already registered';
                      }
                      return null;
                    },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Phone',
                  hint: 'Enter your phone number',
                  controller: bloc.registrationController['phone']!,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Password*',
                  hint: 'Enter your password',
                  controller: bloc.registrationController['password']!,
                  isPassword: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    FormField<bool>(
                      builder: (state) {
                        return Checkbox(
                          value: checkboxValue,
                          onChanged: (value) {
                            setState(() {
                              checkboxValue = value!;
                              state.didChange(value);
                            });
                          },
                        );
                      },
                      validator: (value) {
                        if (!checkboxValue) {
                          return 'You need to accept terms and conditions';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          const url = 'http://bbuddy.ai/privacy';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Text(
                          "I accept all terms and conditions.",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Button(
                  label: isRegistering ? "Loading..." : "REGISTER",
                  onPressed: () async {
                    setState(() {
                      isRegistering = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      final newUser = UserCreate(
                        firstName: bloc.registrationController['firstName']!.text,
                        lastName: bloc.registrationController['lastName']!.text,
                        username: bloc.registrationController['username']!.text,
                        email: bloc.registrationController['email']!.text,
                        phone: bloc.registrationController['phone']!.text,
                        password: bloc.registrationController['password']!.text,
                      );
                      final response = await bloc.register(newUser);
                      if (response.isEmpty) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false,
                          );
                      } else {
                          if (response.contains('Email already registered')) {
                              setState(() {
                                  isEmailAlreadyRegistered = true;
                              });
                          } else if (response.contains('Username already registered')) {
                              setState(() {
                                  isUsernameAlreadyRegistered = true;
                              });
                          }
                          _formKey.currentState!.validate();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(response),
                                  backgroundColor: Colors.red,
                              ),
                          );
                          }
                      setState(() {
                        isRegistering = false;
                      });
                    } else {
                      setState(() {
                        isRegistering = false;
                      });
                    }
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
