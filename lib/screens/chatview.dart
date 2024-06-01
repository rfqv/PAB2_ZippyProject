import 'package:flutter/material.dart';
import 'package:zippy/navigator/chatbottom.dart';
import 'package:zippy/screens/chatsample.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(78.0),
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: AppBar(
              leadingWidth: 30,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('images/kpop.jpeg'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Christ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Icon(Icons.info_outline),
                )
              ],
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          children: [
            ChatSample(),
          ],
        ),
        bottomSheet: ChatBottom());
  }
}
