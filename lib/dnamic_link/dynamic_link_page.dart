import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

class DynamicLinkPage extends StatefulWidget {
  const DynamicLinkPage({Key? key}) : super(key: key);

  @override
  State<DynamicLinkPage> createState() => _DynamicLinkPageState();
}

class _DynamicLinkPageState extends State<DynamicLinkPage> {

  // late Stream<String?> _sub;

  String? _link;

  @override
  void initState() {
    // print('firebase -------${Firebase.apps.first.hashCode}');
    initUniLinks();
    super.initState();
  }

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      setState(() {
        _link = initialLink;
        print('_link ------------------- $_link');

      });
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      print('Error -------------------');
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  Future<String> buildDynamicLink() async{
    String url = "https://socket.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/post?id=56'),
      androidParameters: const AndroidParameters(
        //Ở đây là tên package đã config trên Firebase.
        packageName: "com.example.demo_socket",
        minimumVersion: 30,
      ),
      iosParameters: const IOSParameters(
        //Ở đây là bundleId đã config trên Firebase.
        bundleId: "com.example.demoSocket",
        minimumVersion: '1.0.1',
      ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //     description: "",
     //     imageUrl:
      //     Uri.parse("https://flutter.dev/images/flutter-logo-sharing.png"),
      //     title: ""),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);


    // final Uri dynamicUrl = await dynamicLink.link;
    print('url ----- $url');
    print('parameters ----- $parameters');
    print('Uri ----- ${parameters.link}');
    return dynamicLink.data.toString();
  }

  void initFirebaseDynamicLinks() async {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    print('dynamicLink ------- ${data.toString()}');

    print('deepLink ------- $deepLink');

    if (deepLink != null) {
      handleDynamicLink(deepLink);
    }
    try {
      FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLink) {
        final Uri deepLink = dynamicLink.link;

        handleDynamicLink(deepLink);
      });
    } on PlatformException {
      print('--------------- Error --------------');
    }
  }

  // Ở đây nếu link có chứa "post" thì sẽ cho nhảy đến màn hình Post và truyền param thứ 2 của link là 56 qua màn hình Post.
  void handleDynamicLink(Uri url) {
    print('url -------------$url');
    List<String> separatedString = [];
    separatedString.addAll(url.path.split('/'));
    if (separatedString[1] == "post") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostScreen(id: separatedString[2])));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DYNAMIC LINK'), centerTitle: true),
      body: Center(
        child: Text("---- DYNAMIC LINK ---- \n $_link", style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.center),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () => initFirebaseDynamicLinks(),
        onPressed: () async{
          String? data = await buildDynamicLink();
          print('data --------- $data');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

}

class PostScreen extends StatelessWidget {
  final String id;
  const PostScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('id -----$id', style: Theme.of(context).textTheme.headline6),
      ),
    );
  }
}

