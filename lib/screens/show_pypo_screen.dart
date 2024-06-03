import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ShowPypoScreen extends StatefulWidget {
  final List<String> postPypo;
  final int initialIndex;

  const ShowPypoScreen({required this.postPypo, required this.initialIndex, Key? key}) : super(key: key);

  @override
  _ShowPypoScreenState createState() => _ShowPypoScreenState();
}

class _ShowPypoScreenState extends State<ShowPypoScreen> {
  PageController? _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _likePypo(int index) {
    setState(() {
      // Toggle like status
    });
    // Save like status to Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pypo'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.postPypo.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: Image.asset(widget.postPypo[index], fit: BoxFit.cover),
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
                    color: /* Check if liked */ false ? Colors.red : Colors.grey,
                    onPressed: () {
                      _likePypo(index);
                    },
                  ),
                ],
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
