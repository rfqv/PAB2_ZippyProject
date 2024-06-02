import 'package:flutter/material.dart';
import 'package:zippy/screens/home.dart';
import 'package:zippy/screens/notifikasi.dart';
import 'package:zippy/screens/pesan.dart';
import 'package:zippy/screens/profile.dart';

class MyBottomNavbar extends StatefulWidget {
  const MyBottomNavbar({super.key});

  @override
  State<MyBottomNavbar> createState() => _MyBottomNavbarState();
}

class _MyBottomNavbarState extends State<MyBottomNavbar> {
  int myCurrentIndex = 0;
  List<Widget> pages = const [
    HomePage(),
    Pesan(),
    Notifikasi(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 25, 157, 190),
              selectedItemColor: const Color.fromARGB(255, 5, 5, 5),
              unselectedItemColor: const Color.fromARGB(255, 247, 247, 247),
              type: BottomNavigationBarType.fixed,
              currentIndex: myCurrentIndex,
              onTap: (Index) {
                setState(() {
                  myCurrentIndex = Index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  label: "",
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: Icon(Icons.chat_sharp),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: Icon(Icons.notification_add_sharp),
                ),
                BottomNavigationBarItem(
                  label: "",
                  icon: Icon(Icons.person),
                ),
              ]),
        ),
      ),
      body: pages[myCurrentIndex],
    );
  }
}
