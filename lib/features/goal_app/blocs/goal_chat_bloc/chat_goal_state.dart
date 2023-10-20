
import 'package:bbuddy_app/core/core.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ChatState {}

class LoadingState extends ChatState {}

class InitialChatState extends ChatState {}

class MessagesUpdated extends ChatState {
  MessagesUpdated();
}

class WaitingForResponse extends ChatState {
  final int dotsPosition;
  WaitingForResponse({required this.dotsPosition});
}

class IncomingMessageState extends ChatState {
  final Message message;

  IncomingMessageState(this.message);
}

class ErrorState extends ChatState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class MessageSentState extends ChatState {}


class LoadingMoreState extends ChatState {}