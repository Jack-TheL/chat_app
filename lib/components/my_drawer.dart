import 'package:flutter/material.dart';
import 'package:chat_app/pages/set_profile_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/pages/setting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<DocumentSnapshot>(
              future: _fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text("Error");
                }
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final username = userData['username'] as String;
                return Text(username);
              },
            ),
            accountEmail: FutureBuilder<DocumentSnapshot>(
              future: _fetchUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text("Error");
                }
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final email = userData['email'] as String;
                return Text(email);
              },
            ),
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(SetProfileIconPage.tag);
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/flutter.png'),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsPage.tag);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final authService = AuthService();
              await authService.singOut();
            },
          ),
        ],
      ),
    );
  }
  // get data
  Future<DocumentSnapshot> _fetchUserData() async {
    final user = AuthService().getCurrentUser();
    return await FirebaseFirestore.instance.collection("Users").doc(user!.uid).get();
  }
}
