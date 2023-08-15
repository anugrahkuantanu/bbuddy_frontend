import '../login_screen/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login_screen/common/theme_helper.dart';
import '../login_screen/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../models/model.dart';
import '../../../services/login.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> registrationController = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'username': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'password': TextEditingController(),
  };
  bool checkedValue = false;
  bool checkboxValue = false;
  bool isEmailAlreadyRegistered = false;
  bool isUsernameAlreadyRegistered = false;
  bool isRegistering = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D425F),
        elevation: 0,
        title: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFF2D425F),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // GestureDetector(
                        //   child: Stack(
                        //     children: [
                        //       Container(
                        //         padding: EdgeInsets.all(10),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(100),
                        //           border:
                        //               Border.all(width: 5, color: Colors.white),
                        //           color: Colors.white,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.black12,
                        //               blurRadius: 20,
                        //               offset: const Offset(5, 5),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Icon(
                        //           Icons.person,
                        //           color: Colors.grey.shade300,
                        //           size: 80.0,
                        //         ),
                        //       ),
                        //       Container(
                        //         padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                        //         child: Icon(
                        //           Icons.add_circle,
                        //           color: Colors.grey.shade700,
                        //           size: 25.0,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          child: TextFormField(
                            controller: registrationController['firstName'],
                            decoration: ThemeHelper().textInputDecoration(
                                'First Name*', 'Enter your first name'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your first name";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: registrationController['lastName'],
                            decoration: ThemeHelper().textInputDecoration(
                                'Last Name*', 'Enter your last name'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: registrationController['username'],
                            decoration: ThemeHelper().textInputDecoration(
                                'Username*', 'Choose your username'),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a username. You can change this later in your settings";
                              }
                              if (isUsernameAlreadyRegistered) {
                                return 'Username is already registered';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                isUsernameAlreadyRegistered = false;
                              });
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: registrationController['email'],
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail address*", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
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
                            onChanged: (value) {
                              setState(() {
                                isEmailAlreadyRegistered = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: registrationController['phone'],
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number", "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: registrationController['password'],
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password*", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: checkboxValue,
                                      onChanged: (value) {
                                        setState(() {
                                          checkboxValue = value!;
                                          state.didChange(value);
                                        });
                                      },
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        const url = 'http://bbuddy.ai/privacy'; // Replace with your desired URL
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
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
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
                        SizedBox(height: 20.0),
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
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: isRegistering
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "Register".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isRegistering =
                                    true; // Update isRegistering and trigger UI update
                              });
                              if (_formKey.currentState!.validate()) {
                                final newUser = UserCreate(
                                  firstName:
                                      registrationController['firstName']!.text,
                                  lastName:
                                      registrationController['lastName']!.text,
                                  username:
                                      registrationController['username']!.text,
                                  email: registrationController['email']!.text,
                                  phone: registrationController['phone']!.text,
                                  password:
                                      registrationController['password']!.text,
                                );
                                final errorMessage =
                                    await registerUser(newUser);
                                if (errorMessage.isEmpty) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (Route<dynamic> route) => false,
                                  );
                                } else if (errorMessage
                                    .contains('Email already registered')) {
                                  isEmailAlreadyRegistered = true;
                                  _formKey.currentState!.validate();
                                } else if (errorMessage
                                    .contains('Username already registered')) {
                                  isUsernameAlreadyRegistered = true;
                                  _formKey.currentState!.validate();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                              setState(() {
                                isRegistering =
                                    false; // Update isRegistering and trigger UI update
                              });
                            },
                          ),
                        ),
                        /*SizedBox(height: 30.0),
                        Text("Or create account using social media",  style: TextStyle(color: Colors.grey),),
                        SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.googlePlus, size: 35,
                                color: HexColor("#EC2D2F"),),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog("Google Plus","You tap on GooglePlus social icon.",context);
                                    },
                                  );
                                });
                              },
                            ),
                            SizedBox(width: 30.0,),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(width: 5, color: HexColor("#40ABF0")),
                                  color: HexColor("#40ABF0"),
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.twitter, size: 23,
                                  color: HexColor("#FFFFFF"),),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog("Twitter","You tap on Twitter social icon.",context);
                                    },
                                  );
                                });
                              },
                            ),
                            SizedBox(width: 30.0,),
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.facebook, size: 35,
                                color: HexColor("#3E529C"),),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog("Facebook",
                                          "You tap on Facebook social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
          Icons.arrow_back,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF404659)
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
