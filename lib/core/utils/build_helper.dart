import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/screens/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorUI extends StatelessWidget {
  final String errorMessage;
  final String? title;

  const ErrorUI({Key? key, required this.errorMessage, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(title ?? ""),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
          errorMessage,
          style: Theme.of(context).textTheme.bodyLarge
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
        automaticallyImplyLeading: false,
      ),
            body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
          'Response: $response',
          style: Theme.of(context).textTheme.bodyLarge
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
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              const TextSpan(
                text: 'You need\n\n',
              ),
              TextSpan(
                text: response,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
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
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              const TextSpan(
                text: 'You need\n\n',
              ),
              TextSpan(
                text: response,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class DialogHelper {
  static void showDialogMessage(BuildContext context, {required String message, String title = ''}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title.isNotEmpty ? Text(title) : null,
          content: Text(
            message,
            maxLines: 5,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
