
import 'package:clean_architecture/config/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login_ui.dart';
import '../widgets/header_widget.dart';
import '../blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widget.dart';
import '../../../../../core/core.dart';
import '../screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _bloc = ForgotPasswordBloc();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _bloc.close();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var tm = context.watch<ThemeProvider>();
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordVerificationPage()),
            );
          } else if (state is ForgotPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
        return Scaffold(
            backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
            appBar: AppBar(
            backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
            title: const Text('forgot passwort'),
            actions: actionsMenuLogin(context),
            automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: LoginLogo(),
                  ),
                  SafeArea(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          
                          SizedBox(height: 40.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: ThemeHelper().textInputDecoration("Email", "Enter your email"),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Email can't be empty";
                                      } else if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                  ),
                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                const SizedBox(height: 40.0),
                                Text('We will email you a verification code to check your authenticity.',
                                  style: TextStyle(
                                    color: tm.isDarkMode ? AppColors.textlight: AppColors.textdark,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                  child: 
                                      Button(
                                      label: 'Send',
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _bloc.add(SendForgotPasswordEmail(_emailController.text));
                                        }
                                      },
                                    ),
                                  ),
                                //... Other UI elements you have
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({Key? key}) : super(key: key);

//   @override
//   _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     double _headerHeight = 300;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: _headerHeight,
//                 child: HeaderWidget(_headerHeight, true, Icons.password_rounded),
//               ),
//               SafeArea(
//                 child: Container(
//                   margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
//                   padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                   child: Column(
//                     children: [
//                       Container(
//                         alignment: Alignment.topLeft,
//                         margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Forgot Password?',
//                               style: TextStyle(
//                                   fontSize: 35,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black54
//                               ),
//                               // textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 10,),
//                             Text('Enter the email address associated with your account.',
//                               style: TextStyle(
//                                 // fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black54
//                               ),
//                               // textAlign: TextAlign.center,
//                             ),
//                             SizedBox(height: 10,),
//                             Text('We will email you a verification code to check your authenticity.',
//                               style: TextStyle(
//                                 color: Colors.black38,
//                                 // fontSize: 20,
//                               ),
//                               // textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 40.0),
//                       Form(
//                         key: _formKey,
//                         child: Column(
//                           children: <Widget>[
//                             Container(
//                               child: TextFormField(
//                                 decoration: ThemeHelper().textInputDecoration("Email", "Enter your email"),
//                                 validator: (val){
//                                   if(val!.isEmpty){
//                                     return "Email can't be empty";
//                                   }
//                                   else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
//                                     return "Enter a valid email address";
//                                   }
//                                   return null;
//                                 },
//                               ),
//                               decoration: ThemeHelper().inputBoxDecorationShaddow(),
//                             ),
//                             SizedBox(height: 40.0),
//                             Container(
//                               decoration: ThemeHelper().buttonBoxDecoration(context),
//                               child: ElevatedButton(
//                                 style: ThemeHelper().buttonStyle(),
//                                 child: Padding(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       40, 10, 40, 10),
//                                   child: Text(
//                                     "Send".toUpperCase(),
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   if(_formKey.currentState!.validate()) {
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => ForgotPasswordVerificationPage()),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                             SizedBox(height: 30.0),
//                             Text.rich(
//                               TextSpan(
//                                 children: [
//                                   TextSpan(text: "Remember your password? "),
//                                   TextSpan(
//                                     text: 'Login',
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(builder: (context) => LoginPage()),
//                                         );
//                                       },
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         )
//     );
//   }
// }
