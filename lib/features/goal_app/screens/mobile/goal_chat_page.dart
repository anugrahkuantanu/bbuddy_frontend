import 'dart:async';
import 'package:bbuddy_app/core/core.dart';
import 'package:flutter/material.dart';
import '../../services/service.dart';
import '../../models/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
@immutable
abstract class ChatEvent {}

class ChatInitialEvent extends ChatEvent {
  final String goalId;
  final int currentPage;
  final int pageSize;

  ChatInitialEvent({
    required this.goalId,
    required this.currentPage,
    required this.pageSize,
  });
}

class StartChatEvent extends ChatEvent {}

class StreamChatEvent extends ChatEvent {
  final String message;
  StreamChatEvent(this.message);
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

// States
@immutable
abstract class ChatState {}

class LoadingState extends ChatState {}

class InitialChatState extends ChatState {}

class ChatIsLoaded extends ChatState {
  final List<Message> messages;

  ChatIsLoaded(this.messages);
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

//bloc

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Message> messages = [];
  final int pageSize = 10;
  int currentPage = 0;
  bool isLoadingHistory = false;

  GoalChat? chat;

  ChatBloc(String goalId) : super(InitialChatState()) {
    chat = GoalChat(
      goalId: goalId,
      onMessageReceived: _handleIncomingMessage,
      onConnectionError: _handleConnectionError,
      onConnectionSuccess: _handleConnectionSuccess,
    );

    on<ChatInitialEvent>(_chatInitialEvent);
    on<SendMessageEvent>(_sendMessageEvent);
    on<IncomingMessageEvent>(_incomingMessageEvent);
    add(ChatInitialEvent(
        goalId: goalId, currentPage: currentPage, pageSize: pageSize));
  }

  Future<void> _chatInitialEvent(
      ChatInitialEvent event, Emitter<ChatState> emit) async {
    emit(LoadingState());

    isLoadingHistory = true;

    try {
      final fetchedMessages = await fetchChatHistory(
              event.goalId, event.currentPage, event.pageSize)
          .first;
      messages.addAll(fetchedMessages.reversed);
      currentPage++;
      print(messages);
      emit(ChatIsLoaded(messages));
    } catch (error) {
      emit(ErrorState('Error fetching chat history: $error'));
    }

    isLoadingHistory = false;
  }

  Future<void> _sendMessageEvent(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(Message(text: event.message, isBot: false));
    messages.add(Message(text: '', isBot: true, isWaiting: true));
    chat?.sendMessage(event.message);
    emit(ChatIsLoaded(messages));
  }

  void _incomingMessageEvent(
      IncomingMessageEvent event, Emitter<ChatState> emit) {
    _handleIncomingMessage(event.messageType, event.message, event.sender);
    emit(ChatIsLoaded(messages));
  }

  void _handleIncomingMessage(
      dynamic messageType, dynamic message, dynamic sender) {
    int lastIndex = messages.length - 1;

    if (messageType == 'start' && sender == "bot") {
      add(StartChatEvent());
    } else if (messageType == 'stream' && sender == "bot") {
      if (messages.last.isWaiting) {
        messages.removeAt(lastIndex);
        messages.insert(
            lastIndex, Message(text: message, isBot: true, isWaiting: false));
      } else {
        messages[lastIndex].text += message;
      }
      add(StreamChatEvent(message));
    } else if (messageType == 'end' && sender == 'bot') {
      add(EndChatEvent());
    }
  }

  void _handleConnectionError(dynamic error) {
    // Consider creating a new event for this action or handling it differently.
  }

  void _handleConnectionSuccess() {
    // Consider creating a new event for this action or handling it differently.
  }

  @override
  Future<void> close() {
    chat?.closeConnection();
    return super.close();
  }
}

class GoalChatPage extends StatefulWidget {
  final String goalId;

  GoalChatPage({required this.goalId, Key? key}) : super(key: key);

  @override
  _GoalChatPageState createState() => _GoalChatPageState();
}

class _GoalChatPageState extends State<GoalChatPage> {
  late ChatBloc _chatBloc;
  TextEditingController messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(widget.goalId);
    _chatBloc.add(
        ChatInitialEvent(goalId: widget.goalId, currentPage: 1, pageSize: 10));
    // _focusNode.addListener(_onFocusChange);
    // _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _chatBloc,
      child: BlocBuilder<ChatBloc, ChatState>(
        bloc: _chatBloc,
        builder: (context, state) {
          if (state is LoadingState) {
            return LoadingUI();
          } else if (state is ChatIsLoaded) {
            return _buildUI(state.messages, context);
          } else if (state is ErrorState) {
            return ErrorUI(errorMessage: state.errorMessage);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildUI(List<Message> messages, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Coach',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // add your custom icon here
          onPressed: () {
            Navigator.pop(context);
          },
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
                  // reverse: true,
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
                          color:
                              message.isBot ? Colors.grey[300] : Colors.white,
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
                          _chatBloc.add(SendMessageEvent(message));
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
    _chatBloc.close();
    super.dispose();
  }

  //   void _onFocusChange() {
  //   setState(() {
  //     isKeyboardVisible = _focusNode.hasFocus;
  //   });

  //   if (isKeyboardVisible) {
  //     Future.delayed(Duration(milliseconds: 300), () {
  //       _scrollToBottom();
  //     });
  //   }
  // }

  // void _scrollToBottom() {
  //   if (_scrollController.hasClients) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: 5),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }

  // void _scrollListener() {
  //   if (_scrollController.position.pixels == _scrollController.position.minScrollExtent &&
  //       !_scrollController.position.outOfRange) {
  //     _chatBloc.add(ChatInitialEvent(goalId: widget.goalId, currentPage: _chatBloc.currentPage + 1, pageSize: 10));
  //   }
  // }
}
