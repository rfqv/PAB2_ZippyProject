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
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Implement edit profile functionality here
                          },
                          child: Text('Edit Profile'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Implement share profile functionality here
                          },
                          child: Text('Share Profile'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Pypo'),
                Tab(text: 'Ppy'),
                Tab(text: 'Replies'),
                Tab(text: 'Likes'),
              ],
            ),
            Container(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent(),
                  _buildTabContent(),
                  _buildTabContent(),
                  _buildTabContent(),
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

  Widget _buildTabContent() {
    return ListView.builder(
      itemCount: 1, // Replace with actual item count
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.network(widget.profileImage),
            title: Text('Post Title'),
            subtitle: Text('Post subtitle or description'),
          ),
        );
      },
    );
  }
}
