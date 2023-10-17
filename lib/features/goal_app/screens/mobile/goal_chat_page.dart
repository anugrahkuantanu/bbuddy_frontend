import 'dart:async';
import 'package:bbuddy_app/core/core.dart';
import 'package:bbuddy_app/features/goal_app/blocs/bloc.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



// States




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
                                message.isBot ? Colors.grey[400] : Colors.grey[100],
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
