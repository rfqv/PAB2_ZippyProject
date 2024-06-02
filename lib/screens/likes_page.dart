import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Likes Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: const Text('Janeya'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            ProfileStats(),
            ProfileButtons(),
            ProfileTabs(),
            PostList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[100],
      child: const Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('assets/janeyaprofil.jpeg'),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Janeya',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '@janeya97',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                'Palembang, Indonesia',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[200],
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ProfileStat(count: '25K', label: 'Fans'),
          ProfileStat(count: '458', label: 'Following'),
          ProfileStat(count: '3571', label: 'Pypo'),
          ProfileStat(count: '81', label: 'Ppy'),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String count;
  final String label;

  const ProfileStat({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Followed'),
        ),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Message'),
        ),
      ],
    );
  }
}

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Pypo'),
              Tab(text: 'Ppy'),
              Tab(text: 'Replies'),
              Tab(text: 'Likes'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                PostList(),
                Center(child: Text('Ppy')),
                Center(child: Text('Replies')),
                Center(child: Text('Likes')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Post(
          username: 'Davikah',
          handle: '@davika8',
          time: '13:21 7 Apr 24',
          content:
              'Aku habis beli naskun trs minta jgn pake kerupuk, tpi malah dikasih ENAM BUNGKUS TUH GMNA YAH',
          imageUrl: 'Davika.jpg',
          views: '450 views',
        ),
        Post(
          username: 'Arlhino',
          handle: '@msigluno',
          time: '13:21 7 Apr 24',
          content: 'KONDANGAN DULU GAK SEEEH',
          imageUrl: 'lino1.jpeg', // ini tambahin foto si cowok "lino 1 dan 2"
          views: '77 views',
        ),
      ],
    );
  }
}

class Post extends StatelessWidget {
  final String username;
  final String handle;
  final String time;
  final String content;
  final String? imageUrl;
  final String views;

  const Post({super.key, 
    required this.username,
    required this.handle,
    required this.time,
    required this.content,
    this.imageUrl,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(handle),
                ],
              ),
              const Spacer(),
              Text(time),
            ],
          ),
          const SizedBox(height: 8),
          Text(content),
          imageUrl != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(imageUrl!),
                )
              : Container(),
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline),
              const SizedBox(width: 8),
              const Icon(Icons.favorite_border),
              const SizedBox(width: 8),
              Text(views),
            ],
          ),
        ],
      ),
    );
  }
}
