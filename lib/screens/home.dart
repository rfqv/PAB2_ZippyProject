import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String profileName = 'User';
  String profileImage = 'assets/me/default_profileImage.png';
  List<Map> postPypoMain = [];
  List<Map> postPpyMain = [];
  final TextEditingController _textController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

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
    final refPypo = FirebaseDatabase.instance.ref().child('postPypoMain');
    final refPpy = FirebaseDatabase.instance.ref().child('postPpyMain');

    final snapshotPypo = await refPypo.once();
    final snapshotPpy = await refPpy.once();

    if (snapshotPypo.snapshot.value != null) {
      final data = snapshotPypo.snapshot.value as Map?;
      if (mounted) {
        setState(() {
          postPypoMain = List<Map>.from(data?.values ?? []);
        });
      }
    }

    if (snapshotPpy.snapshot.value != null) {
      final data = snapshotPpy.snapshot.value as Map?;
      if (mounted) {
        setState(() {
          postPpyMain = List<Map>.from(data?.values ?? []);
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _savePpy() async {
    final text = _textController.text;
    if (text.isNotEmpty || _image != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? imageUrl;
        if (_image != null) {
          final storageRef = FirebaseStorage.instance.ref().child('post_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
          final uploadTask = await storageRef.putFile(_image!);
          imageUrl = await uploadTask.ref.getDownloadURL();
        }

        final ref = FirebaseDatabase.instance.reference().child('postPpyMain').push();
        final newPost = {
          'username': profileName,
          'text': text,
          'timestamp': DateTime.now().toIso8601String(),
          'profileImage': profileImage,
          'mediaUrl': imageUrl,
        };
        await ref.set(newPost);
        setState(() {
          postPpyMain.add(newPost);
          _textController.clear();
          _image = null;
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
            const Text('ZIPPY'),
            const Spacer(),
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
            SizedBox(
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
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Write ppy here...',
                      ),
                    ),
                    if (_image != null)
                      Image.file(_image!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.image),
                              onPressed: _pickImage,
                            ),
                            IconButton(icon: const Icon(Icons.gif), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.event), onPressed: () {}),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _savePpy,
                          child: const Text('Share'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Posts
            Expanded(
              child: postPypoMain.isEmpty && postPpyMain.isEmpty
                  ? const Center(
                      child: Text("Selamat datang di Zippy. Mari buat pypo/ppy pertama Anda!"),
                    )
                  : ListView(
                      children: [
                        ...postPypoMain.map((post) => _buildPostPypoMainItem(post)),
                        ...postPpyMain.map((post) => _buildPostPpyMainItem(post)),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostPypoMainItem(Map post) {
    final timestamp = DateTime.parse(post['timestamp']);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post['profileImage'] ?? 'assets/me/default_profileImage.png'),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(timeago.format(timestamp)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(post['text']),
            if (post['mediaUrl'] != null) Image.network(post['mediaUrl']),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
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
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostPpyMainItem(Map post) {
    final timestamp = DateTime.parse(post['timestamp']);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post['profileImage'] ?? 'assets/me/default_profileImage.png'),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(timeago.format(timestamp)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(post['text']),
            if (post['mediaUrl'] != null) Image.network(post['mediaUrl']),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
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
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share),
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
