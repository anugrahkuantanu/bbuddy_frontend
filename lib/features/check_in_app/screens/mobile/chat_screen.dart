import '/features/check_in_app/controllers/controller.dart';
import 'package:flutter/material.dart';
import '../../models/model.dart';
import '../../services/checkIn_service.dart';
import 'package:provider/provider.dart';
import '../../../main_app/services/stats.dart';

class ChatScreen extends StatefulWidget {
  final String feeling;
  final String feelingForm;
  final String reasonEntity;
  final String reason;
  final bool isPastCheckin;
  final String? aiResponse;
  final Color backgroundColor;
  final Color? textColor;


  const ChatScreen({
    Key? key,
    required this.feeling,
    required this.feelingForm,
    required this.reasonEntity,
    required this.reason,
    required this.isPastCheckin,
    required this.backgroundColor,
    this.textColor,
    this.aiResponse

  }) : super(key: key);

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
  final checkInService = CheckInService();


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
  if (widget.isPastCheckin) {
    showProgressIndicator = false;
      messages.add(
        Message(
          text: widget.aiResponse?? '',
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

    setState(() {
      List<String> response_messages = response.split("\n\n");
      isTyping = false;
      showProgressIndicator = false; // Hide the progress indicator
      for (int i = 0; i < response_messages.length; i++) {
        messages.add(
          Message(
            text: response_messages[i],
            isBot: true,
          ),
        );
      }
    });

    Future.delayed(Duration(seconds: 0), () {
      setState(() {
        showButtons = true;
        if (!showExitButton) {
          showExitButton = true;
        }
      });
    });

    checkInService.storeCheckIn(widget.feeling, widget.feelingForm, widget.reasonEntity,
        widget.reason, response);

    final counterStats = Provider.of<CounterStats>(context, listen: false);
    counterStats.updateCheckInCounter();
  }

  void navigateToHome() {
    Navigator.of(context).pop(); // Navigate back to MyHomePage
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
    if (widget.isPastCheckin){
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckInHomeController()),
    );
    }
    else{
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckInHomeController()),
    );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        elevation:
              0,
        title: Text(''),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: [
          if (showExitButton || widget.isPastCheckin) // Show the exit button once it appears
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                navigateBackToHomePage();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
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
                    if (showProgressIndicator) // Display CircularProgressIndicator if showProgressIndicator is true
                      Center(
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
