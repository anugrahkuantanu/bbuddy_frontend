import '../../models/model.dart';


abstract class ViewReflectionResultEvent {}

class FetchReflectionHeadingEvent extends ViewReflectionResultEvent {
  final List topics;

  FetchReflectionHeadingEvent(this.topics);
}

class LoadMoodReflectionsEvent extends ViewReflectionResultEvent {
  final List topics;
  final List? userReflections;
  final String heading;
  final Reflection? reflection;

  LoadMoodReflectionsEvent(
    this.topics,
    this.userReflections,
    this.heading,
    this.reflection,
  );
}