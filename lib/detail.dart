import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id});
  final int id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Telephony telephony = Telephony.instance;
  List<SmsConversation> messages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getM();
  }

  void getM() async {
    List<SmsConversation> conversations = await telephony.getConversations();
    print(conversations);
    setState(() {
      messages = conversations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Message"),
            ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    messages[index].snippet!,
                    style: TextStyle(
                      fontWeight:
                          index % 2 == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
