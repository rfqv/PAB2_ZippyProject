import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'show_user_dm_screen.dart';

class UserContacts extends StatefulWidget {
  @override
  _UserContactsState createState() => _UserContactsState();
}

class _UserContactsState extends State<UserContacts> {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');
  List<String> _usernames = [];

  @override
  void initState() {
    super.initState();
    _loadUsernames();
  }

  void _loadUsernames() async {
    DatabaseEvent event = await _usersRef.once();
    DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic> users = snapshot.value as Map<dynamic, dynamic>;

    List<String> usernames = [];
    users.forEach((key, value) {
      usernames.add(value['username']);
    });

    setState(() {
      _usernames = usernames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kontak Saya'),
      ),
      body: ListView.builder(
        itemCount: _usernames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_usernames[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowUserDMScreen(username: _usernames[index], currentUsername: '', chatWithUsername: '',),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
