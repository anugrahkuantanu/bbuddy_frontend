import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../../services/service.dart';
import '../../models/model.dart';

class GoalChatScreen extends StatefulWidget {
  int goalId; 
  
  GoalChatScreen({required this.goalId, Key? key}) : super(key: key);

  @override
  _GoalChatScreenState createState() => _GoalChatScreenState();
}

class _GoalChatScreenState extends State<GoalChatScreen> {
  late List<Message> messages;
  TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  double dotsPosition = 0;
  GoalChat? chat;
  final int pageSize = 10; // Number of messages to fetch per page
  int currentPage = 1; // Current page index
  bool initialScrollPerformed = false;
  bool isLoadingHistory = false;
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;


  final ScrollController _scrollController = ScrollController();
  bool incommingMsgInprogress = false;
  @override
  void initState() {
    super.initState();
    messages = [];
    _focusNode.addListener(_onFocusChange);

    fetchChatHistory(widget.goalId, currentPage, pageSize).listen((fetchedMessages) {
      setState(() {
        messages.addAll(fetchedMessages.reversed);
      });

      if (messages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });

    chat = GoalChat(
      goalId: widget.goalId,
      onMessageReceived: _handleIncomingMessage,
      onConnectionError: _handleConnectionError,
      onConnectionSuccess: _handleConnectionSuccess,
    );

    _startTypingAnimation();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      // User has reached the top, fetch more chat history
      _fetchOldChatHistory();
    }
  }

  void _fetchOldChatHistory() async {
    if (isLoadingHistory) return;

    setState(() {
      isLoadingHistory = true;
    });
    final nextPage = currentPage + 1;

    //if (oldPage >= 1) {
    try {
      fetchChatHistory(widget.goalId, nextPage, pageSize).listen((fetchedMessages) {
        if (fetchedMessages.isNotEmpty) {
          setState(() {
            messages.insertAll(0, fetchedMessages.reversed);
          });
          currentPage = nextPage;
        }
      });
    } catch (error) {
      // Handle error when fetching chat history
      print('Error fetching chat history: $error');
    }
    //}

    setState(() {
      isLoadingHistory = false;
    });
  }
 
  @override
  void dispose() {
    messageController.dispose();
    _focusNode.dispose();
    //chatModel?.closeConnection();
    super.dispose();
  }

  void _startTypingAnimation() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        dotsPosition += 1;
        if (dotsPosition > 2) {
          dotsPosition = 0;
        }
      });
    });
  }

  void _handleConnectionError(dynamic error) {
    // Handle the WebSocket connection error
    // Display an error message or take appropriate action
  }

  void _handleConnectionSuccess() {
    // Handle the WebSocket connection success
    // Display any necessary message or take appropriate action
  }

  void sendUserMessage(String message) {
    setState(() {
      messages.add(Message(text: message, isBot: false));
      messages.add(Message(text: '', isBot: true, isWaiting: true));
    });
    chat?.sendMessage(message);

    messageController.clear();
    Future.delayed(const Duration(seconds: 1), () {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    // if (!_scrollController.hasClients || initialScrollPerformed) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 5),
      curve: Curves.easeInOut,
    );
  }

  void _handleIncomingMessage(
      dynamic messageType, dynamic message, dynamic sender) {
    int lastIndex = messages.length - 1;
    if (messageType == 'start') {
    } else if (messageType == 'stream' && sender == "bot") {
      if (messages.last.isWaiting) {
        messages.removeAt(lastIndex);
        messages.insert(
            lastIndex, Message(text: message, isBot: true, isWaiting: false));
        _scrollToBottom();
      } else {
        messages[lastIndex].text += message;
        incommingMsgInprogress = true;
        _scrollToBottom();
      }
    } else if (messageType == 'end' && sender == 'bot'){
        incommingMsgInprogress = false;
    }
    setState(() {});
  }

  Column displayMessage(BuildContext context, Message message) {
    return Column(children: [
      Text(
        message.text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      )
    ]);
  }

    void _onFocusChange() {
    setState(() {
      isKeyboardVisible = _focusNode.hasFocus;
    });

    if (isKeyboardVisible) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollToBottom();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // final MediaQueryData _isKeyboardVisible = MediaQuery.of(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF2D425F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D425F),
        elevation:
            0, // Remove the line dividing the AppBar and the rest of the screen
        title: const Text(
          'Coach',
          style: TextStyle(
            color: Colors.white, // Set the color of the font to white
          ),
        ),
      ),
      body:
      GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
            },
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  ListView.builder(
                    shrinkWrap: true, // Add this to prevent render overflow
                    physics: const BouncingScrollPhysics(), 
                    controller: _scrollController,
                    reverse: false,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      Message message = messages[index];
                      bool isLastMessage = index == messages.length - 1;
                      bool isBotMessage = message.isBot;
                      return Align(
                        alignment: isBotMessage
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isBotMessage ? Colors.grey[300] : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              displayMessage(context, message),
                              if (isLastMessage &&
                                  isBotMessage &&
                                  message.isWaiting)
                                const SizedBox(height: 3),
                              if (isLastMessage &&
                                  isBotMessage &&
                                  message.isWaiting)
                                DotsIndicator(
                                  dotsCount: 3,
                                  position: dotsPosition.toInt(),
                                  decorator: DotsDecorator(
                                    size: const Size.square(2.0),
                                    activeSize: const Size.square(2.0),
                                    color: Colors.grey,
                                    activeColor: Colors.black,
                                    spacing: const EdgeInsets.all(3.0),
                                    activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (isLoadingHistory) // Display waiting indicator when loading chat history above
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
            ),
              Container(
                color: const Color(0xFF2D425F),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
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
                      if (message.isNotEmpty &&
                          (!messages.isNotEmpty || !messages.last.isWaiting) &&
                          !incommingMsgInprogress) {
                        sendUserMessage(message);
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
              
            ),
                         // Adjust the chatbox position based on keyboard visibility
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isKeyboardVisible ? kToolbarHeight + 250: 0,
                child: const SizedBox(),),
          ],
        ),
      ),
    ),
    );
  }
}