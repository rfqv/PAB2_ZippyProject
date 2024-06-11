import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class ShowUserDMScreen extends StatefulWidget {
  final String currentUsername;
  final String chatWithUsername;

  const ShowUserDMScreen({
    super.key,
    required this.currentUsername,
    required this.chatWithUsername, required String username,
  });

  @override
  _ShowUserDMScreenState createState() => _ShowUserDMScreenState();
}

class _ShowUserDMScreenState extends State<ShowUserDMScreen> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final messageData = {
        'sender': widget.currentUsername,
        'receiver': widget.chatWithUsername,
        'message': _messageController.text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      _messagesRef.push().set(messageData).then((_) {
        _messageController.clear();
      }).catchError((error) {
        print('Error sending message: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.chatWithUsername}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: _messagesRef,
              itemBuilder: (context, snapshot, animation, index) {
                final messageData = Map<String, dynamic>.from(snapshot.value as Map);
                final isCurrentUser = messageData['sender'] == widget.currentUsername;
                final isChattingWithCurrentUser = (messageData['receiver'] == widget.currentUsername && messageData['sender'] == widget.chatWithUsername) || 
                                                   (messageData['sender'] == widget.currentUsername && messageData['receiver'] == widget.chatWithUsername);
                if (isChattingWithCurrentUser) {
                  return _buildMessageBubble(messageData, isCurrentUser);
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> messageData, bool isCurrentUser) {
    final alignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isCurrentUser ? Colors.blue : Colors.grey[300];
    final textColor = isCurrentUser ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              messageData['message'],
              style: TextStyle(color: textColor),
            ),
          ),
          Text(
            DateTime.fromMillisecondsSinceEpoch(messageData['timestamp']).toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
