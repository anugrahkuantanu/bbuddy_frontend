import 'package:bbuddy_app/core/classes/classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';


class MyIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      imageFlex: 2,
      bodyPadding: EdgeInsets.fromLTRB(16.0.w, 0.0, 16.0.w, 0.0),
      titlePadding: const EdgeInsets.only(top: 0, bottom: 0.0),
      imagePadding: EdgeInsets.only(top: 70.h, bottom: 0.0),
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "",
          body: "Welcome to bbuddy, where your Journey to mental conciousness begins.",
          image: Center(child: Image.asset('assets/introduction/introduction1.jpeg', width: double.maxFinite,)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Let's create our first checkin, where you will be able tell us about how you are feeling.",
          image: Center(child: Image.asset('assets/introduction/introduction2.jpeg', width: double.maxFinite)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "After understanding how your feeling, Hannah will be able to help you right away ",
          image: Center(child: Image.asset('assets/introduction/introduction3.jpeg', width: double.maxFinite)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: " Lets start reflecting on our thoughts and actions, with the right questoins one will get the right answers he/she seeks.",
          image: Center(child: Image.asset('assets/introduction/introduction4.jpeg', width: double.maxFinite,)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Start working on your goals with ease, just press on the plus sign or let Hannah create a weekly goal for you, which she thinks you need to fix your problems, just press on \"+ Create Goal\" ",
          image: Center(child: Image.asset('assets/introduction/introduction5.jpeg', width: double.maxFinite)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Know how close you are, track your progess.",
          image: Center(child: Image.asset('assets/introduction/introduction6.jpeg', width: double.maxFinite)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Talk with Hannah about your goals and milestones. ",
          image: Center(child: Image.asset('assets/introduction/introduction7.jpeg', width: double.maxFinite)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
      ],
      onDone: () {
        Nav.toNamed(context, '/');
      },
      onSkip: () {
        Nav.toNamed(context, '/');
      },
      showSkipButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Icon(Icons.navigate_next),
      done: const Text("Start", style: TextStyle(fontWeight: FontWeight.w500)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).primaryColor,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
