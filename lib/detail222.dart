import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MyMessage extends StatefulWidget {
  const MyMessage({Key? key}) : super(key: key);

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _getSmsMessages();
  }

  Future<void> _getSmsMessages() async {
    // Request SMS read permission
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      // Fetch SMS messages
      List<SmsMessage> messages = await _query.getAllSms;
      setState(() {
        _messages = messages;
      });
    } else {
      // Request the permission
      await Permission.sms.request();
      _getSmsMessages(); // Retry after requesting permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SMS Inbox Example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: _messages.isNotEmpty
              ? _MessagesListView(
                  messages: _messages,
                )
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button...',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final permission = await Permission.sms.status;
            if (permission.isGranted) {
              final messages = await _query.querySms(
                kinds: [
                  SmsQueryKind.inbox,
                  SmsQueryKind.sent,
                ],
                // address: '+254712345789',
                count: 10,
              );
              debugPrint('sms inbox messages: ${messages.length}');

              setState(() => _messages = messages);
            } else {
              await Permission.sms.request();
            }
          },
          child: const Icon(Icons.refresh),
        ));
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];

        return ListTile(
          title: Text('${message.sender} [${message.date}]'),
          subtitle: Text('${message.body}'),
        );
      },
    );
  }
}
