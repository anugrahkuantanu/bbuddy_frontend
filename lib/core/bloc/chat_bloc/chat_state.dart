import 'package:flutter/foundation.dart';

@immutable
abstract class ChatState {}

class InitialChatState extends ChatState {}

class WaitingForResponse extends ChatState {
  final int dotsPosition;
  WaitingForResponse({required this.dotsPosition});
}

class LoadingState extends ChatState {}
