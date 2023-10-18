// Events
import 'package:flutter/foundation.dart';

@immutable
abstract class ChatEvent {}

class ChatInitialEvent extends ChatEvent {
  final String goalId;

  ChatInitialEvent({
    required this.goalId,
  });
}

class StartChatEvent extends ChatEvent {
  final int dotsPosition;
  StartChatEvent({required this.dotsPosition});
}

class StreamChatEvent extends ChatEvent {
  //final String message;
  //StreamChatEvent(this.message);
}

class EndChatEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent(this.message);
}

class IncomingMessageEvent extends ChatEvent {
  final dynamic messageType;
  final dynamic message;
  final dynamic sender;

  IncomingMessageEvent({
    required this.messageType,
    required this.message,
    required this.sender,
  });
}

class LoadMoreMessagesEvent extends ChatEvent {
  final String goalId;

  LoadMoreMessagesEvent({
    required this.goalId,
  });
}