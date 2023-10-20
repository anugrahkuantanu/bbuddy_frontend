import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../screens/mobile/feeling_form_page.dart' as mobile;

// ignore: must_be_immutable
class FeelingsFormController extends StatelessController {
  final String _title = '';
  String feeling;

  FeelingsFormController({
    Key? key,
    required this.feeling,
  }) : super(key: key);

  @override
  bool get auth => true;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: mobile.FeelingFormPage(
        feeling: feeling,
      ),
    );
  }
}
