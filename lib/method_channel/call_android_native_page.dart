import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallAndroidNativePage extends StatefulWidget {
  const CallAndroidNativePage({Key? key}) : super(key: key);

  @override
  State<CallAndroidNativePage> createState() => _CallAndroidNativePageState();
}

class _CallAndroidNativePageState extends State<CallAndroidNativePage> {

  late String result;

  @override
  void initState() {
    setState(() {
      result = 'Method Channel not call';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('METHOD CHANNEL')),
      body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _callDataFromAndroidNative('getPackage'),
                child: const Text('Call Package Name From Native '),
              ),
              ElevatedButton(
                onPressed: () => _callDataFromAndroidNative('getBattery'),
                child: const Text('Call Battery From Native '),
              ),
              const SizedBox(height: 30),
              Text('Result:', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 20),
              Text(result),
            ],
          )
      ),
    );
  }

  void _callDataFromAndroidNative(String methodName) async{
    MethodChannel method = MethodChannel('demo');
    print('method.name ------------- ${method.name}');
    final output = await method.invokeMethod<dynamic>(methodName);
    if(output == null){
      result = '$methodName Null';
    } else {
      result = '$methodName: =>>>> $output';
    }
    print('methodName -------------$result');
    setState(() {});
  }
}
