import 'package:flutter/material.dart';
import 'package:zippy/screens/major_features/pesan_features/user_contacts.dart';
import 'package:zippy/screens/major_features/pesan_features/show_user_dm_screen.dart';

class Pesan extends StatefulWidget {
  const Pesan({super.key});

  @override
  State<Pesan> createState() => _PesanState();
}

class _PesanState extends State<Pesan> {
  final List<PesanItem> messages = [
    PesanItem(
        username: 'itsmechrist',
        message: 'Hi mate!',
        timestamp: '2h ago',
        profileImage:
            'assets/users/itsmechrist/favicon/username-itsmechrist-uid-254803.jpg'),
    PesanItem(
        username: 'Nounwoo',
        message: 'Mau ke pantai ga besok?',
        timestamp: '3h ago',
        profileImage:
            'assets/users/leedongwook_official/favicon/username-leedongwook_official-uid-130743.jpg'),
    PesanItem(
        username: 'Wonyoung',
        message: 'ayo jane kita ke cafe machanatte lusa nantii',
        timestamp: '5h ago',
        profileImage:
            'assets/users/for_everyoung10/favicon/username-for_everyoung10-uid-187436.jpg'),
    PesanItem(
        username: 'Ethan',
        message: 'May I help you jane?',
        timestamp: '1d ago',
        profileImage: 'assets/users/ethan1610/favicon/username-ethan1610-uid-256944.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Direct Message',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageWidget(
            message: messages[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowUserDMScreen(username: messages[index].username, currentUsername: '', chatWithUsername: '',),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserContacts()),
          );
        },
        child: Icon(Icons.message),
      ),
    );
  }
}

class PesanItem {
  final String username;
  final String message;
  final String timestamp;
  final String profileImage;

  PesanItem({
    required this.username,
    required this.message,
    required this.timestamp,
    required this.profileImage,
  });
}

class MessageWidget extends StatelessWidget {
  final PesanItem message;
  final VoidCallback onTap;

  const MessageWidget({
    super.key,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(message.profileImage),
      ),
      title: Text(
        message.username,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.message),
          Text(
            message.timestamp,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
