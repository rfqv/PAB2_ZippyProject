import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zippy/screens/edit_profile_screen.dart';
import 'package:zippy/screens/share_profile_screen.dart';
import 'package:zippy/screens/show_pypo_screen.dart';
import 'package:zippy/screens/user_settings_screen.dart';
import 'package:zippy/screens/user_location_screen.dart'; 

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseDatabase.instance.ref().child('users').child(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map?;
        setState(() {
          userProfile = UserProfile(
            profileName: data?['profileName'] ?? 'User',
            username: data?['username'] ?? 'Unknown',
            profileImage: data?['profileImage'] ?? 'assets/me/default_profileImage.png',
            userAddress: data?['userAddress'] ?? 'Unknown',
            fans: data?['fans'] ?? 0,
            following: data?['following'] ?? 0,
            pypo: data?['pypo'] ?? 0,
            ppy: data?['ppy'] ?? 0,
            postPypo: List<String>.from(data?['postPypo'] ?? []),
            postPpy: List<String>.from(data?['postPpy'] ?? []),
            postReplies: List<String>.from(data?['postReplies'] ?? []),
            likedPypo: List<String>.from(data?['likedPypo'] ?? []), 
            likedPpy: List<String>.from(data?['likedPpy'] ?? []), 
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile!.username),
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
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn('Fans', userProfile!.fans),
                  _buildStatColumn('Following', userProfile!.following),
                  _buildStatColumn('Pypo', userProfile!.pypo),
                  _buildStatColumn('Ppy', userProfile!.ppy),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                  },
                  child: const Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShareProfileScreen()),
                    );
                  },
                  child: const Text('Bagikan Profil'),
                ),
              ],
            ),
            const Divider(),
            DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Pypo'),
                      Tab(text: 'Ppy'),
                      Tab(text: 'Replies'),
                      Tab(text: 'Likes'),
                    ],
                  ),
                  SizedBox(
                    height: 400, // Adjust height as needed
                    child: TabBarView(
                      children: [
                        _buildPypoGrid(),
                        _buildPpyList(),
                        _buildRepliesList(),
                        _buildLikesGrid(),
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
    if (userProfile!.postPypo.isEmpty) {
      return Center(child: Text("Tidak ada Pypo"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: userProfile!.postPypo.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowPypoScreen(postPypo: userProfile!.postPypo, initialIndex: index),
              ),
            );
          },
          child: Image.asset(userProfile!.postPypo[index], fit: BoxFit.cover),
        );
      },
    );
  }

  Widget _buildPpyList() {
    if (userProfile!.postPpy.isEmpty) {
      return Center(child: Text("Tidak ada Ppy"));
    }

    return ListView.builder(
      itemCount: userProfile!.postPpy.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              title: Text(userProfile!.postPpy[index]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // Implement reply functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Implement share functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite),
                  color: Colors.grey, // Implement like functionality and color change
                  onPressed: () {
                    // Implement like functionality
                  },
                ),
              ],
            ),
            Divider(),
          ],
        );
      },
    );
  }

  Widget _buildRepliesList() {
    if (userProfile!.postReplies.isEmpty) {
      return Center(child: Text("Tidak ada Replies"));
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

  Widget _buildLikesGrid() {
    if (userProfile!.likedPypo.isEmpty && userProfile!.likedPpy.isEmpty) {
      return Center(child: Text("Tidak ada Likes"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: userProfile!.likedPypo.length + userProfile!.likedPpy.length,
      itemBuilder: (context, index) {
        if (index < userProfile!.likedPypo.length) {
          return Image.asset(userProfile!.likedPypo[index], fit: BoxFit.cover);
        } else {
          return ListTile(
            title: Text(userProfile!.likedPpy[index - userProfile!.likedPypo.length]),
          );
        }
      },
    );
  }

  Widget _buildStatColumn(String label, int count) {
    String formattedCount = _formatCount(count);
    return Column(
      children: [
        Text(
          formattedCount,
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

class UserProfile {
  final String profileName;
  final String username;
  final String profileImage;
  final String userAddress;
  final int fans;
  final int following;
  final int pypo;
  final int ppy;
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
    required this.pypo,
    required this.ppy,
    required this.postPypo,
    required this.postPpy,
    required this.postReplies,
    required this.likedPypo,
    required this.likedPpy,
  });
}
