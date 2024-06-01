import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'zippy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }
}
