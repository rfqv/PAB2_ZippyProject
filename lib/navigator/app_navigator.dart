import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippy/screens/main_session/home.dart';
import 'package:zippy/screens/main_session/notifikasi.dart';
import 'package:zippy/screens/main_session/pesan.dart';
import 'package:zippy/screens/main_session/profile.dart';
import 'package:zippy/services/user_settings_services.dart';

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
    final settings = Provider.of<UserSettingsService>(context);
    bool isDarkMode = settings.themeMode == ThemeMode.dark || (settings.themeMode == ThemeMode.system && MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      bottomNavigationBar: Container(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: BottomNavigationBar(
              backgroundColor: isDarkMode
                  ? Colors.grey[850]
                  : const Color(0xFF7DABCF),
              selectedItemColor: isDarkMode
                  ? Colors.white
                  : Colors.black,
              unselectedItemColor: isDarkMode
                  ? Colors.grey
                  : const Color(0xFFF7F7F7),
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
