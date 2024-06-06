import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zippy/screens/major_features/profile_features/edit_profile_screen.dart';
import 'package:zippy/screens/major_features/profile_features/share_profile_screen.dart';
import 'package:zippy/screens/major_features/profile_features/show_pypo_screen.dart';
import 'package:zippy/screens/settings/user_settings_screen.dart';
import 'package:zippy/screens/major_features/profile_features/user_location_screen.dart';
import 'package:provider/provider.dart';
import 'package:zippy/services/user_settings_services.dart';
import 'package:zippy/screens/major_features/profile_features/user_fans_list_screen.dart';
import 'package:zippy/screens/major_features/profile_features/user_following_list_screen.dart';
import 'package:zippy/screens/major_features/profile_features/user_pypo_grid_screen.dart';
import 'package:zippy/screens/major_features/profile_features/user_ppy_list_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProfile? userProfile;
  List<Map<String, dynamic>> pypoPosts = [];
  List<Map<String, dynamic>> ppyPosts = [];
  List<Map<String, dynamic>> likedPosts = [];
  List<Map<String, dynamic>> likedPypoPosts = [];
  List<Map<String, dynamic>> likedPpyPosts = [];
  Set<String> likedPpy = {};

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchPostPpyMain();
    fetchPostPypoMain();
    _loadLikedPpy(); // Tambahkan ini
  }

  Future<void> fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        setState(() {
          userProfile = UserProfile(
            profileName: data?['profileName'] ?? 'User',
            username: data?['username'] ?? 'Unknown',
            profileImage: data?['profileImage'] ?? 'assets/me/default_profileImage.png',
            userAddress: data?['userAddress'] ?? 'Unknown',
            fans: data?['fans'] ?? 0,
            following: data?['following'] ?? 0,
            postPypo: List<String>.from(data?['postPypo'] ?? []),
            postPpy: List<String>.from(data?['postPpy'] ?? []),
            postReplies: List<String>.from(data?['postReplies'] ?? []),
            likedPypo: List<String>.from(data?['likedPypo'] ?? []),
            likedPpy: List<String>.from(data?['likedPpy'] ?? []),
          );
        });
        await fetchPostCounts(userProfile!.username);
        await fetchUserPosts();
        await fetchLikedPosts();
      }
    }
  }

  Future<void> fetchUserPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('posts').orderByChild('userId').equalTo(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
        final pypoList = [];
        final ppyList = [];
        data.forEach((key, value) {
          if (value['type'] == 'pypo') {
            pypoList.add(value);
          } else if (value['type'] == 'ppy') {
            ppyList.add(value);
          }
        });
        setState(() {
          pypoPosts = pypoList.cast<Map<String, dynamic>>();
          ppyPosts = ppyList.cast<Map<String, dynamic>>();
          ppyPosts.sort((a, b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
        });
      }
    }
  }

  Future<void> fetchPostCounts(String username) async {
    final pypoRef = FirebaseDatabase.instance.ref().child('postPypoMain').orderByChild('username').equalTo(username);
    final ppyRef = FirebaseDatabase.instance.ref().child('postPpyMain').orderByChild('username').equalTo(username);

    final pypoSnapshot = await pypoRef.once();
    final ppySnapshot = await ppyRef.once();

    int pypoCount = 0;
    int ppyCount = 0;

    if (pypoSnapshot.snapshot.value != null) {
      pypoCount = (pypoSnapshot.snapshot.value as Map).length;
    }

    if (ppySnapshot.snapshot.value != null) {
      ppyCount = (ppySnapshot.snapshot.value as Map).length;
    }

    setState(() {
      userProfile!.pypoCount = pypoCount;
      userProfile!.ppyCount = ppyCount;
    });
  }

  Future<void> _updateLikedBy(String postId, bool isLiked, String postType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child(postType).child(postId).child('likedBy');
      if (isLiked) {
        await ref.child(user.uid).set(true);
      } else {
        await ref.child(user.uid).remove();
      }
    }
  }

  Future<void> fetchLikedPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final likedPypoRef = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPypo');
      final likedPpyRef = FirebaseDatabase.instance.ref().child('users').child(user.uid).child('likedPpy');

      final likedPypoSnapshot = await likedPypoRef.once();
      final likedPpySnapshot = await likedPpyRef.once();

      final likedPypoList = [];
      final likedPpyList = [];

      if (likedPypoSnapshot.snapshot.value != null) {
        final likedPypoData = List<String>.from(likedPypoSnapshot.snapshot.value as List);
        for (final url in likedPypoData) {
          final postSnapshot = await FirebaseDatabase.instance.ref().child('postPypoMain').orderByChild('mediaUrl').equalTo(url).once();
          if (postSnapshot.snapshot.value != null) {
            final postData = Map<String, dynamic>.from(postSnapshot.snapshot.value as Map);
            postData.forEach((key, value) {
              likedPypoList.add(value);
            });
          }
        }
      }

      if (likedPpySnapshot.snapshot.value != null) {
        final likedPpyData = List<String>.from(likedPpySnapshot.snapshot.value as List);
        for (final url in likedPpyData) {
          final postSnapshot = await FirebaseDatabase.instance.ref().child('postPpyMain').orderByChild('mediaUrl').equalTo(url).once();
          if (postSnapshot.snapshot.value != null) {
            final postData = Map<String, dynamic>.from(postSnapshot.snapshot.value as Map);
            postData.forEach((key, value) {
              likedPpyList.add(value);
            });
          }
        }
      }

      setState(() {
        likedPypoPosts = likedPypoList.cast<Map<String, dynamic>>();
        likedPpyPosts = likedPpyList.cast<Map<String, dynamic>>();
      });
    }
  }


Future<void> fetchPostPypoMain() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userRef = FirebaseDatabase.instance.ref().child('users').child(user.uid);
    final userSnapshot = await userRef.once();
    if (userSnapshot.snapshot.value != null) {
      final userData = Map<String, dynamic>.from(userSnapshot.snapshot.value as Map);
      final username = userData?['username'] ?? 'Unknown';

      final postPypoMainRef = FirebaseDatabase.instance.ref().child('postPypoMain').orderByChild('username').equalTo(username);
      final postPypoMainSnapshot = await postPypoMainRef.once();
      if (postPypoMainSnapshot.snapshot.value != null) {
        final postData = postPypoMainSnapshot.snapshot.value as Map<Object?, Object?>;
        final pypoList = postData.entries.map((entry) {
          final value = entry.value as Map<Object?, Object?>;
          return Map<String, dynamic>.from(value);
        }).toList();
        setState(() {
          pypoPosts = pypoList;
          pypoPosts.sort((a, b) => DateTime.parse(b['timestamp'] ?? DateTime.now().toString()).compareTo(DateTime.parse(a['timestamp'] ?? DateTime.now().toString())));
        });
      }
    }
  }
}

  Future<void> fetchPostPpyMain() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userRef = FirebaseDatabase.instance.ref().child('users').child(user.uid);
    final userSnapshot = await userRef.once();
    if (userSnapshot.snapshot.value != null) {
      final userData = Map<String, dynamic>.from(userSnapshot.snapshot.value as Map);
      final username = userData?['username'] ?? 'Unknown';

      final postPpyMainRef = FirebaseDatabase.instance.ref().child('postPpyMain').orderByChild('username').equalTo(username);
      final postPpyMainSnapshot = await postPpyMainRef.once();
      if (postPpyMainSnapshot.snapshot.value != null) {
        final postData = Map<String, dynamic>.from(postPpyMainSnapshot.snapshot.value as Map);
        final ppyList = [];
        postData.forEach((key, value) {
          if (value is Map<Object?, Object?>) {
            ppyList.add(Map<String, dynamic>.from(value as Map));
          }
        });
        setState(() {
          ppyPosts = ppyList.cast<Map<String, dynamic>>();
          ppyPosts.sort((a, b) => DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
        });
      }
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

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textColor = brightness == Brightness.dark ? Colors.white : Colors.black;
    final settings = Provider.of<UserSettingsService>(context);
    bool isDarkMode = settings.themeMode == ThemeMode.dark || (settings.themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);

    final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: isDarkMode ? null : Colors.black,
      backgroundColor: isDarkMode ? null : const Color(0xFF7DABCF),
    );

    final TabBar tabBar = TabBar(
      tabs: const [
        Tab(text: 'Pypo'),
        Tab(text: 'Ppy'),
        Tab(text: 'Replies'),
        Tab(text: 'Likes'),
      ],
      labelColor: isDarkMode ? null : Colors.black,
      unselectedLabelColor: isDarkMode ? null : Colors.black,
      indicatorColor: isDarkMode ? null : Colors.black,
    );

    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
          'Loading...',
          style: TextStyle(color: textColor),
        ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '@' + userProfile!.username,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSettings()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(userProfile!.profileImage),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile!.profileName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '@${userProfile!.username}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserLocationScreen(),
                            ),
                          );
                        },
                        child: Text(
                          userProfile!.userAddress,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: isDarkMode ? Colors.grey[850] : const Color(0xFF7DABCF),
              child: Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserFansListScreen()),
                            );
                          },
                          child: _buildStatColumn('Fans', userProfile!.fans),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserFollowingListScreen()),
                            );
                          },
                          child: _buildStatColumn('Following', userProfile!.following),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserPypoGridScreen()),
                            );
                          },
                          child: _buildStatColumn('Pypo', userProfile!.pypoCount),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserPpyListScreen()),
                            );
                          },
                          child: _buildStatColumn('Ppy', userProfile!.ppyCount),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: elevatedButtonStyle,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                    child: const Text('Edit Profile'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: elevatedButtonStyle,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShareProfileScreen()),
                      );
                    },
                    child: const Text('Share Profile'),
                  ),
                ],
              ),
            ),
            const Divider(),
            DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  tabBar,
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        _buildPypoGrid(),
                        _buildPpyList(),
                        _buildRepliesList(),
                        _buildLikesList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPypoGrid() {
  if (pypoPosts.isEmpty) {
    return const Center(child: Text("Tidak ada Pypo"));
  }

  return GridView.builder(
    padding: const EdgeInsets.all(8.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
    ),
    itemCount: pypoPosts.length,
    itemBuilder: (context, index) {
      final post = pypoPosts[index];
      final mediaUrl = post['mediaUrl'] ?? 'https://example.com/default_image.png'; // URL gambar default jika null

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowPypoScreen(postPypo: pypoPosts, initialIndex: index),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(mediaUrl, fit: BoxFit.cover),
            ),
          ],
        ),
      );
    },
  );
}

  Widget _buildPpyList() {
    if (ppyPosts.isEmpty) {
      return const Center(child: Text("Tidak ada Ppy"));
    }

    return ListView.builder(
      itemCount: ppyPosts.length,
      itemBuilder: (context, index) {
        final post = ppyPosts[index];
        return _buildPostPpyMainItem(post);
      },
    );
  }

  Widget _buildRepliesList() {
    if (userProfile!.postReplies.isEmpty) {
      return const Center(child: Text("Tidak ada Replies"));
    }

    return ListView.builder(
      itemCount: userProfile!.postReplies.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(userProfile!.postReplies[index]),
        );
      },
    );
  }

  Widget _buildLikesList() {
  if (likedPosts.isEmpty) {
    return const Center(child: Text("Tidak ada Likes"));
  }

  // Gabungkan pypoPosts dan ppyPosts ke dalam satu daftar
  List<Map<String, dynamic>> allLikedPosts = [];
  allLikedPosts.addAll(pypoPosts);
  allLikedPosts.addAll(ppyPosts);

  // Urutkan daftar berdasarkan timestamp
  allLikedPosts.sort((a, b) => DateTime.parse(b['timestamp'] ?? DateTime.now().toString())
      .compareTo(DateTime.parse(a['timestamp'] ?? DateTime.now().toString())));

  return ListView.builder(
    itemCount: allLikedPosts.length,
    itemBuilder: (context, index) {
      final post = allLikedPosts[index];
      // Periksa jenis postingan dan tampilkan sesuai dengan jenisnya
      if (post['type'] == 'pypo') {
        // Menggunakan widget yang sesuai untuk postingan pypo
        return _buildPostPypoMainItem(post);
      } else if (post['type'] == 'ppy') {
        // Menggunakan widget yang sesuai untuk postingan ppy
        return _buildPostPpyMainItem(post);
      }
      // Jika jenis tidak dikenali, kembalikan widget kosong
      return Container();
    },
  );
}

// Import widget _buildPostPypoMainItem dari home.dart
Widget _buildPostPypoMainItem(Map post) {
  final timestamp = DateTime.parse(post['timestamp']);
  return Card(
    color: const Color(0xFF7DABCF),
    margin: const EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(post['profileImage'] ?? 'assets/me/default_profileImage.png'),
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

  Widget _buildPostPpyMainItem(Map<String, dynamic> post) {
    final content = post['text'] ?? 'No content available';
    final timestamp = post['timestamp'] ?? DateTime.now().toString();
    final isLiked = likedPpy.contains(post['postId']);

    return ListTile(
      title: Text(content),
      subtitle: Text(timeago.format(DateTime.parse(timestamp))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
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
            color: isLiked ? Colors.red : Colors.grey,
            onPressed: () {
              if (isLiked) {
                _unlikePpy();
              } else {
                _likePpy();
              }
            },
          ),
        ],
      ),
    );
  }


  Widget _buildStatColumn(String label, int count) {
    String formattedCount = _formatCount(count);
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(label),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000 && count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else {
      return count.toString();
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

class UserProfile {
  final String profileName;
  final String username;
  final String profileImage;
  final String userAddress;
  final int fans;
  final int following;
  int pypoCount;
  int ppyCount;
  final List<String> postPypo;
  final List<String> postPpy;
  final List<String> postReplies;
  final List<String> likedPypo;
  final List<String> likedPpy;

  UserProfile({
    required this.profileName,
    required this.username,
    required this.profileImage,
    required this.userAddress,
    required this.fans,
    required this.following,
    this.pypoCount = 0,
    this.ppyCount = 0,
    required this.postPypo,
    required this.postPpy,
    required this.postReplies,
    required this.likedPypo,
    required this.likedPpy,
  });
}
