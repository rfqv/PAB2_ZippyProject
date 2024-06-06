import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;

class ShowPpyScreen extends StatefulWidget {
  final String postId;
  final String postType;

  const ShowPpyScreen({required this.postId, required this.postType, super.key});

  @override
  _ShowPpyScreenState createState() => _ShowPpyScreenState();
}

class _ShowPpyScreenState extends State<ShowPpyScreen> {
  Map<String, dynamic>? postDetails;

  @override
  void initState() {
    super.initState();
    fetchPostDetails();
  }

  Future<void> fetchPostDetails() async {
    final ref = FirebaseDatabase.instance.ref().child(widget.postType).child(widget.postId);
    final snapshot = await ref.once();
    if (snapshot.snapshot.value != null) {
      setState(() {
        postDetails = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (postDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final timestamp = DateTime.parse(postDetails!['timestamp']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(postDetails!['profileImage'] ?? 'assets/me/default_profileImage.png'),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(postDetails!['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(timeago.format(timestamp)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(postDetails!['text'] ?? ''),
            if (postDetails!['mediaUrl'] != null) Image.network(postDetails!['mediaUrl']),
            const SizedBox(height: 16.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  color: Colors.grey,
                  onPressed: () {},
                ),
                const Text('1.8K'),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {},
                ),
                const Text('872'),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {},
                ),
                const Text('132'),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    _showShareMenu(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showShareMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        const PopupMenuItem(
          value: 'zippy_friends',
          child: Text('Bagikan ke teman Zippy'),
        ),
        const PopupMenuItem(
          value: 'share',
          child: Text('Bagikan ke...'),
        ),
      ],
    ).then((value) {
      if (value == 'zippy_friends') {
        // Handle "Bagikan ke teman Zippy"
      } else if (value == 'share') {
        // Handle "Bagikan ke..."
      }
    });
  }
}
