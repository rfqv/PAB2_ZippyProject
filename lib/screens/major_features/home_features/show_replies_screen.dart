import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShowRepliesScreen extends StatefulWidget {
  final String postId;
  final String postType;

  const ShowRepliesScreen({super.key, required this.postId, required this.postType});

  @override
  State<ShowRepliesScreen> createState() => _ShowRepliesScreenState();
}

class _ShowRepliesScreenState extends State<ShowRepliesScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Map> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final ref = FirebaseDatabase.instance.ref().child('posts').child(widget.postType).child(widget.postId).child('comments');
    final snapshot = await ref.once();

    if (snapshot.snapshot.value != null) {
      final data = snapshot.snapshot.value as Map?;
      setState(() {
        comments = List<Map>.from(data?.values ?? []);
        comments.sort((a, b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
      });
    }
  }

  Future<void> postComment() async {
    final text = _commentController.text;
    if (text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref = FirebaseDatabase.instance.ref().child('posts').child(widget.postType).child(widget.postId).child('comments').push();
        final newComment = {
          'commentId': ref.key,
          'profileName': user.displayName,
          'text': text,
          'timestamp': DateTime.now().toIso8601String(),
        };
        await ref.set(newComment);
        setState(() {
          comments.insert(0, newComment);
          _commentController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(
                    comment['profileName'] ?? 'Anonymous',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['text'],
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      Text(
                        timeago.format(DateTime.parse(comment['timestamp'])),
                        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: postComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
