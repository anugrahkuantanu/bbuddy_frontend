import 'package:flutter/material.dart';

abstract class ReflectionHomeEvent {}

class InitializeReflectionHomeEvent extends ReflectionHomeEvent {}

class CreateNewReflectionEvent extends ReflectionHomeEvent {
  final BuildContext context;
  
  CreateNewReflectionEvent(this.context);
}
