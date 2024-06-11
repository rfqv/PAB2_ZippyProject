import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String profileName;
  final String profileImage;

  const ProfileScreen({
    Key? key,
    required this.username,
    required this.profileName,
    required this.profileImage,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, String>> pypoPosts = [];
  final List<Map<String, String>> ppyPosts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Implement more options functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(widget.profileImage),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.profileName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '@${widget.username}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Palembang, Indonesia',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Fans', 0),
                        _buildStatColumn('Following', 0),
                        _buildStatColumn('Pypo', 1),
                        _buildStatColumn('Ppy', 7),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Implement follow functionality here
                          },
                          child: Text('Follow'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Implement send message functionality here
                          },
                          child: Text('Kirim Pesan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Pypo'),
                      Tab(text: 'Ppy'),
                      Tab(text: 'Replies'),
                      Tab(text: 'Likes'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
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

  Widget _buildStatColumn(String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
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
    // Implement the functionality for replies list
    return Center(child: Text("Replies List"));
  }

  Widget _buildLikesList() {
    // Implement the functionality for likes list
    return Center(child: Text("Likes List"));
  }

  Widget _buildPostPpyMainItem(Map<String, String> post) {
    return Card(
      child: ListTile(
        leading: Image.network(post['mediaUrl'] ?? 'https://example.com/default_image.png'),
        title: Text(post['title'] ?? 'No Title'),
        subtitle: Text(post['description'] ?? 'No Description'),
      ),
    );
  }
}

class ShowPypoScreen extends StatelessWidget {
  final List<Map<String, String>> postPypo;
  final int initialIndex;

  const ShowPypoScreen({
    Key? key,
    required this.postPypo,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pypo Detail'),
      ),
      body: Center(
        child: Text('Pypo detail view for post index $initialIndex'),
      ),
    );
  }
}
