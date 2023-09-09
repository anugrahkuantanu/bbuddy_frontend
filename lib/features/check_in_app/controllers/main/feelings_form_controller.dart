import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../screens/mobile/feeling_form_page.dart' as mobile;

class FeelingsFormController extends StatefulController {
  final String _title = 'Check-In';
  String feeling;
  Color textColor;

  FeelingsFormController({
    Key? key,
    required this.feeling,
    required this.textColor,
    }) : super(key: key);

  @override
  _CheckInHomeControllerState createState() => _CheckInHomeControllerState();
}

class _CheckInHomeControllerState extends ControllerState<FeelingsFormController> {
  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: widget._title,
      mobile: mobile.FeelingFormPage(
            feeling: widget.feeling,
            textColor: widget.textColor,
            ),
    );
  }
}
