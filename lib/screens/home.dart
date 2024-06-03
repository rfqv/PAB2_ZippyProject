// home.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zippy/screens/show_pypo_screen.dart';
import 'package:zippy/screens/user_settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String profileName = 'User';
  String profileImage = 'assets/me/default_profileImage.png';
  List<Map> postPypo = [];
  List<Map> postPpy = [];
  final TextEditingController _textController = TextEditingController();

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
            profileImage = data?['profileImage'] ?? 'assets/me/default_profileImage.png';
          });
        }
      }
    }
  }

  Future<void> fetchPosts() async {
    final refPypo = FirebaseDatabase.instance.ref().child('postPypo');
    final refPpy = FirebaseDatabase.instance.ref().child('postPpy');

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

  Future<void> _savePpy() async {
    final text = _textController.text;
    if (text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref = FirebaseDatabase.instance.reference().child('postPpy').push();
        final newPost = {
          'username': profileName,
          'text': text,
          'timestamp': DateTime.now().toIso8601String(),
        };
        await ref.set(newPost);
        setState(() {
          postPpy.add(newPost);
          _textController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('ZIPPY'),
            Spacer(),
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Horizontal List of Users
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(profileImage),
                  ),
                  // Add more CircleAvatars for other users if needed
                ],
              ),
            ),
            // Pypo input
            Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Write ppy here...',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(icon: Icon(Icons.image), onPressed: () {}),
                            IconButton(icon: Icon(Icons.gif), onPressed: () {}),
                            IconButton(icon: Icon(Icons.event), onPressed: () {}),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _savePpy,
                          child: Text('Share'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Posts
            Expanded(
              child: postPypo.isEmpty && postPpy.isEmpty
                  ? Center(
                      child: Text("Selamat datang di Zippy. Mari buat pypo/ppy pertama Anda!"),
                    )
                  : ListView(
                      children: [
                        ...postPypo.map((post) => _buildPostPypoItem(post)).toList(),
                        ...postPpy.map((post) => _buildPostPpyItem(post)).toList(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostPypoItem(Map post) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post['profileImage'] ?? 'assets/me/default_profileImage.png'),
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['username'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('5 hours ago'), // Replace with actual time
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(post['text']),
            if (post['mediaUrl'] != null) Image.asset(post['mediaUrl']),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    Text('1.8K'), // Replace with actual like count
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    Text('872'), // Replace with actual comment count
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {},
                    ),
                    Text('132'), // Replace with actual save count
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostPpyItem(Map post) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post['profileImage'] ?? 'assets/me/default_profileImage.png'),
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['username'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('5 hours ago'), // Replace with actual time
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(post['text']),
            if (post['mediaUrl'] != null) Image.asset(post['mediaUrl']),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    Text('1.8K'), // Replace with actual like count
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    Text('872'), // Replace with actual comment count
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {},
                    ),
                    Text('132'), // Replace with actual save count
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
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
    // Implement search suggestion display
    return Container();
  }
}
