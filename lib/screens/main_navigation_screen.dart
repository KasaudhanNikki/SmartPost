import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'rocket_screen.dart';
import 'search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _bottomNavIndex = 2;

  static const _pages = <Widget>[
    RocketScreen(),
    SearchScreen(),
    HomeScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _pages,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            enableFeedback: false,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _bottomNavIndex,
            onTap: (index) => setState(() => _bottomNavIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.rocket_launch_outlined, size: 28),
                label: 'Rocket',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 28),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline, size: 26),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 30),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
