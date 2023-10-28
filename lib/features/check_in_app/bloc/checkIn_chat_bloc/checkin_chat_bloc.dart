import 'package:bbuddy_app/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bbuddy_app/core/bloc/bloc.dart';

import 'package:bbuddy_app/features/check_in_app/bloc/bloc.dart';

class CheckinChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Message?> messages = [];
  Chat? chat;

  CheckinChatBloc() : super(InitialChatState()) {
    // chat = Chat(
    //   endpoint: 'ws/$goalId',
    //   onMessageReceived: _handleIncomingMessage,
    //   onConnectionError: _handleConnectionError,
    //   onConnectionSuccess: _handleConnectionSuccess,
    // );
    on<CheckinChatInitialEvent>(_checkinChatInitialEvent);
    on<StartChatEvent>(_startChatEvent);
  }

  Future<void> _checkinChatInitialEvent(
      CheckinChatInitialEvent event, Emitter<ChatState> emit) async {
    messages = [
      Message(
        text: "How are you feeling?",
        isBot: true,
      ),
      Message(
        text:
            "I am feeling ${event.feeling?.toLowerCase()} and ${event.feelingForm?.toLowerCase()} about my ${event.reasonEntity?.toLowerCase()}",
        isBot: false,
      ),
      Message(
        text: event.reason!,
        isBot: false,
      ),
    ];
    if (event.isPastCheckin == true) {
      messages.add(
        Message(
          text: event.aiResponse ?? '',
          isBot: true,
        ),
      );
      emit(InitialChatState());
    } else {
      emit(InitialChatState());
      getResponseAndStore(event);
      add(StartChatEvent(dotsPosition: 0));
    }
    // emit(LoadingMoreState());
    // isLoadingHistory = true;
    // try {
    //   final fetchedMessages =
    //       await fetchChatHistory(event.goalId, currentPage, pageSize).first;
    //   if (fetchedMessages.isNotEmpty) {
    //     messages.insertAll(0, fetchedMessages.reversed);
    //   }
    //   currentPage++;
    //   emit(MessagesUpdated());
    // } catch (error) {
    //   emit(ErrorState('Error fetching chat history: $error'));
    // }
    // emit(InitialChatState());
    // isLoadingHistory = false;
    // add(StartChatEvent(dotsPosition: 0));
  }

  Future<void> getResponseAndStore(event) async {
    chat = Chat(
      endpoint: 'checkin',
      onMessageReceived: _handleIncomingMessage,
      onConnectionError: _handleConnectionError,
      onConnectionSuccess: () {
        // Consider creating a new event for this action or handling it differently.
        chat?.sendJson({
          'feeling': event.feeling,
          'feeling_form': event.feelingForm,
          'reason_entity': event.reasonEntity,
          'reason': event.reason
        });
      },
    );

    messages.add(Message(text: '', isBot: true, isWaiting: true));
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

  void _handleIncomingMessage(
      dynamic messageType, dynamic message, dynamic sender) async {
    add(StartChatEvent(dotsPosition: 0));
    int lastIndex = messages.length - 1;

    void _addMessageToStream(String message) {
      if (messages.last!.isWaiting) {
        messages.removeAt(lastIndex);
        messages.insert(
            lastIndex, Message(text: message, isBot: true, isWaiting: false));
      } else {
        messages[lastIndex]?.text += message;
      }
    }

    if (messageType == 'start' && sender == "bot") {
      if (!messages[lastIndex]!.isWaiting) {
        messages.add(Message(text: '', isBot: true, isWaiting: true));
      }
    } else if (messageType == 'stream' && sender == "bot") {
      RegExp exp = RegExp(r'- <button>(.*?)<\/button>');
      RegExp tExp = RegExp(r'- <technique>(.*?)<\/technique>');
      if (exp.hasMatch(message)) {
        var matches = exp.allMatches(message).toList();
        var buttonStartIndex = matches.first.start;
        var beforeButton = message.substring(0, buttonStartIndex);
        var buttonString = message.substring(buttonStartIndex);

        for (var i = 0; i < beforeButton.length; i++) {
          var chunk = beforeButton.substring(i, i + 1);
          _addMessageToStream(chunk);
          await Future.delayed(
              const Duration(milliseconds: 1)); // Delay for 0.1 second
        }
        _addMessageToStream(buttonString);
      }
      if (tExp.hasMatch(message)) {
        var matches = tExp.allMatches(message).toList();
        // ignore: unused_local_variable
        var tList = matches.map((match) => match.group(1)!).toList();

        //technique = tList[0];
      } else {
        _addMessageToStream(message);
      }
    } else if (messageType == 'end' && sender == 'bot') {
      // await checkInService.storeCheckIn(widget.feeling, widget.feelingForm,
      //     widget.reasonEntity, widget.reason, messages[lastIndex].text);
      // final counterStats = Provider.of<CounterStats>(context, listen: false);
      // counterStats.updateCheckInCounter();

      // context.read<CheckInHistoryBloc>().add(FetchCheckInHistoryEvent());

      // final bloc = context.read<ReflectionHomeBloc>();
      // if (bloc.state is ReflectionHomeInsufficientCheckIns) {
      //   final state = bloc.state as ReflectionHomeInsufficientCheckIns;
      //   bloc.add(UpdateNeedCheckInCount(
      //       neededCheckInCount: state.neededCheckInCount - 1));
      //}
      //add(EndChatEvent());
    }
    //_scrollToBottom();
  }

  void _handleConnectionError(dynamic error) {
    // Consider creating a new event for this action or handling it differently.
  }
}
