import 'package:chat_app/pages/search_conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  static String tag = 'profile-page';
  final String userID;
  const ProfilePage({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_off_sharp),
            onPressed: () {
              Navigator.of(context).pushNamed(ChatHistorySearchPage.tag);
            }, // Navigate to settings page
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/flutter.png'), // Profile image
          ),
          const SizedBox(height: 20),
          FutureBuilder( // fetchIserData From FireStor
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('Error');
              }
              final userData = snapshot.data as Map<String, dynamic>; //
              final username = userData['username'] as String; //
              final email = userData['email'] as String;  //
              return Column(
                children: [
                  Text(
                    username, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email, style: const TextStyle(fontSize: 16),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.block),
                    onPressed: () {}, //Handle block action
                  ),const Text('Block'),
                ],
              ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.volume_off),
                onPressed: () {}, // Handle mute action
                ), const Text('Mute'),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.palette),
                onPressed: () {},// Handle change theme action
              ), const Text('Change Theme'),
            ],),
        ],),],
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final snapshot = await AuthService().getUserData(userID);
    return snapshot.data() as Map<String, dynamic>;
  }
}
