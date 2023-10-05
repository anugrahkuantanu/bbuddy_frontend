import 'package:flutter/material.dart';

abstract class ReflectionEvent {}

class InitializeReflectionHomeEvent extends ReflectionEvent {}

class CreateNewReflectionEvent extends ReflectionEvent {
  final BuildContext context;
  CreateNewReflectionEvent(this.context);
}

class SubmitReflectionEvent extends ReflectionEvent {
  final List<dynamic> topics;
  final List<String> userReflections;
  
  SubmitReflectionEvent({required this.topics, required this.userReflections});
}
