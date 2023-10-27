import 'package:bbuddy_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';



class MyIntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "This is the first page of the introduction screen.",
          image: Center(child: Icon(Icons.star, size: 175.0, color: Colors.blue)),
        ),
        PageViewModel(
          title: "Explore",
          body: "Explore various features of the app.",
          image: Center(child: Icon(Icons.explore, size: 175.0, color: Colors.green)),
        ),
        PageViewModel(
          title: "Get Started",
          body: "Let's get started!",
          image: Center(child: Icon(Icons.thumb_up, size: 175.0, color: Colors.red)),
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

// class NextPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Next Page')),
//       body: Center(child: Text('Welcome to the next page!')),
//     );
//   }
// }
