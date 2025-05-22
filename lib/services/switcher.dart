import 'package:chat_app/components/my_bottom_navigation_bar.dart';
import 'package:chat_app/pages/notification_page.dart';
import 'package:chat_app/pages/chats_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class Switcher extends StatefulWidget {
  const Switcher({super.key});

  @override
  State<Switcher> createState() => _SwitchereState();
}

class _SwitchereState extends State<Switcher> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    const ChatListPage(),
    NotificationPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}