import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String profileName = 'User';

  @override
  void initState() {
    super.initState();
    fetchProfileName();
  }

  Future<void> fetchProfileName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.reference().child('users').child(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map?;
        if (mounted) {
          setState(() {
            profileName = data?['profileName'] ?? 'User';
          });
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat datang, $profileName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // Add post feeds and other elements here
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search result display
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            query = value;
          },
          decoration: const InputDecoration(
            hintText: 'Search...',
          ),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          items: [
            DropdownMenuItem(value: '1h', child: Text('1 jam terakhir')),
            DropdownMenuItem(value: '4h', child: Text('4 jam terakhir')),
            DropdownMenuItem(value: '12h', child: Text('12 jam terakhir')),
            DropdownMenuItem(value: '24h', child: Text('24 jam terakhir')),
            DropdownMenuItem(value: '3d', child: Text('3 hari terakhir')),
            DropdownMenuItem(value: '7d', child: Text('7 hari terakhir')),
            // Add more options as needed
          ],
          onChanged: (value) {
            // Handle the filter change
          },
          hint: Text('Select filter'),
        ),
        // Display suggested results
      ],
    );
  }
}
