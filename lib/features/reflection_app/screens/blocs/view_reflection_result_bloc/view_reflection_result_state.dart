import '../../../models/model.dart';

abstract class ReflectionResultState {}

class ReflectionResultInitial extends ReflectionResultState {}

class ReflectionResultLoading extends ReflectionResultState {}

class ReflectionResultLoaded extends ReflectionResultState {
  final Reflection reflection;

  ReflectionResultLoaded(this.reflection);
}

class ReflectionResultError extends ReflectionResultState {}

