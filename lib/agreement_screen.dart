import 'package:bbuddy_app/core/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Agreementscreen extends StatelessWidget {
  const Agreementscreen({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    const kDefaultPadding = 20.0;
    return Scaffold(
      body: 
      Padding(padding: EdgeInsets.symmetric(horizontal: 18),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Text(
                "Welcome to bbuddy",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "Bbuddy is a wellness and coaching platform. Bbuddy does not provide the mediacal and healthcare advices",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.64),
                ),
              ),
              const Spacer(flex: 2,),
              Text.rich(
                TextSpan(
                  text: "By continuing, you agree to the ",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.64),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Terms and Conditions",
                      style: const TextStyle(
                        color: Colors.blue, // Change color to highlight the clickable text
                        decoration: TextDecoration.underline, // Underline the clickable text
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Add your link to the Terms and Conditions here
                          launchUrl(Uri.parse("https://bbuddy.ai/privacy"));
                        },
                    ),
                    const TextSpan(
                      text: " and ",
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: const TextStyle(
                        color: Colors.blue, // Change color to highlight the clickable text
                        decoration: TextDecoration.underline, // Underline the clickable text
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Add your link to the Privacy Policy here
                          launchUrl(Uri.parse("https://bbuddy.ai/privacy"));
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50,),
              FittedBox(
                child: TextButton(
                    onPressed: (){
                    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
                    userRef.update({'firstUser': false});
                    Nav.to(context, '/');
                    },
                    child: Row(
                      children: [
                        Text(
                          "Agree and continue",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!
                                    .withOpacity(0.8),
                              ),
                        ),
                        const SizedBox(width: kDefaultPadding / 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.8),
                        ),
                        SizedBox(height: 100.w),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
