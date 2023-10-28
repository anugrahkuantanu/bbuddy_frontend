class Message {
  late String _text;
  late bool _isBot;
  final bool isWaiting;
  String? _id;
  List<String>? options;

  String get text => _text;
  bool get isBot => _isBot;
  String? get id => _id;

  set text(String text) {
    var newOptions = _parseOptions(text);
    if (newOptions != null) {
      options = [...?options, ...newOptions];
    }
    _text = _stripOptions(text);
  }

  set isBot(bool isBot) {
    _isBot = isBot;
  }

  set isWaiting(bool isWaiting) {
    isWaiting = isWaiting;
  }

  set id(String? id) {
    _id = id;
  }

  Message({
    required String text,
    required bool isBot,
    this.isWaiting = false,
    String? id,
  })  : options = _parseOptions(text),
        _text = _stripOptions(text) {
    //_text = text;
    _isBot = isBot;
    _id = id;
  }

  static List<String>? _parseOptions(String text) {
    RegExp regExp = RegExp(r'- <button>(.*?)<\/button>');
    Iterable<RegExpMatch> matches = regExp.allMatches(text);
    if (matches.isNotEmpty) {
      return matches.map((match) => match.group(1)!).toList();
    }
    return null;
  }

  static String _stripOptions(String text) {
    String strippedText = text
        .replaceAll(RegExp(r'- <button>(.*?)<\/button>'), '')
        .replaceAll(RegExp(r'- <technique>(.*?)<\/technique>'), '');
    strippedText = strippedText.replaceAll(RegExp(r'\n{2,}'), '\n');
    return strippedText;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    //String text =
    return Message(text: json["data"]["content"], isBot: json["type"] == "ai");
  }
}
