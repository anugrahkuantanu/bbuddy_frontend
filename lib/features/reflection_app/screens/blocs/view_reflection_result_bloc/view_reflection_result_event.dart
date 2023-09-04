import '../../../models/model.dart';

abstract class ViewReflectionResultEvent {}

class LoadMoodReflections extends ViewReflectionResultEvent {
  final List topics;
  final List? userReflections;
  final String heading;
  final Reflection? reflection;

  LoadMoodReflections(this.topics, this.userReflections, this.heading, this.reflection);
}
