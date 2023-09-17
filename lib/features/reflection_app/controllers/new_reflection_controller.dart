import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../screens/mobile/new_reflection_page.dart' as mobile;

class NewReflectionController extends StatelessController {
  final String _title = '';
  final List<dynamic> topics;

  const NewReflectionController({Key? key, required this.topics}) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: mobile.NewReflectionPage(topics: topics,),
    );
  }
}
