import 'package:flutter/material.dart';
import 'package:zippy/screens/home.dart';
import 'package:zippy/screens/notifikasi.dart';
import 'package:zippy/screens/pesan.dart';
import 'package:zippy/screens/profile.dart';

class MyButtomNavbar extends StatefulWidget {
  const MyButtomNavbar({super.key});

  @override
  State<MyButtomNavbar> createState() => _MyButtomNavbarState();
}

class _MyButtomNavbarState extends State<MyButtomNavbar> {
  int myCurrentIndex = 0;
  List pages = [
    Home(),
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
