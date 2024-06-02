import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zippy/screens/user_settings_screen.dart';

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
      final ref = FirebaseDatabase.instance.reference().child('users').child(user.uid);
      final snapshot = await ref.once();
      if (snapshot.snapshot.value != null) {
        final data = snapshot.snapshot.value as Map?;
        setState(() {
          userProfile = UserProfile(
            profileName: data?['profileName'] ?? 'User',
            username: data?['username'] ?? 'Unknown',
            profileImage: data?['profileImage'] ?? 'assets/default_profile.png',
            fans: data?['fans'] ?? 0,
            following: data?['following'] ?? 0,
            pypo: data?['pypo'] ?? 0,
            ppy: data?['ppy'] ?? 0,
            postPypo: List<String>.from(data?['postPypo'] ?? []),
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
                  radius: 40,
                  backgroundImage: AssetImage(userProfile!.profileImage),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('Fans', userProfile!.fans),
                          _buildStatColumn('Following', userProfile!.following),
                          _buildStatColumn('Pypo', userProfile!.pypo),
                          _buildStatColumn('Ppy', userProfile!.ppy),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle follow/unfollow
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userProfile!.postPypo.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              return Image.asset(userProfile!.postPypo[index]);
            },
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class UserProfile {
  final String profileName;
  final String username;
  final String profileImage;
  final int fans;
  final int following;
  final int pypo;
  final int ppy;
  final List<String> postPypo;

  UserProfile({
    required this.profileName,
    required this.username,
    required this.profileImage,
    required this.fans,
    required this.following,
    required this.pypo,
    required this.ppy,
    required this.postPypo,
  });
}
