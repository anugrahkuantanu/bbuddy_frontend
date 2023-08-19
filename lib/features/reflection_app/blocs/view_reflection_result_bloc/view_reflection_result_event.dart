import '../../models/model.dart';

abstract class ReflectionResultEvent {}

class LoadMoodReflections extends ReflectionResultEvent {
  final List topics;
  final List? userReflections;
  final String heading;
  final Reflection? reflection;

  LoadMoodReflections(this.topics, this.userReflections, this.heading, this.reflection);
}
