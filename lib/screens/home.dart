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
  List<Map> postPypo = [];
  List<Map> postPpy = [];

  @override
  void initState() {
    super.initState();
    fetchProfileName();
    fetchPosts();
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

  Future<void> fetchPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final refPypo = FirebaseDatabase.instance.ref().child('postPypo').orderByChild('username').equalTo('itsmechrist');
      final refPpy = FirebaseDatabase.instance.ref().child('postPpy').orderByChild('username').equalTo('itsmechrist');

      final snapshotPypo = await refPypo.once();
      final snapshotPpy = await refPpy.once();

      if (snapshotPypo.snapshot.value != null) {
        final data = snapshotPypo.snapshot.value as Map?;
        if (mounted) {
          setState(() {
            postPypo = List<Map>.from(data?.values ?? []);
          });
        }
      }

      if (snapshotPpy.snapshot.value != null) {
        final data = snapshotPpy.snapshot.value as Map?;
        if (mounted) {
          setState(() {
            postPpy = List<Map>.from(data?.values ?? []);
          });
        }
      }
    }
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
            ...postPypo.map((post) => _buildPostItem(post)).toList(),
            ...postPpy.map((post) => _buildPostItem(post)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostItem(Map post) {
    return ListTile(
      leading: post['mediaUrl'] != null ? Image.network(post['mediaUrl']) : null,
      title: Text(post['username']),
      subtitle: Text(post['text']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Handle like
            },
          ),
          IconButton(
            icon: const Icon(Icons.comment),
            onPressed: () {
              // Handle reply
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Handle save
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share
            },
          ),
        ],
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
          items: const [
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
          hint: const Text('Select filter'),
        ),
        // Display suggested results
      ],
    );
  }
}
