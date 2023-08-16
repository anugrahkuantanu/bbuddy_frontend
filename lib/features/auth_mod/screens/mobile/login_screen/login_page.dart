// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import '../../screen.dart';
// import 'package:provider/provider.dart';
// import '../../../services/login.dart';
// import 'package:dio/dio.dart';
// import '../../../../../app.dart';
// import '/config/config.dart';
// import '../../../../../core/core.dart';

// class LoginLogo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: ClipOval(
//           child: Image.asset(
//             'assets/images/BBuddy_logo2.png',
//             width: 180,
//             height: 180,
//           ),
//         ),
//       ),
//     );
//   }
// }


// class LoginTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final bool obscureText;
//   final String? Function(String?) validator;
//   final void Function(String) onChanged;

//   LoginTextField({
//     required this.controller,
//     required this.label,
//     required this.hint,
//     this.obscureText = false,
//     required this.validator,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: ThemeHelper().inputBoxDecorationShaddow(),
//       child: TextFormField(
//         controller: controller,
//         decoration: ThemeHelper().textInputDecoration(label, hint),
//         obscureText: obscureText,
//         validator: validator,
//         onChanged: onChanged,
//       ),
//     );
//   }
// }


// class LoginButton extends StatelessWidget {
//   final String label;
//   final void Function() onPressed;

//   LoginButton({required this.label, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: ThemeHelper().buttonBoxDecoration(context),
//       child: ElevatedButton(
//         style: ThemeHelper().buttonStyle().copyWith(
//             backgroundColor: MaterialStateProperty.all<Color>(
//                 Color.fromRGBO(17, 32, 55, 1.0))),
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
//           child: Text(
//             label.toUpperCase(),
//             style: TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }


// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     var tm = context.watch<ThemeProvider>();
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
//         title: const Text(''),
//         actions: actionsMenuLogin(context),
//         automaticallyImplyLeading: false,
//       ),
//       backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Container(
//             padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//             margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
//             child: LoginForm(),
//           ),
//         ),
//       ),
//     );
//   }
// }


// class LoginForm extends StatefulWidget {
//   @override
//   _LoginFormState createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _formKey = GlobalKey<FormState>();

//   final Map<String, TextEditingController> loginController = {
//     'username': TextEditingController(),
//     'password': TextEditingController(),
//   };
//   bool usernameExist = true;
//   bool correctPassword = true;

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           LoginLogo(),
//           SizedBox(height: 20.0),
//           Container(
//             child: TextFormField(
//               controller: loginController['username'],
//               decoration: ThemeHelper().textInputDecoration(
//                   'User Name', 'Enter your user name'),
//               validator: (val) {
//                 if (val!.isEmpty) {
//                   return "Please enter your username";
//                 }
//                 if (!usernameExist) {
//                   return 'The username you entered isn\'t connected to an account';
//                 }
//                 return null;
//               },
//               onChanged: (value) {
//                 setState(() {
//                   usernameExist = true;
//                 });
//               },
//             ),
//             decoration: ThemeHelper().inputBoxDecorationShaddow(),
//           ),
//           SizedBox(height: 30.0),
//           Container(
//             child: TextFormField(
//               controller: loginController['password'],
//               obscureText: true,
//               decoration: ThemeHelper().textInputDecoration(
//                   'Password', 'Enter your password'),
//               validator: (val) {
//                 if (val!.isEmpty) {
//                   return "Please enter your password";
//                 }
//                 if (!correctPassword) {
//                   return 'Incorrect password';
//                 }
//                 return null;
//               },
//               onChanged: (value) {
//                 setState(() {
//                   correctPassword = true;
//                 });
//               },
//             ),
//             decoration: ThemeHelper().inputBoxDecorationShaddow(),
//           ),
//           SizedBox(height: 15.0),
//           LoginButton(
//             label: 'Sign In',
//             onPressed: () async {
//                                     if (_formKey.currentState!.validate()) {
//                                       FormData loginData = FormData();

//                                       loginData.fields.add(MapEntry('username',
//                                           loginController['username']!.text));
//                                       loginData.fields.add(MapEntry('password',
//                                           loginController['password']!.text));

//                                       final errorMessage =
//                                           await loginForAccessToken(loginData);
                                          
//                                       if (errorMessage.isEmpty) {
//                                         UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
//                                         userProvider.CheckLoginStatus();
//                                         Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) => MyApp()));
//                                       } else if (errorMessage.contains(
//                                           'The username you entered isn\'t connected to an account')) {
//                                         usernameExist = false;
//                                         _formKey.currentState!.validate();
//                                       } else if (errorMessage
//                                           .contains('Incorrect password')) {
//                                         correctPassword = false;
//                                         _formKey.currentState!.validate();
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           SnackBar(
//                                             content: Text(errorMessage),
//                                             backgroundColor: Colors.red,
//                                           ),
//                                         );
//                                       }
//                                     }
//                                   },
//           ),
//           SizedBox(height: 15.0),
//           LoginButton(
//             label: 'Sign Up',
//             onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) =>
//                               RegistrationPage()));
//                 },
//           ),
//         ],
//       ),
//     );
//   }


//   @override
//   void dispose() {
//     loginController['username']?.dispose();
//     loginController['password']?.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import '../../screen.dart';
import 'package:provider/provider.dart';
import '../../../services/login.dart';
import 'package:dio/dio.dart';
import '../../../../../app.dart';
import '/config/config.dart';
import '../../../../../core/core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> loginController = {
    'username': TextEditingController(),
    'password': TextEditingController(),
  };
  bool usernameExist = true;
  bool correctPassword = true;
  @override
  Widget build(BuildContext context) {

    var tm = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
        title: const Text(''),
        actions: actionsMenuLogin(context),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                     Container(
                  child: Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/BBuddy_logo2.png', // replace with your logo image path
                        width: 180,
                        height: 180,
                      ),
                    ),
                  ),
                ),
                      SizedBox(height: 20.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
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
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle().copyWith(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromRGBO(17, 32, 55, 1.0))),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Sign In'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
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
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle().copyWith(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromRGBO(17, 32, 55, 1.0))),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Sign up'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage()));
                                      },
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

