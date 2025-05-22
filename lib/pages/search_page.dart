import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchUserPage extends StatefulWidget {
  static String tag = 'search-page';
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {_searchResults = []; });
      return;
    }

    final QuerySnapshot<Map<String, dynamic>> users = await FirebaseFirestore.instance
        .collection('Users') // ตามชื่อของคอลเล็กชันใน Firestore
        .where('username', isGreaterThanOrEqualTo: query) // ตามฟิลด์ที่ต้องการค้นหา
        .get();

    setState(() {
      _searchResults = users.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _searchUsers(value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final userData = _searchResults[index];
                return GestureDetector(
                  onTap: () {
                    // 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => 
                      ChatPage(receiverUsername: userData["username"], receiverID: userData["uid"],),),);
                  },
                  child: ListTile(
                    title: Text(userData['username']), // ฟิลด์ที่ต้องการแสดงผล
                    subtitle: Text(userData['email']), // ฟิลด์ที่ต้องการแสดงผล
                    // Add more user details here if needed
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}