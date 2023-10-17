import 'dart:async';
import 'package:bbuddy_app/core/core.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
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

// States
@immutable
abstract class ChatState {}

class LoadingState extends ChatState {}

class InitialChatState extends ChatState {}

class MessagesUpdated extends ChatState {
  MessagesUpdated();
}

class WaitingForResponse extends ChatState {
  final int dotsPosition;
  WaitingForResponse({required this.dotsPosition});
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

// In ChatBloc:
class LoadMoreMessagesEvent extends ChatEvent {
  final String goalId;

  LoadMoreMessagesEvent({
    required this.goalId,
  });
}

// Add LoadingMoreState
class LoadingMoreState extends ChatState {}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Message?> messages = [];
  final int pageSize = 10;
  int currentPage = 1;
  bool isLoadingHistory = false;
  Chat? chat;

  ChatBloc(String goalId) : super(InitialChatState()) {
    chat = Chat(
      endpoint: 'ws/$goalId',
      onMessageReceived: _handleIncomingMessage,
      onConnectionError: _handleConnectionError,
      onConnectionSuccess: _handleConnectionSuccess,
    );

    on<ChatInitialEvent>(_chatInitialEvent);
    on<SendMessageEvent>(_sendMessageEvent);
    on<EndChatEvent>(_endChatEvent);
    on<StartChatEvent>(_startChatEvent);
    on<LoadMoreMessagesEvent>(_loadMoreMessagesEvent);
    on<StreamChatEvent>(_streamChatEvent);
  }

  Future<void> _chatInitialEvent(
      ChatInitialEvent event, Emitter<ChatState> emit) async {
    emit(LoadingMoreState());
    isLoadingHistory = true;
    try {
      final fetchedMessages =
          await fetchChatHistory(event.goalId, currentPage, pageSize).first;
      if (fetchedMessages.isNotEmpty) {
        messages.insertAll(0, fetchedMessages.reversed);
      }
      currentPage++;
      emit(MessagesUpdated());
    } catch (error) {
      emit(ErrorState('Error fetching chat history: $error'));
    }
    emit(InitialChatState());
    isLoadingHistory = false;
    add(StartChatEvent(dotsPosition: 0));
  }

  Future<void> _sendMessageEvent(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(Message(text: event.message, isBot: false));
    messages.add(Message(text: '', isBot: true, isWaiting: true));
    chat?.sendMessage(event.message);
    emit(MessagesUpdated());
  }

  void _startChatEvent(StartChatEvent event, Emitter<ChatState> emit) async {
    int dotsPosition = event.dotsPosition;
    //emit(InitialChatState());
    emit(WaitingForResponse(dotsPosition: dotsPosition));

    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      dotsPosition = (dotsPosition + 1) % 3;
      emit(WaitingForResponse(dotsPosition: dotsPosition));
    }

    //emit(WaitingForResponse());
  }

  Future<void> _loadMoreMessagesEvent(
      LoadMoreMessagesEvent event, Emitter<ChatState> emit) async {
    if (isLoadingHistory) return; // Return if already loading
    emit(LoadingMoreState());

    try {
      final fetchedMessages =
          await fetchChatHistory(event.goalId, currentPage, pageSize).first;
      if (fetchedMessages.isNotEmpty) {
        messages.insertAll(0, fetchedMessages.reversed);
        currentPage++;
        emit(MessagesUpdated());
      }
    } catch (error) {
      emit(ErrorState('Error fetching more chat history: $error'));
    }
  }

  void _endChatEvent(EndChatEvent event, Emitter<ChatState> emit) {
    emit(MessagesUpdated());
  }

  void _streamChatEvent(StreamChatEvent event, Emitter<ChatState> emit) {
    emit(MessagesUpdated());
  }

  void _handleIncomingMessage(
      dynamic messageType, dynamic message, dynamic sender) {
    add(StartChatEvent(dotsPosition: 0));
    int lastIndex = messages.length - 1;
    if (messageType == 'start' && sender == "bot") {
      add(StreamChatEvent());
    } else if (messageType == 'stream' && sender == "bot") {
      if (messages.last!.isWaiting) {
        messages.removeAt(lastIndex);
        messages.insert(
            lastIndex, Message(text: message, isBot: true, isWaiting: false));
      } else {
        messages[lastIndex]!.text += message;
      }
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

  const GoalChatPage({required this.goalId, Key? key}) : super(key: key);

  @override
  _GoalChatPageState createState() => _GoalChatPageState();
}

class _GoalChatPageState extends State<GoalChatPage> {
  late ChatBloc _chatBloc;
  TextEditingController messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late ScrollController _scrollController;
  bool isKeyboardVisible = false;
  int dotsPosition = 0;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(widget.goalId);
    _chatBloc.add(ChatInitialEvent(goalId: widget.goalId));
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels <=
            _scrollController.position.minScrollExtent) {
          _chatBloc.add(LoadMoreMessagesEvent(goalId: widget.goalId));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, 'refresh');
          return false; // Prevents the automatic pop of the current route
        },
        child: BlocProvider(
          create: (context) => _chatBloc,
          child: BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is InitialChatState) {
                  if (_scrollController.hasClients) {
                    Future.delayed(const Duration(milliseconds: 500)).then((_) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    });
                  }
                }
              },
              child: BlocBuilder<ChatBloc, ChatState>(
                bloc: _chatBloc,
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const LoadingUI();
                  } //else if (state is ErrorState) {
                  //return ErrorUI(errorMessage: state.errorMessage);
                  //}
                  return _buildUI(context, state, _chatBloc.messages);
                },
              )),
        ));
  }

  Widget _buildUI(
      BuildContext context, ChatState state, List<Message?> messages) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Coach',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // add your custom icon here
          onPressed: () {
            Navigator.pop(context, 'refresh');
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
              if ((state is LoadingMoreState || _chatBloc.isLoadingHistory) &&
                  messages.isNotEmpty)
                const Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())),
              if (state is ErrorState && messages.isNotEmpty)
                Center(
                  child: Text(
                    'Error: ${(state).errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  // reverse: true,
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    Message? message = messages[index];
                    bool isLastMessage = index == messages.length - 1;
                    bool shouldDisplayDots = isLastMessage &&
                        (message?.text == null || message?.text == '');
                    return Align(
                      alignment: message!.isBot
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                message.isBot ? Colors.grey[300] : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.text,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                if (state is WaitingForResponse &&
                                    shouldDisplayDots)
                                  DotsIndicator(
                                    dotsCount: 3,
                                    position: (state).dotsPosition,
                                    decorator: DotsDecorator(
                                      size: const Size.square(10.0),
                                      activeSize: const Size.square(10.0),
                                      color: Colors.grey,
                                      activeColor: Colors.black,
                                      spacing: const EdgeInsets.all(3.0),
                                      activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                    ),
                                  ),
                              ])),
                    );
                  },
                ),
              ),
              if ((state is LoadingMoreState || _chatBloc.isLoadingHistory) &&
                  messages.isEmpty)
                const Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())),
              if (state is ErrorState && messages.isEmpty)
                Center(
                  child: Text(
                    'Error: ${(state).errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        String message = messageController.text.trim();
                        if (message.isNotEmpty) {
                          _chatBloc.add(SendMessageEvent(message));
                          messageController.clear();
                        }
                      },
                      icon: const Icon(Icons.send),
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
