import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../Screens/mobile/reflection_screen/reflection_home.dart' as mobile;

class ReflectionController extends StatelessController {
  final String _title = 'Reflections';
  const ReflectionController({Key? key}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: mobile.ReflectionHome(
        title: _title,
      ),
    );
  }
}
