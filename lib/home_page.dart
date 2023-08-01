import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

import 'Messages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jabber'),
      ),
      body: Column(
        children: [
          Expanded(child: MessagesScreen(messages: messages)),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            color: Colors.deepPurple,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sendMessages(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }

  //For handling user messages
  sendMessages(String text) async {
    if (text.isEmpty) {
      // ignore: avoid_print
      print("Message is Empty");
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])),
            true); //true as this is user messages
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) {
        return;
      }
      //Handling User-Flowtter message
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  //Handling messages returned by dialog_flowtter
  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
