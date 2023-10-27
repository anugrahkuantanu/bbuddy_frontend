import 'package:bbuddy_app/core/classes/classes.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


class MyIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      imageFlex: 2,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      titlePadding: EdgeInsets.only(top: 0, bottom: 0.0),
      imagePadding: EdgeInsets.only(top: 70, bottom: 0.0),
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "",
          body: "Homescreen, here you can see not only the checkin and reflection counter, but also last 4 check-in history",
          image: Center(child: Image.asset('assets/intro/intro1.png', width: 300.0)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Profilpage, here will find all your information, and you can also change color theme, delete account and logout",
          image: Center(child: Image.asset('assets/intro/intro2.png', width: 300.0)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Check-in. In this screen you can do checkin, and tell the bot about how are you feeling",
          image: Center(child: Image.asset('assets/intro/intro3.png', width: 300.0)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Reflections. After created 3 checkins, you can create 1 reflection with push + button. And at the screen you can find reflection card.",
          image: Center(child: Image.asset('assets/intro/intro4.png', width: 300.0)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Goals. After 3 reflections, you can create 1 generated goal. Other than that, you can customize until 4 personal goal",
          image: Center(child: Image.asset('assets/intro/intro5.png', width: 300.0)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "If you clicked the goal card, you can can find the milestones, how you can achieve your goal. you can also add, delete and edit the milestones you want.",
          image: Center(child: Image.asset('assets/intro/intro6.png', width: 300.0)),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            // fullScreen: true,
            bodyFlex: 0,
            safeArea: 100,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Coach. You can also discuss with hannah about your goal and ask hannah how the best way you can achieve your goal.",
          image: Center(child: Image.asset('assets/intro/intro7.png', width: 300.0)),
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
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
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
