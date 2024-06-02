import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zippy/screens/dmview.dart';

class Pesan extends StatelessWidget {
  const Pesan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(90),
            image: DecorationImage(
              image: AssetImage('images/profile_picture.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
=======
    return const Scaffold(
      body: Center(
        child: Text(
          'pesan',
>>>>>>> afdc4c28a126c9ae69d56e2209e836ae2de1018e
        ),
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [DmView()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color.fromARGB(255, 25, 157, 190),
        child: Icon(Icons.message_outlined),
      ),
    );
  }
}
