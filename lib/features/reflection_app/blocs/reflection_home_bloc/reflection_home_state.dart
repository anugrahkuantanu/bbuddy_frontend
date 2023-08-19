import '../../models/model.dart';

abstract class ReflectionHomeState {}

class ReflectionHomeInitial extends ReflectionHomeState {}

class ReflectionHomeLoading extends ReflectionHomeState {}

class ReflectionHomeInsufficientCheckIns extends ReflectionHomeState {}

class ReflectionHomeHasEnoughCheckIns extends ReflectionHomeState {
  final List<Reflection> history; // Assuming Reflection is a model class for your reflection data.

  ReflectionHomeHasEnoughCheckIns(this.history);
}

class ReflectionHomeError extends ReflectionHomeState {
  final String errorMessage;
  ReflectionHomeError(this.errorMessage);
}