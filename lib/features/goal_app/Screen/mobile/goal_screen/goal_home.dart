import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class GoalHome extends StatefulWidget {
  final String? title;
  const GoalHome({Key? key, this.title}) : super(key: key);

  @override
  State<GoalHome> createState() => _GoalHomeState();
}

class _GoalHomeState extends State<GoalHome> {
  late TextEditingController _name;
  late String display;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: 'Guest');
    display = 'About Page';
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Default Title'),

        actions: actionsMenu(context),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(display),
            Center(
              child: EditableText(
                textAlign: TextAlign.center,
                controller: _name,
                focusNode: FocusNode(),
                style: TextStyle(
                  color: theme.textTheme.bodyText1!.color,
                  fontSize: 20,
                ),
                cursorColor: theme.textTheme.bodyText1!.color!,
                backgroundCursorColor: Colors.yellowAccent,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  display = 'Welcome ' + _name.text.toString();
                });
              },
              child: const Text('Welcome'),
            ),
            ElevatedButton(
              onPressed: () {
                Nav.to(context, '/');
              },
              child: const Text('Goto Home Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Nav.to(context, '/contact');
              },
              child: const Text('Goto Contact Page'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
