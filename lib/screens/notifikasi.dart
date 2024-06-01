import 'package:flutter/material.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({super.key});

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  final List<NotifikasiItem> notifications = [
    NotifikasiItem(username: 'Christ', action: 'commented on your ppy: follback pls', timestamp: '2m ago', profileImage: 'assets/users/favicon/username-itsmechrist-uid-254803.jpg', isFollowing: false),
    NotifikasiItem(username: 'Wonyoung', action: 'commented on your pypo: daebakkk<3', timestamp: '3m ago', profileImage: 'assets/users/favicon/username-for_everyoung10-uid-187436.jpg', isFollowing: true),
    NotifikasiItem(username: 'Irene', action: 'liked your pypo', timestamp: '20m ago', profileImage: 'assets/users/favicon/username-renebaebae-uid-151135.jpg', isFollowing: true),
    NotifikasiItem(username: 'Nounwoo', action: 'commented on your pypo: Cakeup btl!!', timestamp: '1h ago', profileImage: 'assets/users/favicon/username-leedongwook_official-uid-130743.jpg', isFollowing: true),
    NotifikasiItem(username: 'Nounwoo', action: 'liked your pypo', timestamp: '1h ago', profileImage: 'assets/users/favicon/username-leedongwook_official-uid-130743.jpg', isFollowing: true),
    NotifikasiItem(username: 'Christ', action: 'liked your pypo', timestamp: '2h ago', profileImage: 'assets/users/favicon/username-itsmechrist-uid-254803.jpg', isFollowing: false),
    NotifikasiItem(username: 'Christ', action: 'started following you', timestamp: '2h ago', profileImage: 'assets/users/favicon/username-itsmechrist-uid-254803.jpg', isFollowing: false),
    NotifikasiItem(username: 'Ethan', action: 'started following you', timestamp: '4d ago', profileImage: 'assets/users/favicon/username-ethan1610-uid-256944.jpg', isFollowing: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Page'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotifikasiWidget(notification: notifications[index]);
        },
      ),
    );
  }
}

class NotifikasiItem {
  final String username;
  final String action;
  final String timestamp;
  final String profileImage;
  bool isFollowing;

  NotifikasiItem({required this.username, required this.action, required this.timestamp, required this.profileImage, required this.isFollowing});
}

class NotifikasiWidget extends StatefulWidget {
  final NotifikasiItem notification;

  NotifikasiWidget({required this.notification});

  @override
  _NotifikasiWidgetState createState() => _NotifikasiWidgetState();
}

class _NotifikasiWidgetState extends State<NotifikasiWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(widget.notification.profileImage),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.notification.username,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: ' ${widget.notification.action}',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      subtitle: Text(widget.notification.timestamp),
      trailing: widget.notification.action == 'started following you' 
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: widget.notification.isFollowing ? Colors.grey : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                widget.notification.isFollowing = !widget.notification.isFollowing;
              });
            },
            child: Text(widget.notification.isFollowing ? 'Following' : 'Follow Back'),
          )
        : null,
      onTap: () {
        // Handle notification tap
      },
    );
  }
}
