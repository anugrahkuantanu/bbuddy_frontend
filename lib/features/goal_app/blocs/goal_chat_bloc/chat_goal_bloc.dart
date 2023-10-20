
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/blocs/bloc.dart';
import 'package:bbuddy_app/features/goal_app/services/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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