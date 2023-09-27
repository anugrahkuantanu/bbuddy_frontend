import 'package:bbuddy_app/core/models/message.dart';

// class CheckIn{
//   final Message humanMessage;
//   final Message aiMessage;

//   CheckIn({
//     required this.humanMessage,
//     required this.aiMessage,
//    });

// }

class CheckIn {
  final String id;
  final String userId;
  final DateTime createTime;
  final List<Message> messages;

  CheckIn({
    required this.id,
    required this.userId,
    required this.createTime,
    required this.messages,
  });
}
