import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowPypoScreen extends StatefulWidget {
  final List<Map<String, dynamic>> postPypo;
  final int initialIndex;

  const ShowPypoScreen({required this.postPypo, required this.initialIndex, super.key});

  @override
  _ShowPypoScreenState createState() => _ShowPypoScreenState();
}

class _ShowPypoScreenState extends State<ShowPypoScreen> {
  PageController? _pageController;
  int currentIndex = 0;
  Set<String> likedPypo = {};
  String username = '';

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadLikedPypo();
    _loadUsername();
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

  Future<void> _loadLikedPypo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPypo');
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = List<String>.from(snapshot.snapshot.value as List);
        setState(() {
          likedPypo = Set<String>.from(data);
        });
      }
    }
  }

  Future<void> _updateLikedBy(String postId, bool isLiked, String postType) async {
  final ref = FirebaseDatabase.instance.ref().child('posts').child(postType).child(postId).child('likedBy');
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

  void _likePypo(int index) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPypo');
    final pypo = widget.postPypo[index]['mediaUrl'] ?? '';
    setState(() {
      likedPypo.add(pypo);
    });
    await ref.set(likedPypo.toList());

    final postId = widget.postPypo[index]['postId'] ?? '';
    await _updateLikedBy(postId, true, 'postPypoMain');
  }
}

  void _unlikePypo(int index) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPypo');
    final pypo = widget.postPypo[index]['mediaUrl'] ?? '';
    setState(() {
      likedPypo.remove(pypo);
    });
    await ref.set(likedPypo.toList());

    final postId = widget.postPypo[index]['postId'] ?? '';
    await _updateLikedBy(postId, false, 'postPypoMain');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username.isEmpty ? 'Pypo' : username),
        backgroundColor: const Color(0xFF7DABCF),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.postPypo.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: Image.network(
                  widget.postPypo[index]['mediaUrl'] ?? 'assets/me/default_profileImage.png',  // Menggunakan mediaUrl
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
                    color: likedPypo.contains(widget.postPypo[index]['mediaUrl'] ?? '') ? Colors.red : Colors.grey,  // Menggunakan mediaUrl
                    onPressed: () {
                      if (likedPypo.contains(widget.postPypo[index]['mediaUrl'] ?? '')) {  // Menggunakan mediaUrl
                        _unlikePypo(index);
                      } else {
                        _likePypo(index);
                      }
                    },
                  ),
                ],
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
