import 'dart:async';

import 'package:bbuddy_app/di/di.dart';
import 'package:bbuddy_app/features/main_app/bloc/bloc.dart';
import 'package:bbuddy_app/features/reflection_app/blocs/reflection_home_bloc/bloc.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../services/checkin_service.dart';
import 'package:provider/provider.dart';
import 'package:bbuddy_app/core/core.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  final String feeling;
  final String feelingForm;
  final String reasonEntity;
  final String reason;
  bool? isPastCheckin = false;
  final String? aiResponse;
  final Color? textColor;

  ChatScreen(
      {Key? key,
      required this.feeling,
      required this.feelingForm,
      required this.reasonEntity,
      required this.reason,
      this.isPastCheckin,
      this.textColor,
      this.aiResponse})
      : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  late List<Message> messages;
  TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  bool showButtons = false;
  bool showProgressIndicator = true;
  bool screenAtBottom = false;
  bool isScrolledUp = false;
  bool showExitButton = false;
  final checkInService = locator.get<CheckInService>();
  int dotsPosition = 0;
  late Timer? _timer;
  Chat? chat;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        dotsPosition = (dotsPosition + 1) % 3; // Assuming you have 3 dots
      });
    });
    messages = [
      Message(
        text: "How are you feeling?",
        isBot: true,
      ),
      Message(
        text:
            "I am feeling ${widget.feeling.toLowerCase()} and ${widget.feelingForm.toLowerCase()} about my ${widget.reasonEntity.toLowerCase()}",
        isBot: false,
      ),
      Message(
        text: widget.reason,
        isBot: false,
      ),
    ];
    if (widget.isPastCheckin == true) {
      showProgressIndicator = false;
      messages.add(
        Message(
          text: widget.aiResponse ?? '',
          isBot: true,
        ),
      );
    } else {
      getResponseAndStore();
    }
  }

  @override
  void dispose() {
    super.dispose();

    // Cancel the timer in the dispose method
    _timer?.cancel();
  }

  void _handleIncomingMessage(
      dynamic messageType, dynamic message, dynamic sender) async {
    //add(StartChatEvent(dotsPosition: 0));
    int lastIndex = messages.length - 1;
    if (messageType == 'start' && sender == "bot") {
    } else if (messageType == 'stream' && sender == "bot") {
      if (messages.last.isWaiting) {
        setState(() {
          messages.removeAt(lastIndex);
          messages.insert(
              lastIndex, Message(text: message, isBot: true, isWaiting: false));
        });
      } else {
        setState(() {
          messages[lastIndex].text += message;
        });
      }
    } else if (messageType == 'end' && sender == 'bot') {
      await checkInService.storeCheckIn(widget.feeling, widget.feelingForm,
          widget.reasonEntity, widget.reason, messages[lastIndex].text);
      final counterStats = Provider.of<CounterStats>(context, listen: false);
      counterStats.updateCheckInCounter();

      context.read<CheckInHistoryBloc>().add(FetchCheckInHistoryEvent());

      final bloc = context.read<ReflectionHomeBloc>();
      if (bloc.state is ReflectionHomeInsufficientCheckIns) {
        final state = bloc.state as ReflectionHomeInsufficientCheckIns;
        bloc.add(UpdateNeedCheckInCount(
            neededCheckInCount: state.neededCheckInCount - 1));
      }
      //add(EndChatEvent());
    }
  }

  void _handleConnectionError(dynamic error) {
    // Consider creating a new event for this action or handling it differently.
  }

  void _handleConnectionSuccess() {
    // Consider creating a new event for this action or handling it differently.
    chat?.sendJson({
      'feeling': widget.feeling,
      'feeling_form': widget.feelingForm,
      'reason_entity': widget.reasonEntity,
      'reason': widget.reason
    });
  }

  Future<void> getResponseAndStore() async {
    setState(() {
      isTyping = true;
    });
    chat = Chat(
      endpoint: 'checkin',
      onMessageReceived: _handleIncomingMessage,
      onConnectionError: _handleConnectionError,
      onConnectionSuccess: _handleConnectionSuccess,
    );

    messages.add(Message(text: '', isBot: true, isWaiting: true));

    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        showButtons = true;
        if (!showExitButton) {
          showExitButton = true;
        }
      });
    });
  }

  void sendUserMessage(String message) {
    setState(() {
      messages.add(
        Message(
          text: message,
          isBot: false,
        ),
      );
    });
  }

  void navigateBackToHomePage() {
    chat?.closeConnection();
    Nav.toNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(''),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          if (showExitButton ||
              widget.isPastCheckin ==
                  true) // Show the exit button once it appears
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                navigateBackToHomePage();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              setState(() {
                screenAtBottom = true;
                isScrolledUp = false;
              });
            } else if (scrollInfo.metrics.atEdge &&
                scrollInfo.metrics.pixels != 0) {
              setState(() {
                screenAtBottom = true;
                isScrolledUp = false;
              });
            } else {
              setState(() {
                screenAtBottom = false;
                isScrolledUp = true;
              });
            }
            return true;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        Message message = messages[index];
                        bool isLastMessage = index == messages.length - 1;
                        bool shouldDisplayDots = isLastMessage &&
                            message.text == '' &&
                            message.isWaiting;
                        return Align(
                          alignment: message.isBot
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(25, 10, 25,
                                index == messages.length - 1 ? 80 : 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: message.isBot
                                  ? Colors.grey[300]
                                  : Colors.white,
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
                                  if (shouldDisplayDots)
                                    DotsIndicator(
                                      dotsCount: 3,
                                      position: dotsPosition,
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
                                ]),
                          ),
                        );
                      },
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
}
