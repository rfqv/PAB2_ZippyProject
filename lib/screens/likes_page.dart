import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Likes Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text('Janeya'),
      ),
      body: SingleChildScrollView(
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
        items: [
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.blue[100],
      child: Row(
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.blue[200],
      child: Row(
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

  ProfileStat({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

class ProfileButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('Followed'),
        ),
        OutlinedButton(
          onPressed: () {},
          child: Text('Message'),
        ),
      ],
    );
  }
}

class ProfileTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          Container(
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
  @override
  Widget build(BuildContext context) {
    return Column(
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

  Post({
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
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(handle),
                ],
              ),
              Spacer(),
              Text(time),
            ],
          ),
          SizedBox(height: 8),
          Text(content),
          imageUrl != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(imageUrl!),
                )
              : Container(),
          Row(
            children: [
              Icon(Icons.chat_bubble_outline),
              SizedBox(width: 8),
              Icon(Icons.favorite_border),
              SizedBox(width: 8),
              Text(views),
            ],
          ),
        ],
      ),
    );
  }
}
