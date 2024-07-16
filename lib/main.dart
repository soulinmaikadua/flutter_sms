import 'package:flutter/material.dart';
import 'package:flutter_sms/detail.dart';
import 'package:flutter_sms/detail222.dart';
import 'package:telephony/telephony.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Telephony telephony = Telephony.instance;
  String _message = "No message received yet.";
  List<SmsMessage> messages = [];
  int _counter = 0;
  bool _permission = false;

  @override
  void initState() {
    // TODO: implement initState
    telephony.requestPhoneAndSmsPermissions;

    super.initState();
    getPer();
  }

  // Handle background messages
  void getPer() async {
    // Handle your message here
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    setState(() {
      _permission = permissionsGranted!;
    });
    if (_permission) {
      List<SmsMessage> _messages = await telephony.getInboxSms(
          // columns: [
          //   SmsColumn.ADDRESS,
          //   SmsColumn.BODY
          // ],
          // filter: SmsFilter.where(SmsColumn.ADDRESS),
          // .equals("1234567890")
          // .and(SmsColumn.BODY)
          // .like("starwars"),
          sortOrder: [
            OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC),
            OrderBy(SmsColumn.BODY)
          ]);
      print(_messages);
      setState(() {
        messages = _messages;
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                // DetailScreen(id: messages[index].id!),
                                const MyMessage()),
                      );
                    },
                    title: Text(messages[index].address!),
                    subtitle: Text(messages[index].body.toString()),
                  );
                },
              ),
              Text(_permission.toString()),
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
