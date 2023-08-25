import '../models/model.dart';

const String GENERAL_ERROR_MESSAGE = 'Something went wrong, please try again later.';

List<CheckIn> parseCheckInList(List jsonList) {
  return List.generate(jsonList.length ~/ 2, (index) {
    int startIndex = index * 2;
    return CheckIn(
      humanMessage: Message(
        text: jsonList[startIndex]["data"]["content"],
        isBot: jsonList[startIndex]["type"] == "ai",
      ),
      aiMessage: Message(
        text: jsonList[startIndex + 1]["data"]["content"],
        isBot: jsonList[startIndex]["type"] == "ai",
      ),
    );
  });
}
