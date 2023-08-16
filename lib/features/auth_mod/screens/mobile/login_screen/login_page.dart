import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../main_app/utils/helpers.dart';
// import '../login_screen/forgot_password_page.dart';
import '../login_screen/profile_page.dart';
import '../login_screen/registration_page.dart';
import '../login_screen/widgets/header_widget.dart';
// import 'package:Bbuddy/app.dart';
import 'package:provider/provider.dart';
import '../../../services/login.dart';
import 'package:dio/dio.dart';
import '../../../../../app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> loginController = {
    'username': TextEditingController(),
    'password': TextEditingController(),
  };
  bool usernameExist = true;
  bool correctPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: _headerHeight,
            //   child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
            // ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                     Container(
                  // height: 15.0,
                  // width: 150.0,
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
                              // Container( 
                              //   margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                              //   alignment: Alignment.topRight,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       Navigator.push( .  /////####/"this is the forgot password page "
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 ForgotPasswordPage()),
                              //       );
                              //     },
                              //     child: Text(
                              //       "Forgot your password?",
                              //       style: TextStyle(
                              //         color: Colors.grey,
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "Don\'t have an account? "),
                                  TextSpan(
                                    text: 'Create',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer),
                                  ),
                                ])),
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
