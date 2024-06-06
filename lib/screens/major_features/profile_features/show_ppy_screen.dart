import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowPpyScreen extends StatefulWidget {
  final String postId;
  final String postType;

  const ShowPpyScreen({required this.postId, required this.postType, super.key});

  @override
  _ShowPpyScreenState createState() => _ShowPpyScreenState();
}

class _ShowPpyScreenState extends State<ShowPpyScreen> {
  Map<String, dynamic>? postDetails;
  Set<String> likedPpy = {};
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadPostDetails();
    _loadLikedPpy();
    _loadUsername();
  }

  Future<void> _loadPostDetails() async {
    final ref = FirebaseDatabase.instance.ref().child(widget.postType).child(widget.postId);
    final snapshot = await ref.once();
    if (snapshot.snapshot.value != null) {
      final data = snapshot.snapshot.value as Map?;
      setState(() {
        postDetails = data?.cast<String, dynamic>();
      });
    }
  }

  Future<void> _loadUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map?;
        setState(() {
          username = data?['username'] ?? 'Unknown';
        });
      }
    }
  }

  Future<void> _loadLikedPpy() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPpy');
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = List<String>.from(snapshot.snapshot.value as List);
        setState(() {
          likedPpy = Set<String>.from(data);
        });
      }
    }
  }

  Future<void> _updateLikedBy(String postId, bool isLiked) async {
    final ref = FirebaseDatabase.instance.ref().child(widget.postType).child(postId).child('likedBy');
    final snapshot = await ref.once();
    if (snapshot.snapshot.value != null) {
      final likedBy = List<String>.from(snapshot.snapshot.value as List);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (isLiked) {
          likedBy.add(user.uid);
        } else {
          likedBy.remove(user.uid);
        }
        await ref.set(likedBy);
      }
    }
  }

  void _likePpy() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPpy');
      setState(() {
        likedPpy.add(widget.postId);
      });
      await ref.set(likedPpy.toList());

      await _updateLikedBy(widget.postId, true);
    }
  }

  void _unlikePpy() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPpy');
      setState(() {
        likedPpy.remove(widget.postId);
      });
      await ref.set(likedPpy.toList());

      await _updateLikedBy(widget.postId, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username.isEmpty ? 'Ppy' : username),
        backgroundColor: const Color(0xFF7DABCF),
      ),
      body: postDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Image.network(
                    postDetails!['mediaUrl'] ?? 'assets/me/default_profileImage.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite),
                      color: likedPpy.contains(widget.postId) ? Colors.red : Colors.grey,
                      onPressed: () {
                        if (likedPpy.contains(widget.postId)) {
                          _unlikePpy();
                        } else {
                          _likePpy();
                        }
                      },
                    ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    postDetails!['content'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
    );
  }
}
