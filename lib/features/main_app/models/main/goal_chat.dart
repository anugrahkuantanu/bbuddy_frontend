import 'dart:convert';
import 'dart:typed_data';

import '/features/main_app/models/token.dart';
import '/features/main_app/models/websocket.dart';

import '/core/services/constants.dart';

import '/core/services/login.dart';

class GoalChat {
  WebSocket? _webSocket;

  void Function(dynamic, dynamic, dynamic) onMessageReceived;
  void Function(dynamic) onConnectionError;
  void Function() onConnectionSuccess;
  int goalId;

  GoalChat({
    required this.goalId,
    required this.onMessageReceived,
    required this.onConnectionError,
    required this.onConnectionSuccess,
  }) {
    _webSocket = WebSocket(
      onMessageCallback: _handleMessage,
      onErrCallback: _handleError,
      onSuccessConnectCallback: onConnectionSuccess,
      onFailConnectCallback: _handleConnectionFailure,
    );
    connect();
  }
  
  void connect() async {
    Token? accessToken = await getAccessToken();
    _webSocket?.connect('${baseWSURL}/${goalId}?authorization=${accessToken!.accessToken}');
  }

  void _handleMessage(dynamic data) {
    // Parse and handle the received message
    try {
      Map<String, dynamic> parsedJson = jsonDecode(data);
      // Access the necessary fields and handle them accordingly
      String messageType = parsedJson['message_type'];
      String message = parsedJson['message'];
      String sender = parsedJson['sender'];
      // Handle the message as per your requirements
      onMessageReceived(messageType, message, sender);
    } catch (e) {
      // Handle the error while parsing or handling the message
    }
  }

  void _handleError(dynamic error) {
    // Handle the WebSocket connection error
    onConnectionError(error);
  }

  void _handleConnectionFailure() {}

  void sendMessage(String message) {
    // Send the user's message to the server
    _webSocket?.sendText(message);
  }

  void sendBytes(Uint8List bytes) {
    // Send binary data to the server
    _webSocket?.sendBytes(bytes);
  }

  void sendJson(Map<String, dynamic> json){
    _webSocket?.sendJson(json);
  }

  void closeConnection() {
    // Close the WebSocket connection
    _webSocket?.close();
  }
}
