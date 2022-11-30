import 'dart:async';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../model/chat_model.dart';

class SocketService {
  static late StreamController<ChatModel> _socketResponse;
  static late StreamController<List<String>> _userResponse;
  static late io.Socket _socket;
  static String _userName = '';


  static String? get userId => _socket.id;

  static bool get isConnected => _socket.connected;

  static Stream<ChatModel> get getResponse =>
      _socketResponse.stream.asBroadcastStream();
  static Stream<List<String>> get userResponse =>
      _userResponse.stream.asBroadcastStream();

  static void setUserName(String name) {
    _userName = name;
  }

  static void sendMessage(String message) {
    _socket.emit(
        'message',
        ChatModel(
          userId: userId,
          userName: _userName,
          message: message,
          time: DateTime.now().toString(),
        ));
  }

  static void connectAndListen() {
    _socketResponse = StreamController<ChatModel>();
    _userResponse = StreamController<List<String>>();
    _socket = io.io(
        'http://10.0.2.2:3000',
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({'userName': _userName})
            .build());

    _socket.connect();

    print("SocketService Connected ------------ ${SocketService.isConnected}");

    //When an event recieved from server, data is added to the stream
    _socket.on('message', (data) {
      _socketResponse.sink.add(ChatModel.fromRawJson(data));
    });

    //when users are connected or disconnected
    _socket.on('users', (data) {
      var users = (data as List<dynamic>).map((e) => e.toString()).toList();
      _userResponse.sink.add(users);
    });

    // _socket.onDisconnect((_) => print('disconnect'));
  }

  static void dispose() {
    _socket.dispose();
    _socket.destroy();
    _socket.close();
    _socket.disconnect();
    _socketResponse.close();
    _userResponse.close();
  }
}
