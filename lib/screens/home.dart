import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'zippy',
              style: TextStyle(fontWeight: FontWeight.bold),
=======
    return SafeArea(
      child: ListView(
        children: const [
          //appbar home
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "zippy",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.search,
                    )
                  ],
                )
              ],
>>>>>>> afdc4c28a126c9ae69d56e2209e836ae2de1018e
            ),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }
}
