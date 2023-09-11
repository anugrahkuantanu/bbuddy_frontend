import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/screens/screen.dart';
import 'package:flutter/material.dart';

class ErrorUI extends StatelessWidget {
  final String errorMessage;
  final String? title;

  const ErrorUI({Key? key, required this.errorMessage, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(title ?? ""),
        automaticallyImplyLeading: true,
      ),
            body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
          'Error: $errorMessage',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class GoalCreatedThisWeek extends StatelessWidget {
  final String response;
  final String? title;

  const GoalCreatedThisWeek ({Key? key, required this.response, this.title}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(title ?? ""),
        automaticallyImplyLeading: true,
      ),
            body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
          'Response: $response',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class NotEnoughtReflection extends StatelessWidget {
  final String response;
  final String? title;

  const NotEnoughtReflection({Key? key, required this.response, this.title}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(title ?? ""),
        automaticallyImplyLeading: false,
        leading: IconButton(
        icon: const Icon(Icons.arrow_back), // add your custom icon here
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoalHome()),
        );
       },
      ),
      ),
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'You need\n\n',
              ),
              TextSpan(
                text: response,
                style: TextStyle(
                  fontSize: 52.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                text: '\n\nReflection(s) to create the generated goals',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class NotEnoughtCheckIn extends StatelessWidget {
  final String response;
  final String? title;

  NotEnoughtCheckIn({required this.response, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(title ?? ""),
        automaticallyImplyLeading: false,
      ),
            body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'You need\n\n',
              ),
              TextSpan(
                text: response,
                style: TextStyle(
                  fontSize: 52.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                text: '\n\nCheck-in(s) to generate the reflections',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class LoadingUI extends StatelessWidget {
  final String? title;

  LoadingUI({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(title ?? ""),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
