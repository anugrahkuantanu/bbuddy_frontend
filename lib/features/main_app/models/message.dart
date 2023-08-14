class Message {
  late String _text;
  late bool _isBot;
  final bool isWaiting;
  String? _id;

  String get text => _text;
  bool get isBot => _isBot;
  String? get id => _id;

  set text(String text) {
    _text = text;
  }

  set isBot(bool isBot) {
    _isBot = isBot;
  }
  
  set isWaiting(bool isWaiting){
    isWaiting = isWaiting;
  }

  set id(String? id){
    _id = id;
  }

  Message({
    required String text,
    required bool isBot,
    this.isWaiting = false,
    String? id,
  }) {
    _text = text;
    _isBot = isBot;
    _id = id; 
  }
}