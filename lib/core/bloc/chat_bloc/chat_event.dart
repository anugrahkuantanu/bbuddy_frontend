// Events
import 'package:flutter/foundation.dart';

@immutable
abstract class ChatEvent {}

class StartChatEvent extends ChatEvent {
  final int dotsPosition;
  StartChatEvent({required this.dotsPosition});
}
