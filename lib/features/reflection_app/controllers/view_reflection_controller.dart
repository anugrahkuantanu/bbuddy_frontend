import 'package:flutter/material.dart';

import '../models/model.dart';
import '../../../core/core.dart';
import '../screens/mobile/view_reflection_results.dart' as mobile;

class ViewReflectionController extends StatelessController {
  final String _title = '';
  final List topics;
  final List? userReflections;
  final Reflection? reflection;

  const ViewReflectionController({
    Key? key,
    required this.topics,
    this.userReflections,
    this.reflection,
  }) : super(key: key);

  @override
  bool get auth => false;

  @override
  Display view(BuildContext context) {
    return Display(
      title: _title,
      mobile: mobile.ViewReflectionResults(
        topics: topics, 
        userReflections: userReflections,
        reflection: reflection,),
    );
  }
}
