import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../../services/service.dart';
import '../../models/model.dart';

abstract class ChatEvent {}

class FetchChatHistoryEvent extends ChatEvent {
  final int goalId;
  final int currentPage;
  final int pageSize;

  FetchChatHistoryEvent(this.goalId, this.currentPage, this.pageSize);
}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent(this.message);
}

class IncomingMessageEvent extends ChatEvent {
  final dynamic messageType;
  final dynamic message;
  final dynamic sender;

  IncomingMessageEvent(this.messageType, this.message, this.sender);
}

class FetchOldChatHistoryEvent extends ChatEvent {
  final int goalId;
  final int currentPage;
  final int pageSize;

  FetchOldChatHistoryEvent(this.goalId, this.currentPage, this.pageSize);
}






//state

abstract class ChatState {}

class InitialChatState extends ChatState {}

class ChatHistoryFetchedState extends ChatState {
  final List<Message> messages;

  ChatHistoryFetchedState(this.messages);
}

class MessageSentState extends ChatState {}

class IncomingMessageState extends ChatState {
  final Message message;

  IncomingMessageState(this.message);
}

class ErrorState extends ChatState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}


class ConnectionSuccessState extends ChatState {}

class TypingAnimationState extends ChatState {}

class StopTypingAnimationState extends ChatState {}

class ChatStartedState extends ChatState {}

class ChatEndedState extends ChatState {}




//bloc

class ChatBloc {
  StreamController<ChatEvent> _eventController = StreamController<ChatEvent>();
  StreamController<ChatState> _stateController = StreamController<ChatState>.broadcast();

  Sink<ChatEvent> get eventSink => _eventController.sink;
  Stream<ChatState> get stateStream => _stateController.stream;

  List<Message> messages = [];
  final int pageSize = 10;
  int currentPage = 1;
  bool isLoadingHistory = false;
  
  GoalChat? chat;

  ChatBloc(int goalId) {
    _eventController.stream.listen(_mapEventToState);

    chat = GoalChat(
      goalId: goalId,
      onMessageReceived: _handleIncomingMessage,
      onConnectionError: _handleConnectionError,
      onConnectionSuccess: _handleConnectionSuccess,
    );

    // Initial fetch for chat history
    _eventController.sink.add(FetchChatHistoryEvent(goalId, currentPage, pageSize));
  }

void _mapEventToState(ChatEvent event) {
  if (event is FetchChatHistoryEvent) {
    if (isLoadingHistory) return;

    isLoadingHistory = true;

    StreamSubscription<List<Message>> subscription = fetchChatHistory(event.goalId, event.currentPage, event.pageSize).listen((fetchedMessages) {
      messages.addAll(fetchedMessages.reversed);
      _stateController.sink.add(ChatHistoryFetchedState(messages));
      currentPage++;
    });

    subscription.onError((error) {
      _stateController.sink.add(ErrorState('Error fetching chat history: $error'));
      isLoadingHistory = false;
    });

    subscription.onDone(() {
      isLoadingHistory = false;
    });

  } else if (event is SendMessageEvent) {
    messages.add(Message(text: event.message, isBot: false));
    messages.add(Message(text: '', isBot: true, isWaiting: true));
    _stateController.sink.add(MessageSentState());
    chat?.sendMessage(event.message);
  } else if (event is IncomingMessageEvent) {
    // This might be redundant if the chat object sends messages via the same mechanism.
    _handleIncomingMessage(event.messageType, event.message, event.sender);
  }
}


void _handleIncomingMessage(dynamic messageType, dynamic message, dynamic sender) {
    int lastIndex = messages.length - 1;

    if (messageType == 'start' && sender == "bot") {
        // You can handle the start type here. For instance:
        messages.add(Message(text: 'Chat started with bot.', isBot: true, isWaiting: false));
        _stateController.sink.add(ChatStartedState());

    } else if (messageType == 'stream' && sender == "bot") {
        if (messages.last.isWaiting) {
            messages.removeAt(lastIndex);
            messages.insert(lastIndex, Message(text: message, isBot: true, isWaiting: false));
        } else {
            messages[lastIndex].text += message;
        }
        _stateController.sink.add(IncomingMessageState(messages.last));

    } else if (messageType == 'end' && sender == 'bot') {
        // Handle end type. For instance:
        messages.add(Message(text: 'Bot has finished its reply.', isBot: true, isWaiting: false));
        _stateController.sink.add(ChatEndedState());
    }
}


  void _handleConnectionError(dynamic error) {
    _stateController.sink.add(ErrorState('WebSocket connection error: $error'));
  }

  void _handleConnectionSuccess() {
    _stateController.sink.add(ConnectionSuccessState());
  }

  void startTypingAnimation() {
    _stateController.sink.add(TypingAnimationState());
  }

  void stopTypingAnimation() {
    _stateController.sink.add(StopTypingAnimationState());
  }



void _fetchOldChatHistory(int goalId, int currentPage, int pageSize) {
  if (isLoadingHistory) return;

  isLoadingHistory = true;
  final nextPage = currentPage + 1;

  StreamSubscription<List<Message>> subscription = fetchChatHistory(goalId, nextPage, pageSize).listen((fetchedMessages) {
    if (fetchedMessages.isNotEmpty) {
      messages.insertAll(0, fetchedMessages.reversed);
      _stateController.sink.add(ChatHistoryFetchedState(messages));
      this.currentPage = nextPage;
    }
  });

  subscription.onError((error) {
    _stateController.sink.add(ErrorState('Error fetching old chat history: $error'));
    isLoadingHistory = false;
  });

  subscription.onDone(() {
    isLoadingHistory = false;
  });
}



  void dispose() {
    _eventController.close();
    _stateController.close();
    chat?.closeConnection();
  }
}




//UI

class GoalChatScreen extends StatefulWidget {
  final int goalId;

  GoalChatScreen({required this.goalId, Key? key}) : super(key: key);

  @override
  _GoalChatScreenState createState() => _GoalChatScreenState();
}

class _GoalChatScreenState extends State<GoalChatScreen> {
  late ChatBloc _chatBloc;
  List<Message> messages = [];

  TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  double dotsPosition = 0;

  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;

  final ScrollController _scrollController = ScrollController();
  bool incomingMsgInProgress = false;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(widget.goalId);

    _chatBloc.eventSink.add(FetchChatHistoryEvent(widget.goalId, 1, 10));

_chatBloc.stateStream.listen((state) {
  if (state is ChatHistoryFetchedState) {
    setState(() {
      messages.addAll(state.messages.reversed);
      if (messages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  } else if (state is IncomingMessageState) {
    setState(() {
      messages.add(state.message);
      _scrollToBottom();
    });
  } else if (state is MessageSentState) {
    messageController.clear();
    Future.delayed(Duration(seconds: 1), () {
      _scrollToBottom();
    });
  } else if (state is ErrorState) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.errorMessage))
    );
  } else if (state is ConnectionSuccessState) {
    // If you want to notify the user about a successful connection, you can do so here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully connected!'))
    );
  } else if (state is TypingAnimationState) {
    setState(() {
      dotsPosition += 1;
      if (dotsPosition > 2) {
        dotsPosition = 0;
      }
    });
  } else if (state is StopTypingAnimationState) {
    // Handle stopping the typing animation here if needed
  }
});


    _focusNode.addListener(_onFocusChange);
    _scrollController.addListener(_scrollListener);
  }

  void _onFocusChange() {
    setState(() {
      isKeyboardVisible = _focusNode.hasFocus;
    });

    if (isKeyboardVisible) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 5),
      curve: Curves.easeInOut,
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      // User has reached the top, fetch more chat history
      // This will now be handled by sending a new FetchChatHistoryEvent to the ChatBloc
      _chatBloc.eventSink.add(FetchChatHistoryEvent(widget.goalId, _chatBloc.currentPage + 1, 10));
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D425F),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D425F),
        elevation: 0,
        title: Text(
          'Coach',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    Message message = messages[index];
                    return Align(
                      alignment: message.isBot
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: message.isBot
                              ? Colors.grey[300]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Color(0xFF2D425F),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        String message = messageController.text.trim();
                        if (message.isNotEmpty) {
                          _chatBloc.eventSink
                              .add(SendMessageEvent(message));
                          messageController.clear();
                        }
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _chatBloc.dispose();
    super.dispose();
  }
}
