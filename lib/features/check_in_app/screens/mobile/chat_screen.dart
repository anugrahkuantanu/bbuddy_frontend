import 'dart:async';

import 'package:bbuddy_app/di/di.dart';
import 'package:bbuddy_app/features/main_app/bloc/bloc.dart';

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

  @override
  void initState() {
    super.initState();
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
      print(widget.isPastCheckin);
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

  Future<void> getResponseAndStore() async {
    setState(() {
      isTyping = true;
    });

    final response = await checkInService.getCheckInResponse(
        widget.feeling, widget.feelingForm, widget.reasonEntity, widget.reason);
    // StreamSubscription<dynamic>? subscription =
    //     test?.listen((event) => setState(() {
    //           print(event);
    //           return messages.add(Message(text: event, isBot: true));
    //         }));

    //messages.add(
    //    Message(text: test?.map((event) => {event.toString()}), isBot: true));
    // final response = await checkInService.getCheckInResponse(
    //     widget.feeling, widget.feelingForm, widget.reasonEntity, widget.reason);

    setState(() {
      List<String> responseMessages = response.split("\n\n");
      isTyping = false;
      showProgressIndicator = false; // Hide the progress indicator
      for (int i = 0; i < responseMessages.length; i++) {
        messages.add(
          Message(
            text: responseMessages[i],
            isBot: true,
          ),
        );
      }
    });

    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        showButtons = true;
        if (!showExitButton) {
          showExitButton = true;
        }
      });
    });

    checkInService.storeCheckIn(widget.feeling, widget.feelingForm,
        widget.reasonEntity, widget.reason, response);

    final counterStats = Provider.of<CounterStats>(context, listen: false);
    counterStats.updateCheckInCounter();
    context.read<CheckInHistoryBloc>().add(FetchCheckInHistoryEvent());
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
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (showProgressIndicator) // Display CircularProgressIndicator if showProgressIndicator is true
                      const Center(
                        child: CircularProgressIndicator(),
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
