import 'package:flutter/material.dart';

abstract class ReflectionHomeEvent {}

class LoadReflectionHome extends ReflectionHomeEvent {}

class CreateNewReflectionEvent extends ReflectionHomeEvent {
  final BuildContext context;
  
  CreateNewReflectionEvent(this.context);
}
