import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:bbuddy_app/core/bloc/bloc.dart';
import 'package:bbuddy_app/features/check_in_app/bloc/bloc.dart';
import 'package:bbuddy_app/features/check_in_app/screens/widget/widget.dart';
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
  TextEditingController messageController = TextEditingController();
  late final ScrollController _scrollController = ScrollController();
  late CheckinChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = CheckinChatBloc();
    _chatBloc.add(CheckinChatInitialEvent(
        feeling: widget.feeling,
        feelingForm: widget.feelingForm,
        reasonEntity: widget.reasonEntity,
        reason: widget.reason,
        aiResponse: widget.aiResponse,
        isPastCheckin: widget.isPastCheckin));
    //_scrollController = ScrollController()
    // ..addListener(() {
    //   if (_scrollController.position.pixels <=
    //       _scrollController.position.minScrollExtent) {
    //     _chatBloc.add(LoadMoreMessagesEvent(goalId: widget.goalId));
    //   }
    // });
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
          child: BlocListener<CheckinChatBloc, ChatState>(
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
              child: BlocBuilder<CheckinChatBloc, ChatState>(
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
              // if ((state is LoadingMoreState || _chatBloc.isLoadingHistory) &&
              //     messages.isNotEmpty)
              //   const Center(
              //       child: SizedBox(
              //           height: 20,
              //           width: 20,
              //           child: CircularProgressIndicator())),
              // if (state is ErrorState && messages.isNotEmpty)
              //   Center(
              //     child: Text(
              //       'Error: ${(state).errorMessage}',
              //       style: const TextStyle(color: Colors.red),
              //     ),
              //   ),
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
                            color: message.isBot
                                ? Colors.grey[400]
                                : Colors.grey[100],
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
                                if (message.options != null)
                                  for (var option in message.options!)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5,
                                          top:
                                              5), // Adjust this value to increase or decrease the gap
                                      child: EntityButton(
                                        entity: option,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black,
                                              width:
                                                  1), // Add border conditionally
                                          borderRadius: BorderRadius.circular(
                                              30), // Optional: add border radius
                                        ),
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                        buttonStyle: ThemeHelper()
                                            .buttonStyle()
                                            .copyWith(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.transparent),
                                            ),
                                        onTap: () {
                                          messages.add(Message(
                                              text: option, isBot: false));
                                        },
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
              // if ((state is LoadingMoreState || _chatBloc.isLoadingHistory) &&
              //     messages.isEmpty)
              //   const Center(
              //       child: SizedBox(
              //           height: 20,
              //           width: 20,
              //           child: CircularProgressIndicator())),
              // if (state is ErrorState && messages.isEmpty)
              //   Center(
              //     child: Text(
              //       'Error: ${(state).errorMessage}',
              //       style: const TextStyle(color: Colors.red),
              //     ),
              //   ),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextField(
              //           controller: messageController,
              //           decoration: InputDecoration(
              //             hintText: 'Type your message...',
              //             border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(20),
              //             ),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 10),
              //       IconButton(
              //         onPressed: () {
              //           String message = messageController.text.trim();
              //           if (message.isNotEmpty) {
              //             _chatBloc.add(SendMessageEvent(message));
              //             messageController.clear();
              //           }
              //         },
              //         icon: const Icon(Icons.send),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ChatScreenState extends State<ChatScreen> {
//   late List<Message> messages;
//   TextEditingController messageController = TextEditingController();
//   bool isTyping = false;
//   bool showButtons = false;
//   bool screenAtBottom = false;
//   bool isScrolledUp = false;
//   bool showExitButton = false;
//   final checkInService = locator.get<CheckInService>();
//   int dotsPosition = 0;
//   late Timer? _timer;
//   Chat? chat;
//   final ScrollController _scrollController = ScrollController();
//   String? technique;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       setState(() {
//         dotsPosition = (dotsPosition + 1) % 3; // Assuming you have 3 dots
//       });
//     });
//     messages = [
//       Message(
//         text: "How are you feeling?",
//         isBot: true,
//       ),
//       Message(
//         text:
//             "I am feeling ${widget.feeling.toLowerCase()} and ${widget.feelingForm.toLowerCase()} about my ${widget.reasonEntity.toLowerCase()}",
//         isBot: false,
//       ),
//       Message(
//         text: widget.reason,
//         isBot: false,
//       ),
//     ];
//     if (widget.isPastCheckin == true) {
//       messages.add(
//         Message(
//           text: widget.aiResponse ?? '',
//           isBot: true,
//         ),
//       );
//     } else {
//       getResponseAndStore();
//     }

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // 4. Scroll to bottom once everything is rendered
//       _scrollToBottom();
//     });
//   }

//   _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _scrollController.dispose();
//     // Cancel the timer in the dispose method
//     _timer?.cancel();
//   }

//   void _handleIncomingMessage(
//       dynamic messageType, dynamic message, dynamic sender) async {
//     //add(StartChatEvent(dotsPosition: 0));
//     int lastIndex = messages.length - 1;

//     void _addMessageToStream(String message) {
//       if (messages.last.isWaiting) {
//         setState(() {
//           messages.removeAt(lastIndex);
//           messages.insert(
//               lastIndex, Message(text: message, isBot: true, isWaiting: false));
//         });
//       } else {
//         setState(() {
//           messages[lastIndex].text += message;
//         });
//       }
//     }

//     if (messageType == 'start' && sender == "bot") {
//       if (!messages[lastIndex].isWaiting) {
//         messages.add(Message(text: '', isBot: true, isWaiting: true));
//       }
//     } else if (messageType == 'stream' && sender == "bot") {
//       RegExp exp = RegExp(r'- <button>(.*?)<\/button>');
//       RegExp tExp = RegExp(r'- <technique>(.*?)<\/technique>');
//       if (exp.hasMatch(message)) {
//         var matches = exp.allMatches(message).toList();
//         var buttonStartIndex = matches.first.start;
//         var beforeButton = message.substring(0, buttonStartIndex);
//         var buttonString = message.substring(buttonStartIndex);

//         for (var i = 0; i < beforeButton.length; i++) {
//           var chunk = beforeButton.substring(i, i + 1);
//           _addMessageToStream(chunk);
//           await Future.delayed(
//               const Duration(milliseconds: 1)); // Delay for 0.1 second
//         }
//         _addMessageToStream(buttonString);
//       }
//       if (tExp.hasMatch(message)) {
//         var matches = tExp.allMatches(message).toList();
//         var tList = matches.map((match) => match.group(1)!).toList();

//         technique = tList[0];
//       } else {
//         _addMessageToStream(message);
//       }
//     } else if (messageType == 'end' && sender == 'bot') {
//       await checkInService.storeCheckIn(widget.feeling, widget.feelingForm,
//           widget.reasonEntity, widget.reason, messages[lastIndex].text);
//       final counterStats = Provider.of<CounterStats>(context, listen: false);
//       counterStats.updateCheckInCounter();

//       context.read<CheckInHistoryBloc>().add(FetchCheckInHistoryEvent());

//       final bloc = context.read<ReflectionHomeBloc>();
//       if (bloc.state is ReflectionHomeInsufficientCheckIns) {
//         final state = bloc.state as ReflectionHomeInsufficientCheckIns;
//         bloc.add(UpdateNeedCheckInCount(
//             neededCheckInCount: state.neededCheckInCount - 1));
//       }
//       //add(EndChatEvent());
//     }
//     _scrollToBottom();
//   }

//   void _handleConnectionError(dynamic error) {
//     // Consider creating a new event for this action or handling it differently.
//   }

//   void _handleConnectionSuccess() {
//     // Consider creating a new event for this action or handling it differently.
//     chat?.sendJson({
//       'feeling': widget.feeling,
//       'feeling_form': widget.feelingForm,
//       'reason_entity': widget.reasonEntity,
//       'reason': widget.reason
//     });
//   }

//   Future<void> getResponseAndStore() async {
//     setState(() {
//       isTyping = true;
//     });
//     chat = Chat(
//       endpoint: 'checkin',
//       onMessageReceived: _handleIncomingMessage,
//       onConnectionError: _handleConnectionError,
//       onConnectionSuccess: _handleConnectionSuccess,
//     );

//     messages.add(Message(text: '', isBot: true, isWaiting: true));

//     Future.delayed(const Duration(seconds: 0), () {
//       setState(() {
//         showButtons = true;
//         if (!showExitButton) {
//           showExitButton = true;
//         }
//       });
//     });
//   }

//   void sendUserMessage(String message) {
//     setState(() {
//       messages.add(
//         Message(
//           text: message,
//           isBot: false,
//         ),
//       );
//     });
//     _scrollToBottom();
//   }

//   void navigateBackToHomePage() {
//     chat?.closeConnection();
//     Nav.toNamed(context, '/');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text(''),
//         iconTheme: const IconThemeData(),
//         automaticallyImplyLeading: false,
//         actions: [
//           if (showExitButton ||
//               widget.isPastCheckin ==
//                   true) // Show the exit button once it appears
//             IconButton(
//               icon: const Icon(Icons.exit_to_app),
//               onPressed: () {
//                 navigateBackToHomePage();
//               },
//             ),
//         ],
//       ),
//       body: SafeArea(
//         child: NotificationListener<ScrollNotification>(
//           onNotification: (ScrollNotification scrollInfo) {
//             if (scrollInfo.metrics.pixels ==
//                 scrollInfo.metrics.maxScrollExtent) {
//               setState(() {
//                 screenAtBottom = true;
//                 isScrolledUp = false;
//               });
//             } else if (scrollInfo.metrics.atEdge &&
//                 scrollInfo.metrics.pixels != 0) {
//               setState(() {
//                 screenAtBottom = true;
//                 isScrolledUp = false;
//               });
//             } else {
//               setState(() {
//                 screenAtBottom = false;
//                 isScrolledUp = true;
//               });
//             }
//             return true;
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Expanded(
//                 child: Stack(
//                   children: [
//                     ListView.builder(
//                       controller: _scrollController,
//                       itemCount: messages.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         Message message = messages[index];
//                         bool isLastMessage = index == messages.length - 1;
//                         bool shouldDisplayDots = isLastMessage &&
//                             message.text == '' &&
//                             message.isWaiting;
//                         return Align(
//                           alignment: message.isBot
//                               ? Alignment.centerLeft
//                               : Alignment.centerRight,
//                           child: Container(
//                             margin: EdgeInsets.fromLTRB(25, 10, 25,
//                                 index == messages.length - 1 ? 80 : 10),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: message.isBot
//                                   ? Colors.grey[400]
//                                   : Colors.grey[100],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     message.text.trim(),
//                                     style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   if (message.options != null)
//                                     for (var option in message.options!)
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             bottom: 5,
//                                             top:
//                                                 5), // Adjust this value to increase or decrease the gap
//                                         child: EntityButton(
//                                           entity: option,
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: Colors.black,
//                                                 width:
//                                                     1), // Add border conditionally
//                                             borderRadius: BorderRadius.circular(
//                                                 30), // Optional: add border radius
//                                           ),
//                                           textStyle: const TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.normal),
//                                           buttonStyle: ThemeHelper()
//                                               .buttonStyle()
//                                               .copyWith(
//                                                 backgroundColor:
//                                                     MaterialStateProperty.all<
//                                                             Color>(
//                                                         Colors.transparent),
//                                               ),
//                                           onTap: () {
//                                             messages.add(Message(
//                                                 text: option, isBot: false));
//                                           },
//                                         ),
//                                       ),
//                                   if (shouldDisplayDots)
//                                     DotsIndicator(
//                                       dotsCount: 3,
//                                       position: dotsPosition,
//                                       decorator: DotsDecorator(
//                                         size: const Size.square(10.0),
//                                         activeSize: const Size.square(10.0),
//                                         color: Colors.grey,
//                                         activeColor: Colors.black,
//                                         spacing: const EdgeInsets.all(3.0),
//                                         activeShape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(3.0),
//                                         ),
//                                       ),
//                                     ),
//                                 ]),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: messageController,
//                         decoration: InputDecoration(
//                           hintText: 'Type your message...',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     IconButton(
//                       onPressed: () {
//                         String message = messageController.text.trim();
//                         if (message.isNotEmpty) {
//                           //_chatBloc.add(SendMessageEvent(message));
//                           messageController.clear();
//                         }
//                       },
//                       icon: const Icon(Icons.send),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
