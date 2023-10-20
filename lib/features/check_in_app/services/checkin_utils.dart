import 'package:bbuddy_app/features/check_in_app/models/model.dart';
import 'package:bbuddy_app/core/models/message.dart';

// ignore: constant_identifier_names
const String GENERAL_ERROR_MESSAGE =
    'Something went wrong, please try again later.';

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
