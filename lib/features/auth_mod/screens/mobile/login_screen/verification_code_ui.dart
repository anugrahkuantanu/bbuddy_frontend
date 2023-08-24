import 'package:clean_architecture/config/config.dart';
import 'package:clean_architecture/features/auth_mod/screens/widgets/widget.dart';
import 'package:clean_architecture/features/features.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import '../../../../../core/core.dart';
import 'screen.dart';
import '../../blocs/bloc.dart';


class ForgotPasswordVerificationPage extends StatefulWidget {
  const ForgotPasswordVerificationPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordVerificationPageState createState() => _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState extends State<ForgotPasswordVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _bloc = ForgotPasswordVerificationBloc();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _bloc.close();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tm = context.watch<ThemeProvider>();

    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<ForgotPasswordVerificationBloc, ForgotPasswordVerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => ProfilePage()),
                (Route<dynamic> route) => false
            );
          } else if (state is VerificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error))
            );
          } else if (state is PinResent) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThemeHelper().alartDialog("Successful",
                    "Verification code resend successful.",
                    context);
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
            appBar: AppBar(
              backgroundColor: tm.isDarkMode ? AppColors.darkscreen : AppColors.lightscreen[100],
              title: const Text('Verification'),
              actions: actionsMenuLogin(context),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: LoginLogo(),
                    // child: HeaderWidget(300, true, Icons.privacy_tip_outlined),
                  ),
                  SafeArea(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Verification',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: tm.isDarkMode ? AppColors.textlight: AppColors.textdark,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Enter the verification code we just sent you on your email address.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: tm.isDarkMode ? AppColors.textlight: AppColors.textdark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                OTPTextField(
                                  length: 4,
                                  width: 300,
                                  fieldWidth: 50,
                                  style: TextStyle(fontSize: 30),
                                  textFieldAlignment: MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.underline,
                                  onCompleted: (pin) {
                                    _bloc.add(VerifyPinSubmitted(pin));
                                  },
                                ),
                                SizedBox(height: 50.0),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "If you didn't receive a code! ",
                                        style: TextStyle(
                                          color: tm.isDarkMode ? AppColors.textlight: AppColors.textdark,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Resend',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _bloc.add(ResendPinRequested());
                                          },
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40.0),
                                Button(
                                  label: "Verify",
                                  onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _bloc.add(VerifyPinSubmitted(_otpController.text));
                                      }
                                    },
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          );
        },
      ),
    );
  }
}
