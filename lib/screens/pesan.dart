import 'package:flutter/material.dart';

class Pesan extends StatefulWidget {
  const Pesan({super.key});

  @override
  State<Pesan> createState() => _PesanState();
}

class _PesanState extends State<Pesan> {
  final List<PesanItem> messages = [
    PesanItem(username: 'user1', message: 'Hey! How are you?', timestamp: '2h ago', profileImage: 'assets/images/user1.png'),
    PesanItem(username: 'user2', message: 'Let\'s catch up soon!', timestamp: '3h ago', profileImage: 'assets/images/user2.png'),
    PesanItem(username: 'user3', message: 'Great meeting you!', timestamp: '5h ago', profileImage: 'assets/images/user3.png'),
    PesanItem(username: 'user4', message: 'Check out this post!', timestamp: '1d ago', profileImage: 'assets/images/user4.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Messages'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageWidget(message: messages[index]);
        },
      ),
    );
  }
}

class PesanItem {
  final String username;
  final String message;
  final String timestamp;
  final String profileImage;

  PesanItem({required this.username, required this.message, required this.timestamp, required this.profileImage});
}

class MessageWidget extends StatelessWidget {
  final PesanItem message;

  MessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(message.profileImage),
      ),
      title: Text(
        message.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.message),
          Text(
            message.timestamp,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      onTap: () {
        // Handle message tap
      },
    );
  }
}