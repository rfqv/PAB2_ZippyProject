import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowPypoScreen extends StatefulWidget {
  final List<String> postPypo;
  final int initialIndex;

  const ShowPypoScreen({required this.postPypo, required this.initialIndex, super.key});

  @override
  _ShowPypoScreenState createState() => _ShowPypoScreenState();
}

class _ShowPypoScreenState extends State<ShowPypoScreen> {
  PageController? _pageController;
  int currentIndex = 0;
  Set<String> likedPypo = {};

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadLikedPypo();
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

  void _likePypo(int index) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPypo');
    final pypo = widget.postPypo[index];
    setState(() {
      if (likedPypo.contains(pypo)) {
        likedPypo.remove(pypo);
      } else {
        likedPypo.add(pypo);
      }
    });
    await ref.set(likedPypo.toList());
  }
}

void _unlikePypo(int index) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPypo');
    final pypo = widget.postPypo[index];
    setState(() {
      likedPypo.remove(pypo);
    });
    await ref.set(likedPypo.toList());
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pypo'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.postPypo.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: Image.asset(widget.postPypo[index], fit: BoxFit.cover),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    color: likedPypo.contains(widget.postPypo[index]) ? Colors.red : Colors.grey,
                    onPressed: () {
                      if (likedPypo.contains(widget.postPypo[index])) {
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
