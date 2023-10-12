import '../../models/model.dart';

abstract class ReflectionHomeState {}

class ReflectionHomeInitial extends ReflectionHomeState {}

class ReflectionHomeLoading extends ReflectionHomeState {}

class ReflectionHomeInsufficientCheckIns extends ReflectionHomeState {
  final int neededCheckInCount;
  ReflectionHomeInsufficientCheckIns({required this.neededCheckInCount});
}

class ReflectionHomeHasEnoughCheckIns extends ReflectionHomeState {
  final List<Reflection>
      history; // Assuming Reflection is a model class for your reflection data.
  ReflectionHomeHasEnoughCheckIns(this.history);
}

class ReflectionHomeError extends ReflectionHomeState {
  final String errorMessage;
  ReflectionHomeError(this.errorMessage);
}

// The state to navigate to the new reflection page.
class NavigateToNewReflectionPage extends ReflectionHomeState {
  final List<dynamic>
      reflectionTopics; // Assuming this is the data type you want to pass.
  NavigateToNewReflectionPage(this.reflectionTopics);
}

class NeedsMoreCheckIns extends ReflectionHomeState {}



// import '../../../models/model.dart';

// abstract class ReflectionHomeState {}

// class ReflectionHomeInitial extends ReflectionHomeState {}

// class ReflectionHomeLoading extends ReflectionHomeState {}

// class ReflectionHomeInsufficientCheckIns extends ReflectionHomeState {
//   String errorMessage;
//   ReflectionHomeInsufficientCheckIns({required this.errorMessage});
// }

// class ReflectionHomeHasEnoughCheckIns extends ReflectionHomeState {
//   final List<Reflection> history; // Assuming Reflection is a model class for your reflection data.

//   ReflectionHomeHasEnoughCheckIns(this.history);
// }

// class ReflectionHomeError extends ReflectionHomeState {
//   final String errorMessage;
//   ReflectionHomeError(this.errorMessage);
// }