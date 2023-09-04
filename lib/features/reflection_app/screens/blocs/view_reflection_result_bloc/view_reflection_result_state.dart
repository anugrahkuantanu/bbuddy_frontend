import '../../../models/model.dart';

abstract class ViewReflectionResultState {}

class ReflectionResultInitial extends ViewReflectionResultState {}

class ReflectionResultLoading extends ViewReflectionResultState {}

class ReflectionResultLoaded extends ViewReflectionResultState {
  final Reflection reflection;

  ReflectionResultLoaded(this.reflection);
}

class ReflectionResultError extends ViewReflectionResultState {}

