import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';

class UserProfile {
  final String profileName;
  final String username;
  final String profileImage;

  UserProfile({
    required this.profileName,
    required this.username,
    required this.profileImage,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Ganti tipe variabel profileName, username, dan profileImage menjadi UserProfile
  late UserProfile userProfile = UserProfile(profileName: 'User', username: 'Username', profileImage: 'assets/me/default_profileImage.png');
  List<Map> posts = [];
  final TextEditingController _textController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Set<String> likedPypo = {};
  Set<String> likedPpy = {};

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchPosts();
    fetchLikedPypo();
    fetchLikedPpy();
  }

  Future<void> fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map?;
        if (mounted) {
          setState(() {
            userProfile = UserProfile(
              profileName: data?['profileName'] ?? 'User',
              username: data?['username'] ?? 'Username',
              profileImage: data?['profileImage'] ?? 'assets/me/default_profileImage.png',
            );
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

    List<Map> tempPosts = [];

    if (snapshotPypo.snapshot.value != null) {
      final data = snapshotPypo.snapshot.value as Map?;
      if (mounted) {
        tempPosts.addAll(List<Map>.from(data?.values ?? []));
      }
    }

    if (snapshotPpy.snapshot.value != null) {
      final data = snapshotPpy.snapshot.value as Map?;
      if (mounted) {
        tempPosts.addAll(List<Map>.from(data?.values ?? []));
      }
    }

    if (mounted) {
      setState(() {
        posts = tempPosts;
        posts.sort((a, b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
      });
    }
  }

  Future<void> fetchLikedPypo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPypo');
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = List<String>.from(snapshot.snapshot.value as List);
        if (mounted) {
          setState(() {
            likedPypo = Set<String>.from(data);
          });
        }
      }
    }
  }

  Future<void> fetchLikedPpy() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPpy');
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = List<String>.from(snapshot.snapshot.value as List);
        if (mounted) {
          setState(() {
            likedPpy = Set<String>.from(data);
          });
        }
      }
    }
  }

  void likePost(String postId, String postType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      if (postType == 'postPypoMain') {
        setState(() {
          likedPypo.add(postId);
        });
        await ref.child('likedPypo').set(likedPypo.toList());
      } else {
        setState(() {
          likedPpy.add(postId);
        });
        await ref.child('likedPpy').set(likedPpy.toList());
      }
      await updateLikedStatus(postId, true, postType);
    }
  }

  Future<void> updateLikedStatus(String postId, bool isLiked, String postType) async {
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

  void unlikePost(String postId, String postType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      if (postType == 'postPypoMain') {
        setState(() {
          likedPypo.remove(postId);
        });
        await ref.child('likedPypo').set(likedPypo.toList());
      } else {
        setState(() {
          likedPpy.remove(postId);
        });
        await ref.child('likedPpy').set(likedPpy.toList());
      }
      await updateLikedStatus(postId, false, postType);
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
        final ref = FirebaseDatabase.instance.ref().child('postPpyMain').push();
        final newPost = {
          'postId': ref.key,
          'postType': 'ppy',
          'profileImage': userProfile!.profileImage,
          'profileName': userProfile!.profileName,
          'username': userProfile!.username,
          'text': text,
          'timestamp': DateTime.now().toIso8601String(),
        };
        await ref.set(newPost);
        setState(() {
          posts.insert(0, newPost);
          _textController.clear();
          _image = null;
        });
      }
    }
  }

  Future<void> _savePypo() async {
    final text = _textController.text;
    if (text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? imageUrl;
        if (_image != null) {
          final storageRef = FirebaseStorage.instance.ref().child('post_images/${userProfile!.username}_${DateTime.now().millisecondsSinceEpoch}.jpg');
          final uploadTask = await storageRef.putFile(_image!);
          imageUrl = await uploadTask.ref.getDownloadURL();
        }

        final ref = FirebaseDatabase.instance.ref().child('postPypoMain').push();
        final newPost = {
          'mediaUrl': imageUrl,
          'postId': ref.key,
          'postType': 'pypo',
          'profileImage': userProfile!.profileImage,
          'profileName': userProfile!.profileName,
          'username': userProfile!.username,
          'text': text,
          'timestamp': DateTime.now().toIso8601String(),
        };
        await ref.set(newPost);
        setState(() {
          posts.insert(0, newPost);
          _textController.clear();
          _image = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Zippy',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
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
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                    backgroundImage: NetworkImage(userProfile!.profileImage),
                  ),
                  // Add more CircleAvatars for other users if needed
                ],
              ),
            ),
            // Pypo input
            Card(
              color: Theme.of(context).appBarTheme.backgroundColor,
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Create your Pypo/Ppy here!',
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    if (_image != null)
                      SizedBox(
                        width: 100, // Adjust the width and height as needed
                        height: 100,
                        child: Image.file(_image!),
                      ),
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
                          style: ElevatedButton.styleFrom(
                            foregroundColor: isDarkMode ? Colors.white : Colors.black,
                            backgroundColor: isDarkMode ? Colors.grey[800] : const Color(0xFFBAD6EB),
                          ),
                          onPressed: () {
                            if (_image != null) {
                              _savePypo();
                            } else {
                              _savePpy();
                            }
                          },
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
              child: posts.isEmpty
                  ? const Center(
                      child: Text("Selamat datang di Zippy. Mari buat pypo/ppy pertama Anda!"),
                    )
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        if (post.containsKey('mediaUrl')) {
                          return _buildPostPypoMainItem(post);
                        } else {
                          return _buildPostPpyMainItem(post);
                        }
                      },
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
      color: Theme.of(context).appBarTheme.backgroundColor,
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
                      icon: const Icon(Icons.favorite),
                      color: likedPypo.contains(post['postId']) ? Colors.red : Colors.grey,
                      onPressed: () {
                        if (likedPypo.contains(post['postId'])) {
                          unlikePost(post['postId'], 'postPypoMain');
                        } else {
                          likePost(post['postId'], 'postPypoMain');
                        }
                      },
                    ),
                    const Text('1.8K'),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    const Text('872'),
                  ],
                ),
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

  Widget _buildPostPpyMainItem(Map post) {
    final timestamp = DateTime.parse(post['timestamp']);
    return Card(
      color: Theme.of(context).appBarTheme.backgroundColor,
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
                      icon: const Icon(Icons.favorite),
                      color: likedPpy.contains(post['postId']) ? Colors.red : Colors.grey,
                      onPressed: () {
                        if (likedPpy.contains(post['postId'])) {
                          unlikePost(post['postId'], 'postPpyMain');
                        } else {
                          likePost(post['postId'], 'postPpyMain');
                        }
                      },
                    ),
                    const Text('1.8K'),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    const Text('872'),
                  ],
                ),
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
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
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
