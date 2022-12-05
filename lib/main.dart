import 'dart:io';

import 'package:demo_socket/chat/chat_page.dart';
import 'package:demo_socket/dnamic_link/dynamic_link_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat/chat_socket.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const MyHomePage(title: 'Flutter Demo Chat'),
        home: const MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: () => navigate(const DynamicLinkPage()), child: const Text("Dynamic Link")),
            ElevatedButton(onPressed: () => navigate(const SocketPage()), child: const Text("Socket Chat")),
          ],
        ),
      ),
    );
  }

  void navigate(Widget child) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => child));
  }
}




class SocketPage extends StatefulWidget {

  const SocketPage({super.key});

  @override
  State<SocketPage> createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {

  String _name = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Socket"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your name is:',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: "Enter your name...."
                ),
                onChanged: _changeName,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text('Next', style: Theme.of(context).textTheme.headline6),
              )
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void _changeName(String value) => setState(() => _name = value);

  void _nextPage() {
    SocketService.setUserName(_name);
    SocketService.connectAndListen();
    print("SocketService Connected ------------ ${SocketService.isConnected}");
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => const ChatPage()));
  }
// void
}



class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

