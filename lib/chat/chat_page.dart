import 'package:demo_socket/model/chat_model.dart';
import 'package:flutter/material.dart';

import 'chat_socket.dart';
import 'message_view.dart';
import 'chat_text_input.dart';
import 'user_list_view.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  void _backPage(BuildContext context){
    SocketService.dispose();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _backPage(context),
          ),
          centerTitle: true,
          title: const Text("Demo Socket Chat"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              UserListView(),
              _ChatBody(),
              SizedBox(height: 6),
              ChatTextInput(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chats = <ChatModel>[];
    ScrollController _scrollController = ScrollController();

    ///scrolls to the bottom of page
    void _scrollDown() {
      try {
        Future.delayed(
            const Duration(milliseconds: 300),
                () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));
      } on Exception catch (_) {}
    }

    return Expanded(
      child: StreamBuilder(
        stream: SocketService.getResponse,
        builder: (BuildContext context, AsyncSnapshot<ChatModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            chats.add(snapshot.data!);
          }
          _scrollDown();
          return ListView.builder(
            controller: _scrollController,
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) =>
                MessageView(chat: chats[index]),
          );
        },
      ),
    );
  }
}
