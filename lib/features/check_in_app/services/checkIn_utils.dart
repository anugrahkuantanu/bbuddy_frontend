import 'dart:convert';

import '../models/model.dart';
import 'package:bbuddy_app/core/models/message.dart';

const String GENERAL_ERROR_MESSAGE =
    'Something went wrong, please try again later.';

// List<CheckIn> parseCheckInList(List jsonList) {
//   return List.generate(jsonList.length ~/ 2, (index) {
//     print("yezz");
//     int startIndex = index * 2;
//     return CheckIn(
//       humanMessage: Message(
//         text: jsonList[startIndex]["data"]["content"],
//         isBot: jsonList[startIndex]["type"] == "ai",
//       ),
//       aiMessage: Message(
//         text: jsonList[startIndex + 1]["data"]["content"],
//         isBot: jsonList[startIndex]["type"] == "ai",
//       ),
//     );
//   });
// }

List<CheckIn> parseCheckInList(List jsonList) {
  return List.generate(jsonList.length, (index) {
    String id = jsonList[index]["id"];
    String userId = jsonList[index]["user_id"];
    DateTime createTime = DateTime.parse(jsonList[index]["create_time"]);
    List<dynamic> messagesJson = jsonList[index]["messages"];
    List<Message> messages = List.generate(messagesJson.length, (mindex) {
      return Message.fromJson(messagesJson[mindex]);
    });
    return CheckIn(
        id: id, userId: userId, createTime: createTime, messages: messages);
  });
}
