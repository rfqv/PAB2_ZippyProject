import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserProfile userProfile = UserProfile(
    profileName: 'Janeya',
    username: '@jjnaey97',
    profileImage: 'assets/me/username-jjnaey97-uid-256944-profileIconMain.jpeg',
    pypo: 3571,
    ppy: 81,
    fans: 25695,
    following: 458,
    postPypo: [
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3571.jpg',
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3570.jpg',
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3569.jpg',
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3568.jpg',
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3567.jpg',
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3566.jpg',
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3565.jpg',
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3564.jpg',
      'assets/me/pypo/username-jjnaey97-uid-256944-pypo3563.jpg',
      // Tambahkan gambar lain sesuai kebutuhan
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile.username),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
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
                    backgroundImage: AssetImage(userProfile.profileImage),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('Fans', userProfile.fans),
                            _buildStatColumn('Following', userProfile.following),
                            _buildStatColumn('Pypo', userProfile.pypo),
                            _buildStatColumn('Ppy', userProfile.ppy),
                          ],
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Handle follow/unfollow
                          },
                          child: Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: userProfile.postPypo.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                return Image.asset(userProfile.postPypo[index]);
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
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