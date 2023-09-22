import '../../../models/model.dart';




// States (merged)
abstract class ViewReflectionResultState {}

class ReflectionResultInitialState extends ViewReflectionResultState {}

class ReflectionResultLoadingState extends ViewReflectionResultState {}

class ReflectionResultLoadedState extends ViewReflectionResultState {
  final Reflection reflection;

  ReflectionResultLoadedState(this.reflection);
}

class ReflectionHeadingLoadedState extends ViewReflectionResultState {
  final String heading;

  ReflectionHeadingLoadedState(this.heading);
}

class ReflectionResultErrorState extends ViewReflectionResultState {}

class ReflectionHeadingErrorState extends ViewReflectionResultState {
  final String error;

  ReflectionHeadingErrorState(this.error);
}